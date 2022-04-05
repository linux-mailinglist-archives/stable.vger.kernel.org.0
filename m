Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22A44F369C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343756AbiDEK7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiDEJqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6C8DE92A;
        Tue,  5 Apr 2022 02:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49300615E5;
        Tue,  5 Apr 2022 09:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545A4C385A0;
        Tue,  5 Apr 2022 09:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151167;
        bh=nuiZNS0LZFbxEnjILp8WzQte/2BsBW4S8IvxSkSRFMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qd+1QqtHSbenpy1rJg9wl6GAEejFeuEaygaoTT80VhOLn5ZgZZ+7ecZnSVqGv/5vt
         4v8uR8UdcqhvusDq+TclT0CwflYw+EhfxITjojZjUAvXbeuddmGX8M5z4z+gwbT7Pp
         EQvdQdEDRo6saq64OGA+ta5T/NrJnMIW7jOsv8U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/913] ASoC: codecs: rx-macro: fix accessing compander for aux
Date:   Tue,  5 Apr 2022 09:22:59 +0200
Message-Id: <20220405070349.354288054@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 42c709c4e1ce4c136891530646c9abd5dff3524f ]

AUX interpolator does not have compander, so check before accessing
compander data for this.

Without this checkan array of out bounds access will be made in
comp_enabled[] array.

Fixes: 4f692926f562 ("ASoC: codecs: lpass-rx-macro: add dapm widgets and route")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220222183212.11580-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 0f932ca61c81..fafb8265dbb3 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -2039,6 +2039,10 @@ static int rx_macro_load_compander_coeff(struct snd_soc_component *component,
 	int i;
 	int hph_pwr_mode;
 
+	/* AUX does not have compander */
+	if (comp == INTERP_AUX)
+		return 0;
+
 	if (!rx->comp_enabled[comp])
 		return 0;
 
-- 
2.34.1



