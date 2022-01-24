Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1144499AF4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447380AbiAXVsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:48:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59720 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457446AbiAXVlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A3AB61523;
        Mon, 24 Jan 2022 21:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04019C340E4;
        Mon, 24 Jan 2022 21:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060499;
        bh=alN1nGi9d01VTi67hSzdh6Vdn9Sl4cPFqezMOL+KxcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymHtSzLFJxFp1ta+zgmHrQuy9wty/+BaYr93cGG+JgLCuhrj0bKjdXxYbux7RVKf8
         PtEpgKweek7JTm38UhYOK4UwftFxqQvpo6VeZsg3R9uUskcX/egbx2u3p0av7bkxMN
         vXEwp+KYCDVLMTtahOMZ9bf9HOT7NG1Yb3Q7OMfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Yafang Shao <laoar.shao@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.16 0941/1039] bpf: Fix mount source show for bpffs
Date:   Mon, 24 Jan 2022 19:45:30 +0100
Message-Id: <20220124184156.918367031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

commit 1e9d74660d4df625b0889e77018f9e94727ceacd upstream.

We noticed our tc ebpf tools can't start after we upgrade our in-house kernel
version from 4.19 to 5.10. That is because of the behaviour change in bpffs
caused by commit d2935de7e4fd ("vfs: Convert bpf to use the new mount API").

In our tc ebpf tools, we do strict environment check. If the environment is
not matched, we won't allow to start the ebpf progs. One of the check is whether
bpffs is properly mounted. The mount information of bpffs in kernel-4.19 and
kernel-5.10 are as follows:

- kernel 4.19
$ mount -t bpf bpffs /sys/fs/bpf
$ mount -t bpf
bpffs on /sys/fs/bpf type bpf (rw,relatime)

- kernel 5.10
$ mount -t bpf bpffs /sys/fs/bpf
$ mount -t bpf
none on /sys/fs/bpf type bpf (rw,relatime)

The device name in kernel-5.10 is displayed as none instead of bpffs, then our
environment check fails. Currently we modify the tools to adopt to the kernel
behaviour change, but I think we'd better change the kernel code to keep the
behavior consistent.

After this change, the mount information will be displayed the same with the
behavior in kernel-4.19, for example:

$ mount -t bpf bpffs /sys/fs/bpf
$ mount -t bpf
bpffs on /sys/fs/bpf type bpf (rw,relatime)

Fixes: d2935de7e4fd ("vfs: Convert bpf to use the new mount API")
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/bpf/20220108134623.32467-1-laoar.shao@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/inode.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -648,12 +648,22 @@ static int bpf_parse_param(struct fs_con
 	int opt;
 
 	opt = fs_parse(fc, bpf_fs_parameters, param, &result);
-	if (opt < 0)
+	if (opt < 0) {
 		/* We might like to report bad mount options here, but
 		 * traditionally we've ignored all mount options, so we'd
 		 * better continue to ignore non-existing options for bpf.
 		 */
-		return opt == -ENOPARAM ? 0 : opt;
+		if (opt == -ENOPARAM) {
+			opt = vfs_parse_fs_param_source(fc, param);
+			if (opt != -ENOPARAM)
+				return opt;
+
+			return 0;
+		}
+
+		if (opt < 0)
+			return opt;
+	}
 
 	switch (opt) {
 	case OPT_MODE:


