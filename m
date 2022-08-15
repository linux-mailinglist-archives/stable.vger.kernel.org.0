Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FE8594A48
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354131AbiHOXnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354312AbiHOXlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E68C2C131;
        Mon, 15 Aug 2022 13:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFED060DEC;
        Mon, 15 Aug 2022 20:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8DDC433C1;
        Mon, 15 Aug 2022 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594331;
        bh=t54s0hHQluGrCw2gsuxF8dDSEbB5JUWzI7KIGh7s/Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtyIxJSScVefsb/fkzo6BKnb35uQbPDlA7oG8ZijdHTrd6ESfXECX4WwEF6cioxR7
         6T5/B3oERCA3LZAOHt64AL7PUhkpsIsCrHdQCdc0ipZpmhMGdTT2k2uVdfc3tlwGoh
         fosu5Euqvax60pXfRd4VO+yKYsduqhhd6HPmWCo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0415/1157] drm/vc4: hdmi: Add all the vc5 HDMI registers into the debugfs dumps
Date:   Mon, 15 Aug 2022 19:56:11 +0200
Message-Id: <20220815180456.257344354@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 25eb441d55d479581a65bcc9de88bc1d86bf76c1 ]

The vc5 HDMI registers hadn't been added into the debugfs
register sets, therefore weren't dumped on request.
Add them in.

Fixes: 8323989140f3 ("drm/vc4: hdmi: Support the BCM2711 HDMI controllers")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-19-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 39 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/vc4/vc4_hdmi.h |  8 +++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 6b4f42332d95..e314e0a4c4c3 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -145,6 +145,12 @@ static int vc4_hdmi_debugfs_regs(struct seq_file *m, void *unused)
 
 	drm_print_regset32(&p, &vc4_hdmi->hdmi_regset);
 	drm_print_regset32(&p, &vc4_hdmi->hd_regset);
+	drm_print_regset32(&p, &vc4_hdmi->cec_regset);
+	drm_print_regset32(&p, &vc4_hdmi->csc_regset);
+	drm_print_regset32(&p, &vc4_hdmi->dvp_regset);
+	drm_print_regset32(&p, &vc4_hdmi->phy_regset);
+	drm_print_regset32(&p, &vc4_hdmi->ram_regset);
+	drm_print_regset32(&p, &vc4_hdmi->rm_regset);
 
 	return 0;
 }
@@ -2704,6 +2710,7 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 	struct platform_device *pdev = vc4_hdmi->pdev;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	int ret;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hdmi");
 	if (!res)
@@ -2800,6 +2807,38 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 		return PTR_ERR(vc4_hdmi->reset);
 	}
 
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->hdmi_regset, VC4_HDMI);
+	if (ret)
+		return ret;
+
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->hd_regset, VC4_HD);
+	if (ret)
+		return ret;
+
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->cec_regset, VC5_CEC);
+	if (ret)
+		return ret;
+
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->csc_regset, VC5_CSC);
+	if (ret)
+		return ret;
+
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->dvp_regset, VC5_DVP);
+	if (ret)
+		return ret;
+
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->phy_regset, VC5_PHY);
+	if (ret)
+		return ret;
+
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->ram_regset, VC5_RAM);
+	if (ret)
+		return ret;
+
+	ret = vc4_hdmi_build_regset(vc4_hdmi, &vc4_hdmi->rm_regset, VC5_RM);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.h b/drivers/gpu/drm/vc4/vc4_hdmi.h
index 51b27dcdcd9b..1520387b317f 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.h
@@ -179,6 +179,14 @@ struct vc4_hdmi {
 	struct debugfs_regset32 hdmi_regset;
 	struct debugfs_regset32 hd_regset;
 
+	/* VC5 only */
+	struct debugfs_regset32 cec_regset;
+	struct debugfs_regset32 csc_regset;
+	struct debugfs_regset32 dvp_regset;
+	struct debugfs_regset32 phy_regset;
+	struct debugfs_regset32 ram_regset;
+	struct debugfs_regset32 rm_regset;
+
 	/**
 	 * @hw_lock: Spinlock protecting device register access.
 	 */
-- 
2.35.1



