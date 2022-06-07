Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85ED5414A4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347608AbiFGUVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359653AbiFGUU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:20:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A34A1D2ACC;
        Tue,  7 Jun 2022 11:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 770B5B8237C;
        Tue,  7 Jun 2022 18:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC144C385A2;
        Tue,  7 Jun 2022 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626627;
        bh=ANzoiVHiz1mg0UvW8TF8kLoCpbg7+wK2bKa61PuaCYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSqRW/y/LL5xvlKVfRTQCp6DB5C67A+Xe8ynTGcBZT2+95CYSkNiqRT2cWvs1paAS
         RWgUTIGSAMP+wYll5rKrvJCmAsAZCPdgQObEv25giXC0yfT14hbCB3fykCtf8gOshb
         QvhIFQrMu0DEHy5h0+YhnOJ1OSKSn08E195Xq85Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 446/772] net/smc: fix listen processing for SMC-Rv2
Date:   Tue,  7 Jun 2022 19:00:38 +0200
Message-Id: <20220607165002.144634330@linuxfoundation.org>
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

[ Upstream commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d ]

In the process of checking whether RDMAv2 is available, the current
implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
smc buf desc, but the latter may fail. Unfortunately, the caller
will only check the former. In this case, a NULL pointer reference
will occur in smc_clc_send_confirm_accept() when accessing
conn->rmb_desc.

This patch does two things:
1. Use the return code to determine whether V2 is available.
2. If the return code is NODEV, continue to check whether V1 is
available.

Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b9fe31834354..dafb2bc0b6b6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1930,13 +1930,13 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 	return 0;
 }
 
-static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
-					 struct smc_clc_msg_proposal *pclc,
-					 struct smc_init_info *ini)
+static int smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
+					struct smc_clc_msg_proposal *pclc,
+					struct smc_init_info *ini)
 {
 	struct smc_clc_v2_extension *smc_v2_ext;
 	u8 smcr_version;
-	int rc;
+	int rc = 0;
 
 	if (!(ini->smcr_version & SMC_V2) || !smcr_indicated(ini->smc_type_v2))
 		goto not_found;
@@ -1954,26 +1954,31 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 	ini->smcrv2.saddr = new_smc->clcsock->sk->sk_rcv_saddr;
 	ini->smcrv2.daddr = smc_ib_gid_to_ipv4(smc_v2_ext->roce);
 	rc = smc_find_rdma_device(new_smc, ini);
-	if (rc) {
-		smc_find_ism_store_rc(rc, ini);
+	if (rc)
 		goto not_found;
-	}
+
 	if (!ini->smcrv2.uses_gateway)
 		memcpy(ini->smcrv2.nexthop_mac, pclc->lcl.mac, ETH_ALEN);
 
 	smcr_version = ini->smcr_version;
 	ini->smcr_version = SMC_V2;
 	rc = smc_listen_rdma_init(new_smc, ini);
-	if (!rc)
-		rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
-	if (!rc)
-		return;
-	ini->smcr_version = smcr_version;
-	smc_find_ism_store_rc(rc, ini);
+	if (rc) {
+		ini->smcr_version = smcr_version;
+		goto not_found;
+	}
+	rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
+	if (rc) {
+		ini->smcr_version = smcr_version;
+		goto not_found;
+	}
+	return 0;
 
 not_found:
+	rc = rc ?: SMC_CLC_DECL_NOSMCDEV;
 	ini->smcr_version &= ~SMC_V2;
 	ini->check_smcrv2 = false;
+	return rc;
 }
 
 static int smc_find_rdma_v1_device_serv(struct smc_sock *new_smc,
@@ -2006,6 +2011,7 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 				  struct smc_init_info *ini)
 {
 	int prfx_rc;
+	int rc;
 
 	/* check for ISM device matching V2 proposed device */
 	smc_find_ism_v2_device_serv(new_smc, pclc, ini);
@@ -2033,14 +2039,18 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 		return ini->rc ?: SMC_CLC_DECL_NOSMCDDEV;
 
 	/* check if RDMA V2 is available */
-	smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
-	if (ini->smcrv2.ib_dev_v2)
+	rc = smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
+	if (!rc)
 		return 0;
 
+	/* skip V1 check if V2 is unavailable for non-Device reason */
+	if (rc != SMC_CLC_DECL_NOSMCDEV &&
+	    rc != SMC_CLC_DECL_NOSMCRDEV &&
+	    rc != SMC_CLC_DECL_NOSMCDDEV)
+		return rc;
+
 	/* check if RDMA V1 is available */
 	if (!prfx_rc) {
-		int rc;
-
 		rc = smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
 		smc_find_ism_store_rc(rc, ini);
 		return (!rc) ? 0 : ini->rc;
-- 
2.35.1



