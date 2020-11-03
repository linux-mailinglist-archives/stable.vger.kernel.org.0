Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070A42A5411
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbgKCVHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388311AbgKCVHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:07:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F382205ED;
        Tue,  3 Nov 2020 21:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437658;
        bh=DkaiWdgXdPpmYkXen4EmdiCbkbN3LFjCEHg6J12kaFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiIUaNqwQINs2PaBh/w8/IkWBKGyP/3PeSgfhUvsxW0pdXtxmwh16Dzc3+8qxO8J1
         tLIBcF/Nts4CON3l8ZNoho9OvCCxEQTGt4AJaT7NY6EeuiswlN5rdoXmXw7YaWWz/1
         T4bWzq1aUO9zkhVfmE3pd3I/NRVMo5d4wobjmSWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 132/191] btrfs: use kvzalloc() to allocate clone_roots in btrfs_ioctl_send()
Date:   Tue,  3 Nov 2020 21:37:04 +0100
Message-Id: <20201103203245.418735460@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit 8eb2fd00153a3a96a19c62ac9c6d48c2efebe5e8 upstream.

btrfs_ioctl_send() used open-coded kvzalloc implementation earlier.
The code was accidentally replaced with kzalloc() call [1]. Restore
the original code by using kvzalloc() to allocate sctx->clone_roots.

[1] https://patchwork.kernel.org/patch/9757891/#20529627

Fixes: 818e010bf9d0 ("btrfs: replace opencoded kvzalloc with the helper")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Denis Efremov <efremov@linux.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6859,7 +6859,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 
 	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
 
-	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL);
+	sctx->clone_roots = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!sctx->clone_roots) {
 		ret = -ENOMEM;
 		goto out;


