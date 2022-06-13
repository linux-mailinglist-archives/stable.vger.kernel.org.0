Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19C5494B1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351662AbiFMLJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352126AbiFMLJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:09:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE38033E95;
        Mon, 13 Jun 2022 03:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E4560FFD;
        Mon, 13 Jun 2022 10:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E24C34114;
        Mon, 13 Jun 2022 10:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116522;
        bh=c7Bux8gORtIUyKX+nEOcBp7LJR8TG4CjpwtkMuws2Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T03hT7vrhiomwPXK/4Z0JEZHOAS+pESDPF2lk8CNexO2c9LdZnc/iJXbDh56/GuT8
         FjgqNpg038EzXetNIJU5zXMLrx1s/24St1Nu0lJb3RFbvgFTrF1Yot0nMPqn3syIoi
         ZHoUKttTFc6khp5h6ayHvryvzWblt2DPELaVf9p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/411] drm/komeda: Fix an undefined behavior bug in komeda_plane_add()
Date:   Mon, 13 Jun 2022 12:06:05 +0200
Message-Id: <20220613094931.440825663@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit f5e284bb74ab296f98122673c7ecd22028b2c200 ]

In komeda_plane_add(), komeda_get_layer_fourcc_list() is assigned to
formats and used in drm_universal_plane_init().
drm_universal_plane_init() passes formats to
__drm_universal_plane_init(). __drm_universal_plane_init() further
passes formats to memcpy() as src parameter, which could lead to an
undefined behavior bug on failure of komeda_get_layer_fourcc_list().

Fix this bug by adding a check of formats.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_DRM_KOMEDA=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 61f1c4a8ab75 ("drm/komeda: Attach komeda_dev to DRM-KMS")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/dri-devel/20211201033704.32054-1-zhou1615@umn.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
index a5f57b38d193..bc3f42e915e9 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
@@ -264,6 +264,10 @@ static int komeda_plane_add(struct komeda_kms_dev *kms,
 
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       layer->layer_type, &n_formats);
+	if (!formats) {
+		kfree(kplane);
+		return -ENOMEM;
+	}
 
 	err = drm_universal_plane_init(&kms->base, plane,
 			get_possible_crtcs(kms, c->pipeline),
-- 
2.35.1



