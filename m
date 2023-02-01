Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C4F6863DE
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjBAKRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjBAKQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:16:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158204F875;
        Wed,  1 Feb 2023 02:16:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC4BFB82153;
        Wed,  1 Feb 2023 10:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2EFC433EF;
        Wed,  1 Feb 2023 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246592;
        bh=/jzNzk0NhS4/FCAYMQWbqL9kCfrOP5Et7Jn12aqIVFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+YA47U1a6hCaCVthi4li1QCYeGP257njXnsax7cF7vyUdfw+PX2v1hqVMA6UlBw+
         YuPfezKfhCBEmIET1emJ6B3y8ds76bJ6fG5G5/aVghIa1qfXcKJEQyc5QUAEqIoBd+
         fQERzie+TjiOc+d9ShKB6NIs0jxI3EEF53q7mi1jP8KGLvFSc5pXh4ybyKUYZMg+dn
         cz/1zhVCDIfOHXbV2zBYY/52jXkvKlnPRfXzwy6k976L23q6lwFUjdNGcRGqwYarGA
         S/aPmVgLQQdAKYSN/OY0RbjC/HK55r5sMzpCrkEQaKvpwPLgAKbMlZHerk3BVH0UGd
         mrdxWSarhh1Uw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pNAAf-00043i-2E; Wed, 01 Feb 2023 11:16:53 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?q?Artur=20=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Georgi Djakov <georgi.djakov@linaro.org>
Subject: [PATCH 01/23] interconnect: fix mem leak when freeing nodes
Date:   Wed,  1 Feb 2023 11:15:37 +0100
Message-Id: <20230201101559.15529-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201101559.15529-1-johan+linaro@kernel.org>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The node link array is allocated when adding links to a node but is not
deallocated when nodes are destroyed.

Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
Cc: stable@vger.kernel.org      # 5.1
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 423f875d4b54..dc61620a0191 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -850,6 +850,7 @@ void icc_node_destroy(int id)
 
 	mutex_unlock(&icc_lock);
 
+	kfree(node->links);
 	kfree(node);
 }
 EXPORT_SYMBOL_GPL(icc_node_destroy);
-- 
2.39.1

