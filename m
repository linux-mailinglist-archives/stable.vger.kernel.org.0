Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF55219BE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244612AbiEJNvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343912AbiEJNsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC9A6CF5D;
        Tue, 10 May 2022 06:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C995A618B4;
        Tue, 10 May 2022 13:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF45EC385C6;
        Tue, 10 May 2022 13:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189821;
        bh=/G7G98mOkb3wMCY7W2ZwgXvwNVhR/tDRGLVkEvO0kr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/M33Zk0X6O8m/QRSHNvOQSD6ua6Trt9pL4i4wKcqnDRKLnaqNPyoqFDCp0Ouzbbt
         aC20h5wOJzzZ5ROrjvlzVYFc4Ndoq9M9BAD8kXhn8LGeteGCBo5XscTKO+DBGTlvON
         Puub+0UA85kCvbK/V1qPuWpb978kU2gMpB97pde8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 5.17 038/140] ASoC: meson: Fix event generation for AUI ACODEC mux
Date:   Tue, 10 May 2022 15:07:08 +0200
Message-Id: <20220510130742.708181307@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 2e3a0d1bfa95b54333f7add3e50e288769373873 upstream.

The AIU ACODEC has a custom put() operation which returns 0 when the value
of the mux changes, meaning that events are not generated for userspace.
Change to return 1 in this case, the function returns early in the case
where there is no change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20220421123803.292063-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/meson/aiu-acodec-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/meson/aiu-acodec-ctrl.c
+++ b/sound/soc/meson/aiu-acodec-ctrl.c
@@ -58,7 +58,7 @@ static int aiu_acodec_ctrl_mux_put_enum(
 
 	snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
 
-	return 0;
+	return 1;
 }
 
 static SOC_ENUM_SINGLE_DECL(aiu_acodec_ctrl_mux_enum, AIU_ACODEC_CTRL,


