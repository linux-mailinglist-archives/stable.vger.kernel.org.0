Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542AC64336D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiLETgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiLETgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BF310A0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EF25CE13A8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5E1C433C1;
        Mon,  5 Dec 2022 19:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268756;
        bh=ew2TlTt2AW0AziLW3L0iPyvweumZITDNadKGWL2Pnjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMqgzKA1Xt3Z3hGv2K22mDdZZWV22TWQI0Jantf5SqpuMDjKnZKLcKjXXyZJqQoxk
         6LPx0oyxpagn+B312v39bF0Kc5Oqit+es2em5942jXjHZvkKQuvq6uXCcGwEN+uWp5
         YmrEOGuzkJOu36NkbwTn22R0tpP3BqIQvUcP3E+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 70/92] ASoC: ops: Fix bounds check for _sx controls
Date:   Mon,  5 Dec 2022 20:10:23 +0100
Message-Id: <20221205190805.819716873@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 698813ba8c580efb356ace8dbf55f61dac6063a8 ]

For _sx controls the semantics of the max field is not the usual one, max
is the number of steps rather than the maximum value. This means that our
check in snd_soc_put_volsw_sx() needs to just check against the maximum
value.

Fixes: 4f1e50d6a9cf9c1b ("ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220511134137.169575-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 0f26d6c31ce5..5fdd96e77ef3 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -432,7 +432,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	if (mc->platform_max && val > mc->platform_max)
 		return -EINVAL;
-	if (val > max - min)
+	if (val > max)
 		return -EINVAL;
 	if (val < 0)
 		return -EINVAL;
-- 
2.35.1



