Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C88541015
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350488AbiFGTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356040AbiFGTRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353AD30F42;
        Tue,  7 Jun 2022 11:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A038617AE;
        Tue,  7 Jun 2022 18:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C77C385A5;
        Tue,  7 Jun 2022 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625291;
        bh=u3BGt4PKsLXxAzxsq/aZZArjOH52aSbr80e3Qobz3pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0tB2lUZa/pw4u20qFYIZ/QgoDr5w0GZTYfb57NcPkok73AYArmiP+fknV4DZFXrN
         hrFi1exMbkmrQM2Z7h0V+7cMzrK2WIiDrN9575rzGWfOM2fwnPRjtmxw3ut6yDYhfJ
         09rkOgikpQuvOGTz2iDb1Le46wOIRzkTQDry85ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Jyri Sarha <jyri.sarha@iki.fi>
Subject: [PATCH 5.15 634/667] tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator
Date:   Tue,  7 Jun 2022 19:04:59 +0200
Message-Id: <20220607164953.679045039@linuxfoundation.org>
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 8b917cbe38e9b0d002492477a9fc2bfee2412ce4 upstream.

The bug is here:
	if (!encoder) {

The list iterator value 'encoder' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'encoder' as a dedicated pointer
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: ec9eab097a500 ("drm/tilcdc: Add drm bridge support for attaching drm bridge drivers")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Reviewed-by: Jyri Sarha <jyri.sarha@iki.fi>
Tested-by: Jyri Sarha <jyri.sarha@iki.fi>
Signed-off-by: Jyri Sarha <jyri.sarha@iki.fi>
Link: https://patchwork.freedesktop.org/patch/msgid/20220327061516.5076-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_external.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/tilcdc/tilcdc_external.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_external.c
@@ -60,11 +60,13 @@ struct drm_connector *tilcdc_encoder_fin
 int tilcdc_add_component_encoder(struct drm_device *ddev)
 {
 	struct tilcdc_drm_private *priv = ddev->dev_private;
-	struct drm_encoder *encoder;
+	struct drm_encoder *encoder = NULL, *iter;
 
-	list_for_each_entry(encoder, &ddev->mode_config.encoder_list, head)
-		if (encoder->possible_crtcs & (1 << priv->crtc->index))
+	list_for_each_entry(iter, &ddev->mode_config.encoder_list, head)
+		if (iter->possible_crtcs & (1 << priv->crtc->index)) {
+			encoder = iter;
 			break;
+		}
 
 	if (!encoder) {
 		dev_err(ddev->dev, "%s: No suitable encoder found\n", __func__);


