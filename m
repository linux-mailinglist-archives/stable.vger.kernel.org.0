Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1A524E7AE
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 15:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgHVNjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 09:39:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33776 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbgHVNjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 09:39:03 -0400
Date:   Sat, 22 Aug 2020 13:39:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598103540;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sCEkJx8t5gzQnXF0Oa3zM4Cg7Tuy/+WoChgi1OWUv1M=;
        b=eZWc7ut0zIOyDWbl1u4dmbn8CEfmdKo3rY/Xmz1P0O1bAWxRFP9KKa7FWkdfmkDuJNYhEm
        RSPdhh2jQP46UPl/8DkvXwHSRDlgg4PBZMbfIxoIDoo2dZ6hw+nCVxi2vpGrTu9bQuKYYu
        mICpqKnf+Vxbl9/pxcIpB9k0cRlPmbGA50i1dIkXhe4nf834efPUlmC5DfcFOSsZeCzDSe
        tAG/nCVRLdqk2nKL9EDO7RNMWq3yjWAmTZsRqeMNuInkvTdND1IAsRD4qSQwlcLUnbQdvx
        zOQ0T3ix3jyZuVTGH8oSaPNLYEOukoHM6SEXNEMMmPhubZzIlARoBfw+kXiRUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598103540;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sCEkJx8t5gzQnXF0Oa3zM4Cg7Tuy/+WoChgi1OWUv1M=;
        b=jp9ZGybj91lkev0EgDqgiB+r/iTAI1fDBdOpMvsM+ARD/zhztqur4MQirY0NP5E/z2CSu3
        RknDDidMXoYRG0AA==
From:   "tip-bot2 for Arvind Sankar" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/libstub: Stop parsing arguments at "--"
Cc:     <stable@vger.kernel.org>, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200725155916.1376773-1-nivedita@alum.mit.edu>
References: <20200725155916.1376773-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Message-ID: <159810354014.3192.667815415521624242.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     1fd9717d75df68e3c3509b8e7b1138ca63472f88
Gitweb:        https://git.kernel.org/tip/1fd9717d75df68e3c3509b8e7b1138ca63472f88
Author:        Arvind Sankar <nivedita@alum.mit.edu>
AuthorDate:    Sat, 25 Jul 2020 11:59:16 -04:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Thu, 20 Aug 2020 11:18:52 +02:00

efi/libstub: Stop parsing arguments at "--"

Arguments after "--" are arguments for init, not for the kernel.

Cc: <stable@vger.kernel.org>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200725155916.1376773-1-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 6bca70b..37ff34e 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -201,6 +201,8 @@ efi_status_t efi_parse_options(char const *cmdline)
 		char *param, *val;
 
 		str = next_arg(str, &param, &val);
+		if (!val && !strcmp(param, "--"))
+			break;
 
 		if (!strcmp(param, "nokaslr")) {
 			efi_nokaslr = true;
