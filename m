Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792A94ABC98
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386905AbiBGLiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385632AbiBGLcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A7CC03E97B;
        Mon,  7 Feb 2022 03:31:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E06A60A67;
        Mon,  7 Feb 2022 11:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D906C004E1;
        Mon,  7 Feb 2022 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233476;
        bh=u4UjAcFF1Zp7pNCg0/6sdayjl3EP4O06VFNJH8ux4dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCAusrYktKQ8Qrf5q/uFB54nitZyNWBjM3ha7v6/5G8PhdSFZg2RJH0TSmBOwZL/D
         VyxEdmDrpAyv+r12zzqmbhwE3JqvxQuALCDFdmKHtZY5P1ToZn+nJeSte1VxO97S30
         9vFo/9pGfTQfKp/d3TVdVCHv6GExtTfolCUBh6KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 008/126] ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()
Date:   Mon,  7 Feb 2022 12:05:39 +0100
Message-Id: <20220207103804.346066525@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

commit 4f1e50d6a9cf9c1b8c859d449b5031cacfa8404e upstream.

We don't currently validate that the values being set are within the range
we advertised to userspace as being valid, do so and reject any values
that are out of range.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220124153253.3548853-3-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -423,8 +423,15 @@ int snd_soc_put_volsw_sx(struct snd_kcon
 	int err = 0;
 	unsigned int val, val_mask;
 
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
 	val_mask = mask << shift;
-	val = (ucontrol->value.integer.value[0] + min) & mask;
+	val = (val + min) & mask;
 	val = val << shift;
 
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);


