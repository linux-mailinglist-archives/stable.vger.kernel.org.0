Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021195C032B
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiIUQAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiIUP7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1AE6352;
        Wed, 21 Sep 2022 08:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B59EB8309E;
        Wed, 21 Sep 2022 15:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7624DC433D6;
        Wed, 21 Sep 2022 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775511;
        bh=GmYtHqZTuF5fWSgoRICml3viR5xWpFXum0y9yUTkJaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxHwE1oDnoMVypf0ZAf3AubC50WWn+1nCg7LHMPitkQdmBLOlYlksJeVlHJTNL5YO
         AQhHEdr8fp8tsU5T1Iv3Fk2jo35u1W14Moseu0K0EEfccaUYVO1Vu4CGIGMd/y4Dwc
         ICOJyxBCJsqRnvOEgfL1UA1jbFEmK79wVEODx73U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/39] powerpc/pseries/mobility: refactor node lookup during DT update
Date:   Wed, 21 Sep 2022 17:46:12 +0200
Message-Id: <20220921153645.970431712@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 2efd7f6eb9b7107e469837d8452e750d7d080a5d ]

In pseries_devicetree_update(), with each call to ibm,update-nodes the
partition firmware communicates the node to be deleted or updated by
placing its phandle in the work buffer. Each of delete_dt_node(),
update_dt_node(), and add_dt_node() have duplicate lookups using the
phandle value and corresponding refcount management.

Move the lookup and of_node_put() into pseries_devicetree_update(),
and emit a warning on any failed lookups.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201207215200.1785968-29-nathanl@linux.ibm.com
Stable-dep-of: 319fa1a52e43 ("powerpc/pseries/mobility: ignore ibm, platform-facilities updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/mobility.c | 49 ++++++++---------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index 2f73cb5bf12d..acf1664d1ad7 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -59,18 +59,10 @@ static int mobility_rtas_call(int token, char *buf, s32 scope)
 	return rc;
 }
 
-static int delete_dt_node(__be32 phandle)
+static int delete_dt_node(struct device_node *dn)
 {
-	struct device_node *dn;
-
-	dn = of_find_node_by_phandle(be32_to_cpu(phandle));
-	if (!dn)
-		return -ENOENT;
-
 	pr_debug("removing node %pOFfp\n", dn);
-
 	dlpar_detach_node(dn);
-	of_node_put(dn);
 	return 0;
 }
 
@@ -135,10 +127,9 @@ static int update_dt_property(struct device_node *dn, struct property **prop,
 	return 0;
 }
 
-static int update_dt_node(__be32 phandle, s32 scope)
+static int update_dt_node(struct device_node *dn, s32 scope)
 {
 	struct update_props_workarea *upwa;
-	struct device_node *dn;
 	struct property *prop = NULL;
 	int i, rc, rtas_rc;
 	char *prop_data;
@@ -155,14 +146,8 @@ static int update_dt_node(__be32 phandle, s32 scope)
 	if (!rtas_buf)
 		return -ENOMEM;
 
-	dn = of_find_node_by_phandle(be32_to_cpu(phandle));
-	if (!dn) {
-		kfree(rtas_buf);
-		return -ENOENT;
-	}
-
 	upwa = (struct update_props_workarea *)&rtas_buf[0];
-	upwa->phandle = phandle;
+	upwa->phandle = cpu_to_be32(dn->phandle);
 
 	do {
 		rtas_rc = mobility_rtas_call(update_properties_token, rtas_buf,
@@ -221,26 +206,18 @@ static int update_dt_node(__be32 phandle, s32 scope)
 		cond_resched();
 	} while (rtas_rc == 1);
 
-	of_node_put(dn);
 	kfree(rtas_buf);
 	return 0;
 }
 
-static int add_dt_node(__be32 parent_phandle, __be32 drc_index)
+static int add_dt_node(struct device_node *parent_dn, __be32 drc_index)
 {
 	struct device_node *dn;
-	struct device_node *parent_dn;
 	int rc;
 
-	parent_dn = of_find_node_by_phandle(be32_to_cpu(parent_phandle));
-	if (!parent_dn)
-		return -ENOENT;
-
 	dn = dlpar_configure_connector(drc_index, parent_dn);
-	if (!dn) {
-		of_node_put(parent_dn);
+	if (!dn)
 		return -ENOENT;
-	}
 
 	rc = dlpar_attach_node(dn, parent_dn);
 	if (rc)
@@ -248,7 +225,6 @@ static int add_dt_node(__be32 parent_phandle, __be32 drc_index)
 
 	pr_debug("added node %pOFfp\n", dn);
 
-	of_node_put(parent_dn);
 	return rc;
 }
 
@@ -281,22 +257,31 @@ int pseries_devicetree_update(s32 scope)
 			data++;
 
 			for (i = 0; i < node_count; i++) {
+				struct device_node *np;
 				__be32 phandle = *data++;
 				__be32 drc_index;
 
+				np = of_find_node_by_phandle(be32_to_cpu(phandle));
+				if (!np) {
+					pr_warn("Failed lookup: phandle 0x%x for action 0x%x\n",
+						be32_to_cpu(phandle), action);
+					continue;
+				}
+
 				switch (action) {
 				case DELETE_DT_NODE:
-					delete_dt_node(phandle);
+					delete_dt_node(np);
 					break;
 				case UPDATE_DT_NODE:
-					update_dt_node(phandle, scope);
+					update_dt_node(np, scope);
 					break;
 				case ADD_DT_NODE:
 					drc_index = *data++;
-					add_dt_node(phandle, drc_index);
+					add_dt_node(np, drc_index);
 					break;
 				}
 
+				of_node_put(np);
 				cond_resched();
 			}
 		}
-- 
2.35.1



