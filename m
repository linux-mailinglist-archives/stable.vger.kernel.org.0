Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52320574390
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiGNEgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiGNEer (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:34:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC6A3B948;
        Wed, 13 Jul 2022 21:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B115B82333;
        Thu, 14 Jul 2022 04:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40A4C341C8;
        Thu, 14 Jul 2022 04:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772783;
        bh=eFBsxCetDJ205hLgzjrUyOHlkkYq8VLi5QVzS+pJUJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAWzocFkWBmINUfFtSX+Er98uR2baL6mDhUBJU3binc322ZWQITLbQO7YlluzipJh
         V8iDYK5jchKvcYmofJWqIJzifY6NeQw2QTrDIG97ZRlNukDUFbLM2c7MPXGcdRet3d
         3kNcOOLrV1iUDkyruSuZghl5+mECjsyWlFE4tXoG2liST3l3Hmh6Ncv/tpEjRnmVBU
         4b/CYWCBnvmBaAQUeHnmJ9LEyLNagRekb/lcYUzvfeTdOzr9bDcceWzV/+h4+vYSXG
         NccRLLZWSRIhJP0xtFfuv2vbNonuy3uyqxl5sOKs1Jr4NGjlMnkXxu5KEDlsW7B81V
         eujtsFj5PlX2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rf@opensource.cirrus.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 04/10] ASoC: madera: Fix event generation for OUT1 demux
Date:   Thu, 14 Jul 2022 00:26:06 -0400
Message-Id: <20220714042612.282378-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042612.282378-1-sashal@kernel.org>
References: <20220714042612.282378-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e3cabbef3db8269207a6b8808f510137669f8deb ]

madera_out1_demux_put returns the value of
snd_soc_dapm_mux_update_power, which returns a 1 if a path was found for
the kcontrol. This is obviously different to the expected return a 1 if
the control was updated value. This results in spurious notifications to
user-space. Update the handling to only return a 1 when the value is
changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/madera.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/madera.c b/sound/soc/codecs/madera.c
index 52639811cc52..e375dca9ba8d 100644
--- a/sound/soc/codecs/madera.c
+++ b/sound/soc/codecs/madera.c
@@ -568,7 +568,13 @@ int madera_out1_demux_put(struct snd_kcontrol *kcontrol,
 end:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-	return snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	ret = snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	if (ret < 0) {
+		dev_err(madera->dev, "Failed to update demux power state: %d\n", ret);
+		return ret;
+	}
+
+	return change;
 }
 EXPORT_SYMBOL_GPL(madera_out1_demux_put);
 
-- 
2.35.1

