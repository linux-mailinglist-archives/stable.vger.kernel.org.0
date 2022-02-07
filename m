Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60FC4ABC32
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384989AbiBGLaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358128AbiBGLZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:25:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2ADC043181;
        Mon,  7 Feb 2022 03:25:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5C12B81158;
        Mon,  7 Feb 2022 11:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172C2C004E1;
        Mon,  7 Feb 2022 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233115;
        bh=/hAnYNohmzw9oQdX6Kt9aR6iA/2JH1LYTQg7rMfMCQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpIsUQPVyEfpYmxdSz6acPVCmnSlXRWkg+qDbQ1Jzp1PpO+XXrgfm3A7EUFi3If4M
         kxebcIP7OfX2+Pg9xfmdtEjMI4VupYgyOoy6Cb8sP6MM4S1hxcvDe7ay6vHIDTAXkX
         eBLoZmMl2sfr489W6Q3djawNbvttoUxtj14wazJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 009/110] ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()
Date:   Mon,  7 Feb 2022 12:05:42 +0100
Message-Id: <20220207103802.594628456@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 4cf28e9ae6e2e11a044be1bcbcfa1b0d8675fe4d upstream.

We don't currently validate that the values being set are within the range
we advertised to userspace as being valid, do so and reject any values
that are out of range.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220124153253.3548853-4-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -879,6 +879,8 @@ int snd_soc_put_xr_sx(struct snd_kcontro
 	long val = ucontrol->value.integer.value[0];
 	unsigned int i;
 
+	if (val < mc->min || val > mc->max)
+		return -EINVAL;
 	if (invert)
 		val = max - val;
 	val &= mask;


