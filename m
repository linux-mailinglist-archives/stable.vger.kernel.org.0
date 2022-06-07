Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10160541965
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359544AbiFGVVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381136AbiFGVRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19035220E22;
        Tue,  7 Jun 2022 11:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4954061787;
        Tue,  7 Jun 2022 18:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CFEC3411C;
        Tue,  7 Jun 2022 18:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628305;
        bh=fkh/6Lz5PBPyN3Yo4YaopMF0RNPZawNwx8luwX+9g/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSKTPWXTgeQo1a3nNaiQdlKGUIFjCBvuKBuuZV2ywjOZq5h+8Xsm341A9MuY4w8Dl
         GfFMCfxSvr6Uoqtrws9p/Nm+9Hvej04zqI+Ph/ltvoxGqwq+6I1kLbPWr7gtz3TZFU
         i6oeaapgcMDCmQ250eEMHhEdHa9cJniO903xIp/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Venkata Prasad Potturu <quic_potturu@quicinc.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 279/879] ASoC: codecs: Fix error handling in power domain init and exit handlers
Date:   Tue,  7 Jun 2022 18:56:37 +0200
Message-Id: <20220607165010.946703171@linuxfoundation.org>
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

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit 1a8ee4cf84187bce17c76886eb6dd9389c3b99a8 ]

Update error handling in power domain init and exit handlers, as existing handling
may cause issues in device remove function.
Use appropriate pm core api for power domain get and sync to avoid redundant code.

Fixes: 9e3d83c52844 ("ASoC: codecs: Add power domains support in digital macro codecs")

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Co-developed-by: Venkata Prasad Potturu <quic_potturu@quicinc.com>
Signed-off-by: Venkata Prasad Potturu <quic_potturu@quicinc.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/1647965937-32203-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-macro-common.c | 35 +++++++++++++++------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/lpass-macro-common.c b/sound/soc/codecs/lpass-macro-common.c
index 6cede75ed3b5..3c661fd61173 100644
--- a/sound/soc/codecs/lpass-macro-common.c
+++ b/sound/soc/codecs/lpass-macro-common.c
@@ -24,42 +24,45 @@ struct lpass_macro *lpass_macro_pds_init(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	l_pds->macro_pd = dev_pm_domain_attach_by_name(dev, "macro");
-	if (IS_ERR_OR_NULL(l_pds->macro_pd))
-		return NULL;
-
-	ret = pm_runtime_get_sync(l_pds->macro_pd);
-	if (ret < 0) {
-		pm_runtime_put_noidle(l_pds->macro_pd);
+	if (IS_ERR_OR_NULL(l_pds->macro_pd)) {
+		ret = PTR_ERR(l_pds->macro_pd);
 		goto macro_err;
 	}
 
+	ret = pm_runtime_resume_and_get(l_pds->macro_pd);
+	if (ret < 0)
+		goto macro_sync_err;
+
 	l_pds->dcodec_pd = dev_pm_domain_attach_by_name(dev, "dcodec");
-	if (IS_ERR_OR_NULL(l_pds->dcodec_pd))
+	if (IS_ERR_OR_NULL(l_pds->dcodec_pd)) {
+		ret = PTR_ERR(l_pds->dcodec_pd);
 		goto dcodec_err;
+	}
 
-	ret = pm_runtime_get_sync(l_pds->dcodec_pd);
-	if (ret < 0) {
-		pm_runtime_put_noidle(l_pds->dcodec_pd);
+	ret = pm_runtime_resume_and_get(l_pds->dcodec_pd);
+	if (ret < 0)
 		goto dcodec_sync_err;
-	}
 	return l_pds;
 
 dcodec_sync_err:
 	dev_pm_domain_detach(l_pds->dcodec_pd, false);
 dcodec_err:
 	pm_runtime_put(l_pds->macro_pd);
-macro_err:
+macro_sync_err:
 	dev_pm_domain_detach(l_pds->macro_pd, false);
+macro_err:
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(lpass_macro_pds_init);
 
 void lpass_macro_pds_exit(struct lpass_macro *pds)
 {
-	pm_runtime_put(pds->macro_pd);
-	dev_pm_domain_detach(pds->macro_pd, false);
-	pm_runtime_put(pds->dcodec_pd);
-	dev_pm_domain_detach(pds->dcodec_pd, false);
+	if (pds) {
+		pm_runtime_put(pds->macro_pd);
+		dev_pm_domain_detach(pds->macro_pd, false);
+		pm_runtime_put(pds->dcodec_pd);
+		dev_pm_domain_detach(pds->dcodec_pd, false);
+	}
 }
 EXPORT_SYMBOL_GPL(lpass_macro_pds_exit);
 
-- 
2.35.1



