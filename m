Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D494497E78
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiAXMHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:07:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33772 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbiAXMHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:07:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D96D3B80EFA
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEE4C340E1;
        Mon, 24 Jan 2022 12:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643026031;
        bh=N8UzxCyENONkYkFs6bSkCs9p1NLXwU5lqZKK5aVd8Zg=;
        h=Subject:To:Cc:From:Date:From;
        b=PEZS6Ic6ZzoJ74fKjQv/RaKtPoJi0k023X8J083pJZbhovPC0KUaYfpRZSTMh4GXs
         N5JVdIy6mkYWanHpyqvULq/CXv9BmWYrwhAT02stbn1Fo8eAdMClS5DVWZiKYT9ioD
         zImCLMGxa84UZh+9AOvPKAaWiqCGkryhf0pg7tQs=
Subject: FAILED: patch "[PATCH] bpf: Fix mount source show for bpffs" failed to apply to 5.4-stable tree
To:     laoar.shao@gmail.com, christian.brauner@ubuntu.com,
        daniel@iogearbox.net, dhowells@redhat.com, viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:07:08 +0100
Message-ID: <1643026028171173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1e9d74660d4df625b0889e77018f9e94727ceacd Mon Sep 17 00:00:00 2001
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 8 Jan 2022 13:46:23 +0000
Subject: [PATCH] bpf: Fix mount source show for bpffs

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

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 80da1db47c68..5a8d9f7467bf 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -648,12 +648,22 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
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

