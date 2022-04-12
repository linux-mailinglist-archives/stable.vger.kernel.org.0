Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0804FD51A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353117AbiDLIDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357004AbiDLHjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5309915708;
        Tue, 12 Apr 2022 00:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BECF1B81B55;
        Tue, 12 Apr 2022 07:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FEAC385A1;
        Tue, 12 Apr 2022 07:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747443;
        bh=JQ4CIo/B9TfQlgpiYFcfzmhMll5JVvDMZabjKybC0oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVZsYFyTDA6BkmU6FwozgUvISvOvTlqlOIHb5panTBj1VmqrkI3HHdnfqNxOlt8tW
         H4tcvdmTr/5qnVG+fHYI2JGEkZK6/MLiMEfO2DcpB5tpYiCdO1jy+v24Q4F5+FLb2A
         cusdPmlZEx/EiwRjtCMIodQR7huv8JDfR82Wngys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zou Wei <zou_wei@huawei.com>,
        Kevin Tang <kevin3.tang@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 081/343] drm/sprd: check the platform_get_resource() return value
Date:   Tue, 12 Apr 2022 08:28:19 +0200
Message-Id: <20220412062953.438250061@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Kevin Tang <kevin3.tang@gmail.com>

[ Upstream commit 73792e6e66be1225837cc1a40f1e39b1d077751c ]

platform_get_resource() may fail and return NULL, so check it's value
before using it.

Reported-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Kevin Tang <kevin3.tang@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/all/20220117084156.9338-1-kevin3.tang@gmail.com

v1 -> v2:
- new patch

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sprd/sprd_dpu.c | 5 +++++
 drivers/gpu/drm/sprd/sprd_dsi.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/sprd/sprd_dpu.c b/drivers/gpu/drm/sprd/sprd_dpu.c
index 06a3414ee43a..1637203ea103 100644
--- a/drivers/gpu/drm/sprd/sprd_dpu.c
+++ b/drivers/gpu/drm/sprd/sprd_dpu.c
@@ -790,6 +790,11 @@ static int sprd_dpu_context_init(struct sprd_dpu *dpu,
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "failed to get I/O resource\n");
+		return -EINVAL;
+	}
+
 	ctx->base = devm_ioremap(dev, res->start, resource_size(res));
 	if (!ctx->base) {
 		dev_err(dev, "failed to map dpu registers\n");
diff --git a/drivers/gpu/drm/sprd/sprd_dsi.c b/drivers/gpu/drm/sprd/sprd_dsi.c
index 911b3cddc264..12b67a5d5923 100644
--- a/drivers/gpu/drm/sprd/sprd_dsi.c
+++ b/drivers/gpu/drm/sprd/sprd_dsi.c
@@ -907,6 +907,11 @@ static int sprd_dsi_context_init(struct sprd_dsi *dsi,
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "failed to get I/O resource\n");
+		return -EINVAL;
+	}
+
 	ctx->base = devm_ioremap(dev, res->start, resource_size(res));
 	if (!ctx->base) {
 		drm_err(dsi->drm, "failed to map dsi host registers\n");
-- 
2.35.1



