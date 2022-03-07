Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0CF4CF7F9
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiCGJvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238465AbiCGJqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:46:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9496A067;
        Mon,  7 Mar 2022 01:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57149612D2;
        Mon,  7 Mar 2022 09:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51045C340F5;
        Mon,  7 Mar 2022 09:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646124;
        bh=J3C58RKqRkdt0Z9ppRxUiMEM8xgTHy1k+NvGXw5NCTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aoz1C0iU9aRnBf7M8u+UMnrQskABs9MTKv8zYRkaIHAxxYtmJRHNMhHXy6ziFiPO9
         oB9rr4w+n0dUpuMGz3qkIniZ6eMkbfPZRJCrl522wcNgbwO5sUclpP8IJcUNEFgvZn
         36xpjgEy7kgIKWRaxuqe/in0puvC4ZEChAPPf52Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 142/262] ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min
Date:   Mon,  7 Mar 2022 10:18:06 +0100
Message-Id: <20220307091706.456217954@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 9bdd10d57a8807dba0003af0325191f3cec0f11c upstream.

While the $val/$val2 values passed in from userspace are always >= 0
integers, the limits of the control can be signed integers and the $min
can be non-zero and less than zero. To correctly validate $val/$val2
against platform_max, add the $min offset to val first.

Fixes: 817f7c9335ec0 ("ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220215130645.164025-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -317,7 +317,7 @@ int snd_soc_put_volsw(struct snd_kcontro
 		mask = BIT(sign_bit + 1) - 1;
 
 	val = ucontrol->value.integer.value[0];
-	if (mc->platform_max && val > mc->platform_max)
+	if (mc->platform_max && ((int)val + min) > mc->platform_max)
 		return -EINVAL;
 	if (val > max - min)
 		return -EINVAL;
@@ -330,7 +330,7 @@ int snd_soc_put_volsw(struct snd_kcontro
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
 		val2 = ucontrol->value.integer.value[1];
-		if (mc->platform_max && val2 > mc->platform_max)
+		if (mc->platform_max && ((int)val2 + min) > mc->platform_max)
 			return -EINVAL;
 		if (val2 > max - min)
 			return -EINVAL;


