Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808703CE00C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345578AbhGSPNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345577AbhGSPMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:12:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57566611C1;
        Mon, 19 Jul 2021 15:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709948;
        bh=HV1MLfedn3XT6CZHdODiskzqRmk01XBA4SoaqgvM40A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBYss1n1a7iTtBNP+hfRlinZ9FyE1LwM2mvWXl2rm9KyqZyGvFj7Iznt8qlqfBQ1+
         hoYIyybiThENWBq+sa67TSBnYJN9HJM/c19VH3OpABrqrfMWYeRxKYTKraI/oW6NCq
         5m6gvnwipbiDF04RkWkmF1lwOH5kd84eFdezdjiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dmitry Vyukov <dvyukov@google.com>, stable@kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 013/243] cgroup: verify that source is a string
Date:   Mon, 19 Jul 2021 16:50:42 +0200
Message-Id: <20210719144941.350123087@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 3b0462726e7ef281c35a7a4ae33e93ee2bc9975b upstream.

The following sequence can be used to trigger a UAF:

    int fscontext_fd = fsopen("cgroup");
    int fd_null = open("/dev/null, O_RDONLY);
    int fsconfig(fscontext_fd, FSCONFIG_SET_FD, "source", fd_null);
    close_range(3, ~0U, 0);

The cgroup v1 specific fs parser expects a string for the "source"
parameter.  However, it is perfectly legitimate to e.g.  specify a file
descriptor for the "source" parameter.  The fs parser doesn't know what
a filesystem allows there.  So it's a bug to assume that "source" is
always of type fs_value_is_string when it can reasonably also be
fs_value_is_file.

This assumption in the cgroup code causes a UAF because struct
fs_parameter uses a union for the actual value.  Access to that union is
guarded by the param->type member.  Since the cgroup paramter parser
didn't check param->type but unconditionally moved param->string into
fc->source a close on the fscontext_fd would trigger a UAF during
put_fs_context() which frees fc->source thereby freeing the file stashed
in param->file causing a UAF during a close of the fd_null.

Fix this by verifying that param->type is actually a string and report
an error if not.

In follow up patches I'll add a new generic helper that can be used here
and by other filesystems instead of this error-prone copy-pasta fix.
But fixing it in here first makes backporting a it to stable a lot
easier.

Fixes: 8d2451f4994f ("cgroup1: switch to option-by-option parsing")
Reported-by: syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@kernel.org>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -912,6 +912,8 @@ int cgroup1_parse_param(struct fs_contex
 	opt = fs_parse(fc, cgroup1_fs_parameters, param, &result);
 	if (opt == -ENOPARAM) {
 		if (strcmp(param->key, "source") == 0) {
+			if (param->type != fs_value_is_string)
+				return invalf(fc, "Non-string source");
 			if (fc->source)
 				return invalf(fc, "Multiple sources not supported");
 			fc->source = param->string;


