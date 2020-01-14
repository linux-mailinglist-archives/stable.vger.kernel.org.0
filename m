Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B2813A539
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgANKFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbgANKFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C6224683;
        Tue, 14 Jan 2020 10:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996340;
        bh=sbl4UHn02AWHf0pfvvgwLZS/ij6DwQksVxXf3qeOdro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsqLjwCryoFdXKVT013k/w7TF0NptzLam5LZ9snAFp4g5FZ/G9FklCrjL541zbo//
         OzcqxqSXTf9x1+gF3+XHQkUj0gOLGYKfl/EG6fdp4vV4DtBoU+aVvlUrj3nxDKECDW
         plg0FgWzRu60V86jtr9RMb+yN4bm9974FsOd+MQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cengiz Can <cengiz@kernel.wtf>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 39/78] pstore/ram: Regularize prz label allocation lifetime
Date:   Tue, 14 Jan 2020 11:01:13 +0100
Message-Id: <20200114094358.836312422@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit e163fdb3f7f8c62dccf194f3f37a7bcb3c333aa8 upstream.

In my attempt to fix a memory leak, I introduced a double-free in the
pstore error path. Instead of trying to manage the allocation lifetime
between persistent_ram_new() and its callers, adjust the logic so
persistent_ram_new() always takes a kstrdup() copy, and leaves the
caller's allocation lifetime up to the caller. Therefore callers are
_always_ responsible for freeing their label. Before, it only needed
freeing when the prz itself failed to allocate, and not in any of the
other prz failure cases, which callers would have no visibility into,
which is the root design problem that lead to both the leak and now
double-free bugs.

Reported-by: Cengiz Can <cengiz@kernel.wtf>
Link: https://lore.kernel.org/lkml/d4ec59002ede4aaf9928c7f7526da87c@kernel.wtf
Fixes: 8df955a32a73 ("pstore/ram: Fix error-path memory leak in persistent_ram_new() callers")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/ram.c      |    4 ++--
 fs/pstore/ram_core.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -583,12 +583,12 @@ static int ramoops_init_przs(const char
 		prz_ar[i] = persistent_ram_new(*paddr, zone_sz, sig,
 					       &cxt->ecc_info,
 					       cxt->memtype, flags, label);
+		kfree(label);
 		if (IS_ERR(prz_ar[i])) {
 			err = PTR_ERR(prz_ar[i]);
 			dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 				name, record_size,
 				(unsigned long long)*paddr, err);
-			kfree(label);
 
 			while (i > 0) {
 				i--;
@@ -629,12 +629,12 @@ static int ramoops_init_prz(const char *
 	label = kasprintf(GFP_KERNEL, "ramoops:%s", name);
 	*prz = persistent_ram_new(*paddr, sz, sig, &cxt->ecc_info,
 				  cxt->memtype, PRZ_FLAG_ZAP_OLD, label);
+	kfree(label);
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
-		kfree(label);
 		return err;
 	}
 
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -574,7 +574,7 @@ struct persistent_ram_zone *persistent_r
 	/* Initialize general buffer state. */
 	raw_spin_lock_init(&prz->buffer_lock);
 	prz->flags = flags;
-	prz->label = label;
+	prz->label = kstrdup(label, GFP_KERNEL);
 
 	ret = persistent_ram_buffer_map(start, size, prz, memtype);
 	if (ret)


