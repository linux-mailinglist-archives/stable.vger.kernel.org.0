Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFA24E7B0
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgHVNjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 09:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgHVNjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 09:39:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58967C061573;
        Sat, 22 Aug 2020 06:39:03 -0700 (PDT)
Date:   Sat, 22 Aug 2020 13:39:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598103541;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6HkVMU3f6JIQIoXgMrXSqlEbU5+ibf0CxupnWEepw4=;
        b=yBhZ7LFzZTIxJ0amQuwgc78KgK997t4WqE7vTqwd02MsP9eCVPX400E0n0CiOmLxTwMnGE
        8KqDDnpEPTkSCN9T8ogu3O5DWcIhXt6WBh1/5sNGfMConV8c4KYRcD1rHsiqJO42pIHP3x
        vsPV2I465ezpkRFKKT2DLrS7Yj9Y8xuATxH9Cxmf80OFi3OEE5eIIc93InugePAuGw9yba
        CkNDzAPR6ULU1vbnO8YeL/Zf/5NlMXO/4TJINtjkstChg3UOPx0CO1kPske9RjXwpzEiwU
        w34tpY2Byrw1+HU8SVMbJzKidiJEBPswgkjBFnbDNHpjnQlCHrLplgRkl+UaXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598103541;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6HkVMU3f6JIQIoXgMrXSqlEbU5+ibf0CxupnWEepw4=;
        b=mnabc2eT61/wLQqzLXhfXtfKxeiLFMp8g5SiAIVIg//C2URVxNnHBUqaNZ1pL07ljqMLCe
        /7OMwG5tFh7dmyCA==
From:   "tip-bot2 for Li Heng" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi: add missed destroy_workqueue when efisubsys_init fails
Cc:     <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>,
        Li Heng <liheng40@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1595229738-10087-1-git-send-email-liheng40@huawei.com>
References: <1595229738-10087-1-git-send-email-liheng40@huawei.com>
MIME-Version: 1.0
Message-ID: <159810354080.3192.12090747441096902319.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     98086df8b70c06234a8f4290c46064e44dafa0ed
Gitweb:        https://git.kernel.org/tip/98086df8b70c06234a8f4290c46064e44dafa0ed
Author:        Li Heng <liheng40@huawei.com>
AuthorDate:    Mon, 20 Jul 2020 15:22:18 +08:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Thu, 20 Aug 2020 11:18:45 +02:00

efi: add missed destroy_workqueue when efisubsys_init fails

destroy_workqueue() should be called to destroy efi_rts_wq
when efisubsys_init() init resources fails.

Cc: <stable@vger.kernel.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
Link: https://lore.kernel.org/r/1595229738-10087-1-git-send-email-liheng40@huawei.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index fdd1db0..3aa07c3 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -381,6 +381,7 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
+		destroy_workqueue(efi_rts_wq);
 		return -ENOMEM;
 	}
 
@@ -424,6 +425,7 @@ err_unregister:
 		generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
+	destroy_workqueue(efi_rts_wq);
 	return error;
 }
 
