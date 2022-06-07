Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85512541C09
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382755AbiFGV4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382815AbiFGVwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CD323F7D5;
        Tue,  7 Jun 2022 12:09:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB094618E1;
        Tue,  7 Jun 2022 19:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A0BC385A5;
        Tue,  7 Jun 2022 19:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628998;
        bh=rnrAVh8TFZm3cAqfuvMQc8xzmqqS6HwYs40C1rok/OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHOV8K8xQrG5dAbghtvyny4arDW18cL8Xwd1Gg4JQQkFDtTXjzR9RwIsErpW5tTvc
         I0hl4kErFPTCtOd64OMLAc3IkzNiVDnNBlLEnWH0x5/IRIrjCIQFI2ZhK6wF3RIYVg
         hzsQobnWTJxno4/Usri7w1wUEAp7OaJ5YgCAYe5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 531/879] Revert "net/smc: fix listen processing for SMC-Rv2"
Date:   Tue,  7 Jun 2022 19:00:49 +0200
Message-Id: <20220607165018.286602041@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index d3de54b70c05..45a24d24210f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2093,13 +2093,13 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
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
@@ -2117,31 +2117,26 @@ static int smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
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
@@ -2174,7 +2169,6 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 				  struct smc_init_info *ini)
 {
 	int prfx_rc;
-	int rc;
 
 	/* check for ISM device matching V2 proposed device */
 	smc_find_ism_v2_device_serv(new_smc, pclc, ini);
@@ -2202,18 +2196,14 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
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



