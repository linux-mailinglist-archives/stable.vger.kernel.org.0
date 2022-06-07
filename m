Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C241541021
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351519AbiFGTSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355934AbiFGTRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:17:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DFB3B293;
        Tue,  7 Jun 2022 11:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55AACB81F38;
        Tue,  7 Jun 2022 18:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FA2C385A5;
        Tue,  7 Jun 2022 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625267;
        bh=NSpYyGGJXBbVhvCEmdzTJ3lzz03ll/lczQXkZqe5C3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVV7GVqgiEyQZ+4YNeY7H//RRa8Nc/CKmsgeT6i0QL7di9gIEaGL9S96K+8ASdxXO
         lsIdvLvhruoSM0S2fvTzDlWiR2Gs8WJ3YNu7YyOVnZHl6SB2sWvBXml/CU+DwiU853
         BeQ9+UzEeZlqCH5bIzce/xslCLtFSEXeYUm29gc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 626/667] ASoC: rt5514: Fix event generation for "DSP Voice Wake Up" control
Date:   Tue,  7 Jun 2022 19:04:51 +0200
Message-Id: <20220607164953.442990402@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 4213ff556740bb45e2d9ff0f50d056c4e7dd0921 upstream.

The driver has a custom put function for "DSP Voice Wake Up" which does
not generate event notifications on change, instead returning 0. Since we
already exit early in the case that there is no change this can be fixed
by unconditionally returning 1 at the end of the function.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220428162444.3883147-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5514.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/rt5514.c
+++ b/sound/soc/codecs/rt5514.c
@@ -419,7 +419,7 @@ static int rt5514_dsp_voice_wake_up_put(
 		}
 	}
 
-	return 0;
+	return 1;
 }
 
 static const struct snd_kcontrol_new rt5514_snd_controls[] = {


