Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A595C02D9
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiIUPzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiIUPyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670F9F1A2;
        Wed, 21 Sep 2022 08:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29B88B830AC;
        Wed, 21 Sep 2022 15:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C3FC433C1;
        Wed, 21 Sep 2022 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775395;
        bh=PiPB3YXJpRtdxlglaBYvNy66rA4xrQRCPhLTiCXSEBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMH7rJDIBItpqZE/UeszK18UPErmba41DGWxpTJVpxzGqdQFgHhUIfHNWsFcPdJW3
         1+6GQKOvnIaGkbOz5ryhCDzEtr2yhILZtNDPyZ+dsGT7CyfA2rHfeOGty2omTyaJQ6
         DNYS1Cfouz9yE2bsXJsdSYJxaW2gET+f7sgrkXbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/45] drm/panfrost: devfreq: set opp to the recommended one to configure regulator
Date:   Wed, 21 Sep 2022 17:46:29 +0200
Message-Id: <20220921153648.265528220@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit d76034a427a2660b080bc155e4fd8f6393eefb48 ]

Enabling panfrost GPU OPP with dynamic regulator will make OPP
responsible to enable and configure it.

Unfortunately OPP configure and enable the regulator when an OPP
is asked to be set, which is not the case during
panfrost_devfreq_init().

This leave the regulator unconfigured and if no GPU load is
triggered, no OPP is asked to be set which make the regulator framework
switching it off during regulator_late_cleanup() without
noticing and therefore make the board hang as any access to GPU
memory space make bus locks up.

Call dev_pm_opp_set_opp() with the recommend OPP in
panfrost_devfreq_init() to enable the regulator, this will properly
configure and enable the regulator and will avoid any switch off
by regulator_late_cleanup().

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Clément Péron <peron.clem@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220906153034.153321-5-peron.clem@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 194af7f607a6..be36dd060a2b 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -132,6 +132,17 @@ int panfrost_devfreq_init(struct panfrost_device *pfdev)
 		return PTR_ERR(opp);
 
 	panfrost_devfreq_profile.initial_freq = cur_freq;
+
+	/*
+	 * Set the recommend OPP this will enable and configure the regulator
+	 * if any and will avoid a switch off by regulator_late_cleanup()
+	 */
+	ret = dev_pm_opp_set_opp(dev, opp);
+	if (ret) {
+		DRM_DEV_ERROR(dev, "Couldn't set recommended OPP\n");
+		return ret;
+	}
+
 	dev_pm_opp_put(opp);
 
 	/*
-- 
2.35.1



