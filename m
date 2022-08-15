Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F345949FC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354119AbiHOXnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354305AbiHOXlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BD52BB24;
        Mon, 15 Aug 2022 13:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CB26B80EA8;
        Mon, 15 Aug 2022 20:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A01C433D6;
        Mon, 15 Aug 2022 20:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594319;
        bh=MiXMrstoPWpyTCuBDxKm+tRaMe6TlgPj+u9hx714plc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhWZM0s3IIBzGxwSScSTWoE+30kJetG/u0pxcI4I+c45rW2TUYBLAAcfjWz/hmPIm
         ssR9ZOjshSlfu2DeOUYegcZvs7Ol15Jm4Fq4gMWcWkEvVnxBFJNdpnTRN8RVpaD+Ke
         wse2Yl72CuFut0Yp+m9OaEzHd/fYFiBo+cIlytN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.18 1092/1095] drm/vc4: change vc4_dma_range_matches from a global to static
Date:   Mon, 15 Aug 2022 20:08:11 +0200
Message-Id: <20220815180514.184361196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

commit 63569d90863ff26c8b10c8971d1271c17a45224b upstream.

sparse reports
drivers/gpu/drm/vc4/vc4_drv.c:270:27: warning: symbol 'vc4_dma_range_matches' was not declared. Should it be static?

vc4_dma_range_matches is only used in vc4_drv.c, so it's storage class specifier
should be static.

Fixes: da8e393e23ef ("drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220629200101.498138-1-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -209,7 +209,7 @@ static void vc4_match_add_drivers(struct
 	}
 }
 
-const struct of_device_id vc4_dma_range_matches[] = {
+static const struct of_device_id vc4_dma_range_matches[] = {
 	{ .compatible = "brcm,bcm2711-hvs" },
 	{ .compatible = "brcm,bcm2835-hvs" },
 	{ .compatible = "brcm,bcm2835-v3d" },


