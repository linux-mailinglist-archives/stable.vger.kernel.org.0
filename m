Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA44A6C197C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjCTPeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjCTPdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFA319AC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:26:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 611F7B80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A22C433EF;
        Mon, 20 Mar 2023 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325992;
        bh=xsFG9o14xXgME6MWWomsCa8EnTDg/iEcMyQqcGqqg8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=St/lVRqMwq5hYPXtz7I36dye5veBfoXji+7Boe7Ps+Fzb6Zezezbvp+w3e7nze8r9
         dQ8TEBIbAA34kPjq0UpnW1WzBSmqezfkE+yDH0gtQZSsZDAX+Jdf+3EutnVdrJkRJQ
         rQ9e8rFSEQJsrHRZnuwAexp9AxDVfNrrN5kszBKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca.weiss@fairphone.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.2 137/211] interconnect: qcom: rpmh: fix probe child-node error handling
Date:   Mon, 20 Mar 2023 15:54:32 +0100
Message-Id: <20230320145519.178425178@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 6570d1d46eeade82965ccc4a3ab7d778898ef4bf upstream.

Make sure to clean up and release resources properly also in case probe
fails when populating child devices.

Fixes: 57eb14779dfd ("interconnect: qcom: icc-rpmh: Support child NoC device probe")
Cc: stable@vger.kernel.org      # 6.0
Cc: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-10-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpmh.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -235,8 +235,11 @@ int qcom_icc_rpmh_probe(struct platform_
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
-	if (of_get_child_count(dev->of_node) > 0)
-		return of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (of_get_child_count(dev->of_node) > 0) {
+		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+		if (ret)
+			goto err;
+	}
 
 	return 0;
 err:


