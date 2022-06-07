Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3942154099E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbiFGSLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349923AbiFGSKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:10:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06093B642A;
        Tue,  7 Jun 2022 10:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6460B81F38;
        Tue,  7 Jun 2022 17:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFF4C385A5;
        Tue,  7 Jun 2022 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624109;
        bh=zsjmbv4CwpLwHPpbcPnSVnTmO+KVbwQy7o0E/Pbn7LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02NGu/9730u/QGrT91vfZjyIW/pIb/sDFTizDcWNvh/8NMrx4eCxWfMb2VfG/Vg0i
         pSgwvOZIkgDDk0PLmNKbhFX5CDYv+PTOJQZCCAZYhLe2FCtcEl8ta6KqwmiEh8d2qj
         nx2D92wAqfG1RlGw4muRy+qdGHAN1N/txXM5yEJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/667] drm/komeda: Fix an undefined behavior bug in komeda_plane_add()
Date:   Tue,  7 Jun 2022 18:57:52 +0200
Message-Id: <20220607164941.007671251@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index d646e3ae1a23..517b94c3bcaf 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
@@ -265,6 +265,10 @@ static int komeda_plane_add(struct komeda_kms_dev *kms,
 
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



