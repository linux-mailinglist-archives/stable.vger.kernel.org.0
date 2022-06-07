Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5098C541EA8
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351920AbiFGWcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384879AbiFGWbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070D1278982;
        Tue,  7 Jun 2022 12:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89CE1B8220B;
        Tue,  7 Jun 2022 19:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0528AC385A5;
        Tue,  7 Jun 2022 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629871;
        bh=ScxqRn4CyVuet+Fn9+6gsApj3gvQxxDLbl/1mrX6GRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IOcc3CcBFLxdJ25B0FbLNYixQTJvMEoLPoBnZ0isdGued+cbcvhzgcEcHS1JFyNW
         Nu4C2seuRRS54m1u/1B76HlHdK85zfji4TTyT8Dy+8A1qBhnXIJ/dzbr2GHD1WK/Pd
         RfW2obO7oMHTXs3pmpeJZMXd2ft6kFSMijCACCNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.18 845/879] gma500: fix an incorrect NULL check on list iterator
Date:   Tue,  7 Jun 2022 19:06:03 +0200
Message-Id: <20220607165027.378736782@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
@@ -535,14 +535,15 @@ void psb_intel_crtc_init(struct drm_devi
 
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


