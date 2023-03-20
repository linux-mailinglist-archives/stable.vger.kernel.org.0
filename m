Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF246C1973
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbjCTPdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjCTPdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C398B2386F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 620DB6154E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D9C433D2;
        Mon, 20 Mar 2023 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325972;
        bh=GS3vC1HSyP509DsI5J5BgQArdPm/3fW+Px4gFqejFw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqBwvFbAL6Xp+g3ouLC3VxKZczs9f9s3/W/85ONmeWogQCpg1ML9JjGzBPCc+gFpa
         5lDYuSh4ju1wWlw7Dw9D7gUHKQR3Os4G36Pir7zHLFDki8SCqyDZjG2A+AdHrT0lHg
         PVtZj3JpAaagSK021O81LGi83Uqg9i2WUwkn8mkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.2 134/211] interconnect: qcom: osm-l3: fix registration race
Date:   Mon, 20 Mar 2023 15:54:29 +0100
Message-Id: <20230320145519.059138262@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 174941ed28a3573db075da46d95b4dcf9d4c49c2 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail:

	of_icc_xlate_onecell: invalid index 0
	cpu cpu0: error -EINVAL: error finding src node
	cpu cpu0: dev_pm_opp_of_find_icc_paths: Unable to get path0: -22
	qcom-cpufreq-hw: probe of 18591000.cpufreq failed with error -22

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 5bc9900addaf ("interconnect: qcom: Add OSM L3 interconnect provider support")
Cc: stable@vger.kernel.org      # 5.7
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-6-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/osm-l3.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -158,8 +158,8 @@ static int qcom_osm_l3_remove(struct pla
 {
 	struct qcom_osm_l3_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
@@ -245,14 +245,9 @@ static int qcom_osm_l3_probe(struct plat
 	provider->set = qcom_osm_l3_set;
 	provider->aggregate = icc_std_aggregate;
 	provider->xlate = of_icc_xlate_onecell;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(&pdev->dev, "error adding interconnect provider\n");
-		return ret;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -275,12 +270,15 @@ static int qcom_osm_l3_probe(struct plat
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 err:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
 
 	return ret;
 }


