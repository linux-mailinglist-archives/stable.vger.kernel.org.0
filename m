Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB38C60B11A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbiJXQQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiJXQO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF752DF4E;
        Mon, 24 Oct 2022 08:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A60DFB81262;
        Mon, 24 Oct 2022 12:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F34EC433B5;
        Mon, 24 Oct 2022 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613826;
        bh=PVaDbcEgz6seddyXDXdU/WaBmcLKoTNo/6qbCXoQBPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3Z/unaXR2i+arL2JyhzrIH7LyQcc12Wv1GoWUyST0bmKoDoOeY5XpIInZCLtibWh
         +W7aGsT6JogyZRFEQTIfuqQ6LKCN6bWqQzAPCb9BX6TOzrT6wZdwB3eNmZSDMe/ZjK
         5lkv76fVG2RS4V/9sGnuZD3KmzArVWlkLR//vry8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 029/390] ASoC: wcd934x: fix order of Slimbus unprepare/disable
Date:   Mon, 24 Oct 2022 13:27:06 +0200
Message-Id: <20221024113023.823381366@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit e96bca7eaa5747633ec638b065630ff83728982a upstream.

Slimbus streams are first prepared and then enabled, so the cleanup path
should reverse it.  The unprepare sets stream->num_ports to 0 and frees
the stream->ports.  Calling disable after unprepare was not really
effective (channels was not deactivated) and could lead to further
issues due to making transfers on unprepared stream.

Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220921145354.1683791-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1829,8 +1829,8 @@ static int wcd934x_trigger(struct snd_pc
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:
 		break;


