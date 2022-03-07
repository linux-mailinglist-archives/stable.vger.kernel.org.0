Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF994CF49B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbiCGJUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiCGJUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AC449913;
        Mon,  7 Mar 2022 01:19:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F3FFB810B9;
        Mon,  7 Mar 2022 09:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADFDC340F3;
        Mon,  7 Mar 2022 09:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644756;
        bh=FiohOt7NoQYLxo5ix/ERErfoSi8NWtSUiMdB3zj+G9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00/nN/vAoQDPnQUTqH55kuxp3cEtRYDq5t/INNzaUXXrSqNRQOO+++mqdEtkomakq
         Uf5D9fQl/a9G5S6sRjo23clE2fLhZeJ8iFmvL/LiIc9cZh1VzKTmMKUW/taFsIJsvZ
         V+9dWzXV6xWWci+PJ0t8wAoS3FX4nRq1qlXZZsns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 12/32] ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min
Date:   Mon,  7 Mar 2022 10:18:38 +0100
Message-Id: <20220307091634.790582784@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
References: <20220307091634.434478485@linuxfoundation.org>
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
@@ -328,7 +328,7 @@ int snd_soc_put_volsw(struct snd_kcontro
 		mask = BIT(sign_bit + 1) - 1;
 
 	val = ucontrol->value.integer.value[0];
-	if (mc->platform_max && val > mc->platform_max)
+	if (mc->platform_max && ((int)val + min) > mc->platform_max)
 		return -EINVAL;
 	if (val > max - min)
 		return -EINVAL;
@@ -341,7 +341,7 @@ int snd_soc_put_volsw(struct snd_kcontro
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
 		val2 = ucontrol->value.integer.value[1];
-		if (mc->platform_max && val2 > mc->platform_max)
+		if (mc->platform_max && ((int)val2 + min) > mc->platform_max)
 			return -EINVAL;
 		if (val2 > max - min)
 			return -EINVAL;


