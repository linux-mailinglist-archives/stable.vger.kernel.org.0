Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2514D33D3
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiCIQMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbiCIQJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CCB141FD2;
        Wed,  9 Mar 2022 08:06:40 -0800 (PST)
Date:   Wed, 09 Mar 2022 16:06:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646841970;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2g65x9ztxAkTmxo73uRO4aFARnGFyHbVJ087622A2Ok=;
        b=jmdQpad5VseS6hwyAXD8a8jBDMN0kcIQdJu154U5pMayON69DaI6jQnBBCgS93lWYIfjTM
        SGePqAnljpwIuHc8qEIsih0AzONxCenAqUeSfEc4UuLMlVQEmJiy1tsVofr/gdtzuvrII1
        kJP34XkVEqXKrgwXe/mc7Ua5PpDvCbPA8nFZxQRc42HLuKcfC11lCtuQ9CYeQZOPB+bj/E
        uvff3cSSSW2MZunbpss871RD97idHAHVBUUpZf8dlwTy3CO+iFzWHmmsmfNUSm1uYEqrNN
        HYWb8kFsrME09kubk/ZW1pKTjgm2zKDxIg5sL8/RtRYW3Z3FjZSnm9gY+U4Gww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646841970;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2g65x9ztxAkTmxo73uRO4aFARnGFyHbVJ087622A2Ok=;
        b=WEITcfV4TrSdeFAnQvLVAdZ6RJuXGKSnxuLX7A/8NpXOcarOHgIfS6xxlEbMfPxrNakVaB
        30i6DAtk8/hKlwDA==
From:   "tip-bot2 for Ross Philipson" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot: Add setup_indirect support in
 early_memremap_is_setup_data()
Cc:     Ross Philipson <ross.philipson@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1645668456-22036-3-git-send-email-ross.philipson@oracle.com>
References: <1645668456-22036-3-git-send-email-ross.philipson@oracle.com>
MIME-Version: 1.0
Message-ID: <164684196918.16921.3379747739770954386.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     445c1470b6ef96440e7cfc42dfc160f5004fd149
Gitweb:        https://git.kernel.org/tip/445c1470b6ef96440e7cfc42dfc160f5004fd149
Author:        Ross Philipson <ross.philipson@oracle.com>
AuthorDate:    Wed, 23 Feb 2022 21:07:36 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Mar 2022 12:49:46 +01:00

x86/boot: Add setup_indirect support in early_memremap_is_setup_data()

The x86 boot documentation describes the setup_indirect structures and
how they are used. Only one of the two functions in ioremap.c that needed
to be modified to be aware of the introduction of setup_indirect
functionality was updated. Adds comparable support to the other function
where it was missing.

Fixes: b3c72fc9a78e ("x86/boot: Introduce setup_indirect")
Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1645668456-22036-3-git-send-email-ross.philipson@oracle.com
---
 arch/x86/mm/ioremap.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ab666c4..17a492c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -676,22 +676,51 @@ static bool memremap_is_setup_data(resource_size_t phys_addr,
 static bool __init early_memremap_is_setup_data(resource_size_t phys_addr,
 						unsigned long size)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
 	u64 paddr, paddr_next;
 
 	paddr = boot_params.hdr.setup_data;
 	while (paddr) {
-		unsigned int len;
+		unsigned int len, size;
 
 		if (phys_addr == paddr)
 			return true;
 
 		data = early_memremap_decrypted(paddr, sizeof(*data));
+		if (!data) {
+			pr_warn("failed to early memremap setup_data entry\n");
+			return false;
+		}
+
+		size = sizeof(*data);
 
 		paddr_next = data->next;
 		len = data->len;
 
-		early_memunmap(data, sizeof(*data));
+		if ((phys_addr > paddr) && (phys_addr < (paddr + len))) {
+			early_memunmap(data, sizeof(*data));
+			return true;
+		}
+
+		if (data->type == SETUP_INDIRECT) {
+			size += len;
+			early_memunmap(data, sizeof(*data));
+			data = early_memremap_decrypted(paddr, size);
+			if (!data) {
+				pr_warn("failed to early memremap indirect setup_data\n");
+				return false;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				paddr = indirect->addr;
+				len = indirect->len;
+			}
+		}
+
+		early_memunmap(data, size);
 
 		if ((phys_addr > paddr) && (phys_addr < (paddr + len)))
 			return true;
