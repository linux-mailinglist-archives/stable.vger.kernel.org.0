Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F305414AF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358611AbiFGUVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359747AbiFGUVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:21:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2962B1D30D1;
        Tue,  7 Jun 2022 11:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 865ADB82367;
        Tue,  7 Jun 2022 18:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC6C385A2;
        Tue,  7 Jun 2022 18:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626638;
        bh=eJ/Ub5wghGPs/rmAjLToGF12TPuKpYj2NcaQq3CTiu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bdy22pRPTfuD56n2sIV42iB41Dze0K791nLCjnr3kh+ZyM5zMWFMlMRMd/GK7Be5E
         r5oQZ4RbOebM2YAJhdWe8uzifKjuiZequ8e0N+qB2rDAucCcr357LHat6zYrsKjuyy
         9EL50ecIr0kmyJAKcqKOjOL1sDtsjua9q26D26X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 450/772] Revert "net/smc: fix listen processing for SMC-Rv2"
Date:   Tue,  7 Jun 2022 19:00:42 +0200
Message-Id: <20220607165002.263079556@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

[ Upstream commit 9029ac03f20a5999bc5627277c6cf008ab8e23ed ]

This reverts commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d.

Some rollback issue will be fixed in other patches in the future.

Link: https://lore.kernel.org/all/20220523055056.2078994-1-liuyacan@corp.netease.com/

Fixes: 8c3b8dc5cc9b ("net/smc: fix listen processing for SMC-Rv2")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
Link: https://lore.kernel.org/r/20220524090230.2140302-1-liuyacan@corp.netease.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index dafb2bc0b6b6..b9fe31834354 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1930,13 +1930,13 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 	return 0;
 }
 
-static int smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
-					struct smc_clc_msg_proposal *pclc,
-					struct smc_init_info *ini)
+static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
+					 struct smc_clc_msg_proposal *pclc,
+					 struct smc_init_info *ini)
 {
 	struct smc_clc_v2_extension *smc_v2_ext;
 	u8 smcr_version;
-	int rc = 0;
+	int rc;
 
 	if (!(ini->smcr_version & SMC_V2) || !smcr_indicated(ini->smc_type_v2))
 		goto not_found;
@@ -1954,31 +1954,26 @@ static int smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 	ini->smcrv2.saddr = new_smc->clcsock->sk->sk_rcv_saddr;
 	ini->smcrv2.daddr = smc_ib_gid_to_ipv4(smc_v2_ext->roce);
 	rc = smc_find_rdma_device(new_smc, ini);
-	if (rc)
+	if (rc) {
+		smc_find_ism_store_rc(rc, ini);
 		goto not_found;
-
+	}
 	if (!ini->smcrv2.uses_gateway)
 		memcpy(ini->smcrv2.nexthop_mac, pclc->lcl.mac, ETH_ALEN);
 
 	smcr_version = ini->smcr_version;
 	ini->smcr_version = SMC_V2;
 	rc = smc_listen_rdma_init(new_smc, ini);
-	if (rc) {
-		ini->smcr_version = smcr_version;
-		goto not_found;
-	}
-	rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
-	if (rc) {
-		ini->smcr_version = smcr_version;
-		goto not_found;
-	}
-	return 0;
+	if (!rc)
+		rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
+	if (!rc)
+		return;
+	ini->smcr_version = smcr_version;
+	smc_find_ism_store_rc(rc, ini);
 
 not_found:
-	rc = rc ?: SMC_CLC_DECL_NOSMCDEV;
 	ini->smcr_version &= ~SMC_V2;
 	ini->check_smcrv2 = false;
-	return rc;
 }
 
 static int smc_find_rdma_v1_device_serv(struct smc_sock *new_smc,
@@ -2011,7 +2006,6 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 				  struct smc_init_info *ini)
 {
 	int prfx_rc;
-	int rc;
 
 	/* check for ISM device matching V2 proposed device */
 	smc_find_ism_v2_device_serv(new_smc, pclc, ini);
@@ -2039,18 +2033,14 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 		return ini->rc ?: SMC_CLC_DECL_NOSMCDDEV;
 
 	/* check if RDMA V2 is available */
-	rc = smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
-	if (!rc)
+	smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
+	if (ini->smcrv2.ib_dev_v2)
 		return 0;
 
-	/* skip V1 check if V2 is unavailable for non-Device reason */
-	if (rc != SMC_CLC_DECL_NOSMCDEV &&
-	    rc != SMC_CLC_DECL_NOSMCRDEV &&
-	    rc != SMC_CLC_DECL_NOSMCDDEV)
-		return rc;
-
 	/* check if RDMA V1 is available */
 	if (!prfx_rc) {
+		int rc;
+
 		rc = smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
 		smc_find_ism_store_rc(rc, ini);
 		return (!rc) ? 0 : ini->rc;
-- 
2.35.1



