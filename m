Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05554540804
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348791AbiFGRx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348889AbiFGRuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6FB136437;
        Tue,  7 Jun 2022 10:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96E13CE23E2;
        Tue,  7 Jun 2022 17:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F9CC34115;
        Tue,  7 Jun 2022 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623439;
        bh=a9ZKlcBnYsnE8aDqjIFcOyx82PBbPcD5L2D+T4nFJj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWh2oqHHBUMN3+I4ggqnUAqGtxK4clCbUxyLOaefPwm5tPnjir1zb2SWIbO74bWMw
         Q9gbnXnU0iMiOOm+SJRRKl3YzVGuyRn5u5wxHhvV7N6O10yDxGgHm6wvU39sskJd9e
         Hpq3fvq8zaO5RJ88RiRXARXN5Tvx1CR0ZdmsBkc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.10 416/452] gma500: fix an incorrect NULL check on list iterator
Date:   Tue,  7 Jun 2022 19:04:33 +0200
Message-Id: <20220607164920.952632644@linuxfoundation.org>
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

commit bdef417d84536715145f6dc9cc3275c46f26295a upstream.

The bug is here:
	return crtc;

The list iterator value 'crtc' will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found.

To fix the bug, return 'crtc' when found, otherwise return NULL.

Cc: stable@vger.kernel.org
fixes: 89c78134cc54d ("gma500: Add Poulsbo support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220327052028.2013-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/psb_intel_display.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -536,14 +536,15 @@ void psb_intel_crtc_init(struct drm_devi
 
 struct drm_crtc *psb_intel_get_crtc_from_pipe(struct drm_device *dev, int pipe)
 {
-	struct drm_crtc *crtc = NULL;
+	struct drm_crtc *crtc;
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct gma_crtc *gma_crtc = to_gma_crtc(crtc);
+
 		if (gma_crtc->pipe == pipe)
-			break;
+			return crtc;
 	}
-	return crtc;
+	return NULL;
 }
 
 int gma_connector_clones(struct drm_device *dev, int type_mask)


