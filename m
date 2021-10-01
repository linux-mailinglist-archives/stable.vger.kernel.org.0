Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C16541EA1F
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 11:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353240AbhJAJyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 05:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353236AbhJAJyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 05:54:21 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A5BC061775;
        Fri,  1 Oct 2021 02:52:37 -0700 (PDT)
Date:   Fri, 01 Oct 2021 09:52:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633081955;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQF2GC7PP3ik/rdt9jcKV+yUP1P9cj4TUA2No4CVKmE=;
        b=spRGud5Cqj4isxGr2ChanGYmhIzYiNF/c6grZW/U4/ChzHzNnc1Cnn4xJP+cUIC9hb/bup
        Ft5SZ9CqDWQ27mcEAbovClWSaiAi3KkcFX+Wxa/o0qnynVqiDDQBWPXndYF78opY4jgkNd
        qB2qNUY9Hg7+e67rdmTCZh2odXkF+s1w+NO2BA59w78z4GkAwq+DHn/0X+yJyrKPPXeysd
        7T+H8x1TGG1u8pKI1JqW4pYR1UCKZQ82dsxJJlGGSk990Q215chtXTPltMZHLbNEJ38zAO
        xMnCofEU5wKT+c8k0MwpRydetiozh48i56zRo50nsSmFEawrrE1h3zfa31EJ+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633081955;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQF2GC7PP3ik/rdt9jcKV+yUP1P9cj4TUA2No4CVKmE=;
        b=ZxbMg6YoLLvXx5kZazg9AtxjTNqID0WDKow+w3VXNGfmb7ZEf4ZsokO61x6e/JO5NFLJLR
        eugzLVGHUdWsRVAQ==
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev: Return an error on a returned non-zero
 SW_EXITINFO1[31:0]
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Cefc772af831e9e7f517f0439b13b41f56bad8784=2E16330?=
 =?utf-8?q?63321=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
References: =?utf-8?q?=3Cefc772af831e9e7f517f0439b13b41f56bad8784=2E163306?=
 =?utf-8?q?3321=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <163308195430.25758.9298065722458178197.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     06f2ac3d4219bbbfd93d79e01966a42053084f11
Gitweb:        https://git.kernel.org/tip/06f2ac3d4219bbbfd93d79e01966a42053084f11
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Thu, 30 Sep 2021 23:42:01 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 01 Oct 2021 11:14:41 +02:00

x86/sev: Return an error on a returned non-zero SW_EXITINFO1[31:0]

After returning from a VMGEXIT NAE event, SW_EXITINFO1[31:0] is checked
for a value of 1, which indicates an error and that SW_EXITINFO2
contains exception information. However, future versions of the GHCB
specification may define new values for SW_EXITINFO1[31:0], so really
any non-zero value should be treated as an error.

Fixes: 597cfe48212a ("x86/boot/compressed/64: Setup a GHCB-based VC Exception handler")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # 5.10+
Link: https://lkml.kernel.org/r/efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com
---
 arch/x86/kernel/sev-shared.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 9f90f46..bf1033a 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -130,6 +130,8 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 		} else {
 			ret = ES_VMM_ERROR;
 		}
+	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
+		ret = ES_VMM_ERROR;
 	} else {
 		ret = ES_OK;
 	}
