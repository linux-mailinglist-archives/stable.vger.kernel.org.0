Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A098154079F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242549AbiFGRtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348255AbiFGRri (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:47:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B860B113F83;
        Tue,  7 Jun 2022 10:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F7D4615D1;
        Tue,  7 Jun 2022 17:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64349C34119;
        Tue,  7 Jun 2022 17:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623417;
        bh=95w245+rAbzusPIKxyCVLzeu80X2NeC7vNGLyQhSNrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PERQK6lg5U4pwBFmwpo9Zgf/CJLD+iNT+2Qhz7f7K8g+BbpXYZwXq/STKCK80VXnr
         I3zBLnVVSVdkTpHXUA6Hg2Oz5cTaURy7SEV+auQ/rauJUZOaRT9l3bP6a3Pv4zId7u
         wBkq5vf1Xz78PcW+2IJtgW//z//IR97L9PThiBwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
        Philippe Cornu <philippe.cornu@foss.st.com>
Subject: [PATCH 5.10 409/452] stm: ltdc: fix two incorrect NULL checks on list iterator
Date:   Tue,  7 Jun 2022 19:04:26 +0200
Message-Id: <20220607164920.747335606@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

commit 2e6c86be0e57079d1fb6c7c7e5423db096d0548a upstream.

The two bugs are here:
	if (encoder) {
	if (bridge && bridge->timings)

The list iterator value 'encoder/bridge' will *always* be set and
non-NULL by drm_for_each_encoder()/list_for_each_entry(), so it is
incorrect to assume that the iterator value will be NULL if the
list is empty or no element is found.

To fix the bug, use a new variable '*_iter' as the list iterator,
while use the old variable 'encoder/bridge' as a dedicated pointer
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 99e360442f223 ("drm/stm: Fix bus_flags handling")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Acked-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Philippe Cornu <philippe.cornu@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220327055355.3808-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/stm/ltdc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -527,8 +527,8 @@ static void ltdc_crtc_mode_set_nofb(stru
 	struct drm_device *ddev = crtc->dev;
 	struct drm_connector_list_iter iter;
 	struct drm_connector *connector = NULL;
-	struct drm_encoder *encoder = NULL;
-	struct drm_bridge *bridge = NULL;
+	struct drm_encoder *encoder = NULL, *en_iter;
+	struct drm_bridge *bridge = NULL, *br_iter;
 	struct drm_display_mode *mode = &crtc->state->adjusted_mode;
 	struct videomode vm;
 	u32 hsync, vsync, accum_hbp, accum_vbp, accum_act_w, accum_act_h;
@@ -538,15 +538,19 @@ static void ltdc_crtc_mode_set_nofb(stru
 	int ret;
 
 	/* get encoder from crtc */
-	drm_for_each_encoder(encoder, ddev)
-		if (encoder->crtc == crtc)
+	drm_for_each_encoder(en_iter, ddev)
+		if (en_iter->crtc == crtc) {
+			encoder = en_iter;
 			break;
+		}
 
 	if (encoder) {
 		/* get bridge from encoder */
-		list_for_each_entry(bridge, &encoder->bridge_chain, chain_node)
-			if (bridge->encoder == encoder)
+		list_for_each_entry(br_iter, &encoder->bridge_chain, chain_node)
+			if (br_iter->encoder == encoder) {
+				bridge = br_iter;
 				break;
+			}
 
 		/* Get the connector from encoder */
 		drm_connector_list_iter_begin(ddev, &iter);


