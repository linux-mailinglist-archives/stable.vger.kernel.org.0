Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF80259A3F4
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354535AbiHSQ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354551AbiHSQ6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:58:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5076D8FD77;
        Fri, 19 Aug 2022 09:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B30DB82804;
        Fri, 19 Aug 2022 16:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBADC433C1;
        Fri, 19 Aug 2022 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925634;
        bh=TPzgaIJuOizJxR9x4k1d5t0DH36A5tRfqFS8Y68oOhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFdiOLNx7kVYW4hG9RhfFRdEECUJ2n2OiNQJT9HyEMOwwmonAQVd/G+Y/ChIZ/wXr
         S33AOR86PLz7sgFbFTxAW6yEgnnzLdeHCM7AbDnQhqEyuUtF7+X3Z8jUiVlIDgCLW4
         /j65FgdCGAJPF/qOyFAM3bo3EW+dMiMZzFDnV2kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.10 535/545] drm/vc4: change vc4_dma_range_matches from a global to static
Date:   Fri, 19 Aug 2022 17:45:05 +0200
Message-Id: <20220819153853.527784471@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
@@ -246,7 +246,7 @@ static void vc4_match_add_drivers(struct
 	}
 }
 
-const struct of_device_id vc4_dma_range_matches[] = {
+static const struct of_device_id vc4_dma_range_matches[] = {
 	{ .compatible = "brcm,bcm2711-hvs" },
 	{ .compatible = "brcm,bcm2835-hvs" },
 	{ .compatible = "brcm,bcm2835-v3d" },


