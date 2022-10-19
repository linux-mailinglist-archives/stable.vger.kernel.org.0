Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A143603C0C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiJSIm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiJSIlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:41:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936E62314C;
        Wed, 19 Oct 2022 01:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5223CB82256;
        Wed, 19 Oct 2022 08:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810C0C433D6;
        Wed, 19 Oct 2022 08:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168778;
        bh=obwycopaJ/uBms9NswMDeNgX5qTwLCACrJks60hkFjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M93bjaLUzqS/IT7Ve9sJL0rl5pAiNcmW0jLk4cXow7yIdp5jCKF8Q8DVnm8vNkBQ8
         As1dJ8B0HGfN0fMavLu7cXUB7CVvklXmyzXVYz3O+DVNij/2wIQ5n9q0NyalN+4vTO
         GGBldte3P/8QPfwHp0AmTIrVxjH6lhj7aH5fepQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 050/862] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Date:   Wed, 19 Oct 2022 10:22:17 +0200
Message-Id: <20221019083252.209705544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ea8ef003aa53ad23e7705c5cab1c4e664faa6c79 upstream.

Slimbus streams are first prepared and then enabled, so the cleanup path
should reverse it.  The unprepare sets stream->num_ports to 0 and frees
the stream->ports.  Calling disable after unprepare was not really
effective (channels was not deactivated) and could lead to further
issues due to making transfers on unprepared stream.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220921145354.1683791-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd9335.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1974,8 +1974,8 @@ static int wcd9335_trigger(struct snd_pc
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:
 		break;


