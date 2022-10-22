Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A466089FE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiJVIp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiJVIoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAD72EC219;
        Sat, 22 Oct 2022 01:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9EF360B8E;
        Sat, 22 Oct 2022 07:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBB0C43470;
        Sat, 22 Oct 2022 07:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425372;
        bh=K2n3lZ/Ursgsg4sKeDOQ5OROfj9/y9Ig83F2qNg4SAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5nXzVt/vxepdQOPmbbWPD/PuSPxv5HuwiXcharAf/WmaIw03HkCttUke4fdXwuso
         LLpN69dXrnKJAI1EZ5A6k8yzXqHozu1nlmkKt5b2r5ZtKcstpGyyv3SvFSU9CyAYOS
         9f0i5PqdQP7gVWf4OvhHp8wWWeJjVDN7o0QIAICo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Collins <collinsd@codeaurora.org>,
        Fenglin Wu <quic_fenglinw@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 479/717] spmi: pmic-arb: correct duplicate APID to PPID mapping logic
Date:   Sat, 22 Oct 2022 09:25:58 +0200
Message-Id: <20221022072519.546386667@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Collins <collinsd@codeaurora.org>

[ Upstream commit 1f1693118c2476cb1666ad357edcf3cf48bf9b16 ]

Correct the way that duplicate PPID mappings are handled for PMIC
arbiter v5.  The final APID mapped to a given PPID should be the
one which has write owner = APPS EE, if it exists, or if not
that, then the first APID mapped to the PPID, if it exists.

Fixes: 40f318f0ed67 ("spmi: pmic-arb: add support for HW version 5")
Signed-off-by: David Collins <collinsd@codeaurora.org>
Signed-off-by: Fenglin Wu <quic_fenglinw@quicinc.com>
Link: https://lore.kernel.org/r/1655004286-11493-7-git-send-email-quic_fenglinw@quicinc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20220930005019.2663064-8-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 2113be40b5a9..58f580e7aacc 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -992,7 +992,8 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb *pmic_arb)
 	 * version 5, there is more than one APID mapped to each PPID.
 	 * The owner field for each of these mappings specifies the EE which is
 	 * allowed to write to the APID.  The owner of the last (highest) APID
-	 * for a given PPID will receive interrupts from the PPID.
+	 * which has the IRQ owner bit set for a given PPID will receive
+	 * interrupts from the PPID.
 	 */
 	for (i = 0; ; i++, apidd++) {
 		offset = pmic_arb->ver_ops->apid_map_offset(i);
@@ -1015,16 +1016,16 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb *pmic_arb)
 		apid = pmic_arb->ppid_to_apid[ppid] & ~PMIC_ARB_APID_VALID;
 		prev_apidd = &pmic_arb->apid_data[apid];
 
-		if (valid && is_irq_ee &&
-				prev_apidd->write_ee == pmic_arb->ee) {
+		if (!valid || apidd->write_ee == pmic_arb->ee) {
+			/* First PPID mapping or one for this EE */
+			pmic_arb->ppid_to_apid[ppid] = i | PMIC_ARB_APID_VALID;
+		} else if (valid && is_irq_ee &&
+			   prev_apidd->write_ee == pmic_arb->ee) {
 			/*
 			 * Duplicate PPID mapping after the one for this EE;
 			 * override the irq owner
 			 */
 			prev_apidd->irq_ee = apidd->irq_ee;
-		} else if (!valid || is_irq_ee) {
-			/* First PPID mapping or duplicate for another EE */
-			pmic_arb->ppid_to_apid[ppid] = i | PMIC_ARB_APID_VALID;
 		}
 
 		apidd->ppid = ppid;
-- 
2.35.1



