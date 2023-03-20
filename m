Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7336C198B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbjCTPek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjCTPeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:34:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1EE35EC3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B242B80EAB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52647C4339B;
        Mon, 20 Mar 2023 15:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326019;
        bh=ba6L21C3hPRAFcDmsnPxAcMMAGQ4TxPfN8sCtncYEAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdQ93ubC9+T8U0b/Mwu41FVxd8FG+ceTvKBMfnGXpOTBAfqtUaxzNb0nyeJxiwMNl
         ylqWnavw5+cSCCHd2EJei6TRd0RKRGrUVKotvx30yiCZPTF+/FTkURNIg+MrRbumFz
         q9DPUsyL5bXFg6DKwrTgQCmYwHi3s5lOi3isi8I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 186/198] ASoC: qcom: q6prm: fix incorrect clk_root passed to ADSP
Date:   Mon, 20 Mar 2023 15:55:24 +0100
Message-Id: <20230320145515.279275871@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 65882134bc622a1e57bd5928ac588855ea2e3ddd upstream.

The second to last argument is clk_root (root of the clock), however the
code called q6prm_request_lpass_clock() with clk_attr instead
(copy-paste error).  This effectively was passing value of 1 as root
clock which worked on some of the SoCs (e.g. SM8450) but fails on
others, depending on the ADSP.  For example on SM8550 this "1" as root
clock is not accepted and results in errors coming from ADSP.

Fixes: 2f20640491ed ("ASoC: qdsp6: qdsp6: q6prm: handle clk disable correctly")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230302122908.221398-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6prm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6prm.c
+++ b/sound/soc/qcom/qdsp6/q6prm.c
@@ -183,9 +183,9 @@ int q6prm_set_lpass_clock(struct device
 			  unsigned int freq)
 {
 	if (freq)
-		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
+		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
 
-	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
+	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
 }
 EXPORT_SYMBOL_GPL(q6prm_set_lpass_clock);
 


