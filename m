Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9882B5219CA
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244792AbiEJNvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343783AbiEJNs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE99F6BFC2;
        Tue, 10 May 2022 06:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E5806193B;
        Tue, 10 May 2022 13:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE76C385A6;
        Tue, 10 May 2022 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189811;
        bh=2HnKUKKeygCNULEDLTGebDWd/Upf5P086EXE4P6TmGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orVcPb7GCruTZwDd5sCW002o3SDZ5jR4xU2tiTcgNOX/baTEm5AIR8pqVGSJbPuHj
         3f4WtSjIMfhS6A62Z5Q8YsM/rWqOA7z0ZtbESfBrMbuBLt3tmDnqSLtOyFA7hXhqBF
         IUURQc40Jilbjk7KhoszxRXVMO22BJoxUuBpAk/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: [PATCH 5.17 035/140] ASoC: da7219: Fix change notifications for tone generator frequency
Date:   Tue, 10 May 2022 15:07:05 +0200
Message-Id: <20220510130742.622953937@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 08ef48404965cfef99343d6bbbcf75b88c74aa0e upstream.

The tone generator frequency control just returns 0 on successful write,
not a boolean value indicating if there was a change or not.  Compare
what was written with the value that was there previously so that
notifications are generated appropriately when the value changes.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220420133437.569229-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/da7219.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/da7219.c
+++ b/sound/soc/codecs/da7219.c
@@ -446,7 +446,7 @@ static int da7219_tonegen_freq_put(struc
 	struct soc_mixer_control *mixer_ctrl =
 		(struct soc_mixer_control *) kcontrol->private_value;
 	unsigned int reg = mixer_ctrl->reg;
-	__le16 val;
+	__le16 val_new, val_old;
 	int ret;
 
 	/*
@@ -454,13 +454,19 @@ static int da7219_tonegen_freq_put(struc
 	 * Therefore we need to convert to little endian here to align with
 	 * HW registers.
 	 */
-	val = cpu_to_le16(ucontrol->value.integer.value[0]);
+	val_new = cpu_to_le16(ucontrol->value.integer.value[0]);
 
 	mutex_lock(&da7219->ctrl_lock);
-	ret = regmap_raw_write(da7219->regmap, reg, &val, sizeof(val));
+	ret = regmap_raw_read(da7219->regmap, reg, &val_old, sizeof(val_old));
+	if (ret == 0 && (val_old != val_new))
+		ret = regmap_raw_write(da7219->regmap, reg,
+				&val_new, sizeof(val_new));
 	mutex_unlock(&da7219->ctrl_lock);
 
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	return val_old != val_new;
 }
 
 


