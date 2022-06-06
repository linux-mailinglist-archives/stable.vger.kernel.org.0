Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A73553E7F5
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbiFFPUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 11:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240439AbiFFPTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 11:19:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9A314042B
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 08:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F5A6614F5
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 15:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27367C385A9;
        Mon,  6 Jun 2022 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654528779;
        bh=JWTzE2Lx7wybCBCD+hrMnI0NKNqjETJCNcEvgM4aor8=;
        h=Subject:To:Cc:From:Date:From;
        b=HcjRT+a09GbpF9wYd6ZnCQ9Gz3lW4FpuSvqZcevBq0ohLk2Yt4PPLuaNcNELcYi8N
         BEHYcLop4fcNDCunqe+8suDNWkhQmOWTCrXI1LbpzsO2c5H5DIED6nvCRCrSVhnGbf
         qZdmatWfptfKr6T88hrOw1GdwmuY9RjJNrlL1EBA=
Subject: FAILED: patch "[PATCH] tilcdc: tilcdc_external: fix an incorrect NULL check on list" failed to apply to 4.19-stable tree
To:     xiam0nd.tong@gmail.com, jyri.sarha@iki.fi
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 17:19:36 +0200
Message-ID: <165452877615511@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8b917cbe38e9b0d002492477a9fc2bfee2412ce4 Mon Sep 17 00:00:00 2001
From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Date: Sun, 27 Mar 2022 14:15:16 +0800
Subject: [PATCH] tilcdc: tilcdc_external: fix an incorrect NULL check on list
 iterator

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

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.c b/drivers/gpu/drm/tilcdc/tilcdc_external.c
index 7594cf6e186e..3b86d002ef62 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_external.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_external.c
@@ -60,11 +60,13 @@ struct drm_connector *tilcdc_encoder_find_connector(struct drm_device *ddev,
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

