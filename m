Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7889A153DB6
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 04:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBFDtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 22:49:47 -0500
Received: from mo-csw-fb1115.securemx.jp ([210.130.202.174]:43100 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbgBFDtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 22:49:47 -0500
X-Greylist: delayed 808 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2020 22:49:47 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 0163aIdp006260; Thu, 6 Feb 2020 12:36:18 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 0163aEUN019365; Thu, 6 Feb 2020 12:36:14 +0900
X-Iguazu-Qid: 2wHHVKvLwpFHFG1wDQ
X-Iguazu-QSIG: v=2; s=0; t=1580960174; q=2wHHVKvLwpFHFG1wDQ; m=nbz+gXNiw3wwpJxTlhKgIlXhpDg8unREwx7zVd9ZgY0=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1113) id 0163aDhI027162;
        Thu, 6 Feb 2020 12:36:13 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0163aD7t015722
        for <stable@vger.kernel.org>; Thu, 6 Feb 2020 12:36:13 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0163aDY9019294
        for <stable@vger.kernel.org>; Thu, 6 Feb 2020 12:36:13 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Subject: [PATCH] ASoC: qcom: Fix of-node refcount unbalance to link->codec_of_node
Date:   Thu,  6 Feb 2020 12:36:11 +0900
X-TSB-HOP: ON
Message-Id: <20200206033611.10593-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ This is a fix specific to 4.4.y and 4.9.y stable trees;
  4.14.y and older are not affected ]

The of-node refcount fixes were made in commit 8d1667200850 ("ASoC: qcom: 
Fix of-node refcount unbalance in apq8016_sbc_parse_of()"), but not enough
in 4.4.y and 4.9.y. The modification of link->codec_of_node is missing.
This fixes of-node refcount unbalance to link->codec_of_node.

Fixes: 8d1667200850 ("ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()")
Cc: Patrick Lai <plai@codeaurora.org>
Cc: Banajit Goswami <bgoswami@codeaurora.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 sound/soc/qcom/apq8016_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/qcom/apq8016_sbc.c b/sound/soc/qcom/apq8016_sbc.c
index 886f2027e671..f2c71bcd06fa 100644
--- a/sound/soc/qcom/apq8016_sbc.c
+++ b/sound/soc/qcom/apq8016_sbc.c
@@ -112,7 +112,8 @@ static struct apq8016_sbc_data *apq8016_sbc_parse_of(struct snd_soc_card *card)
 		link->codec_of_node = of_parse_phandle(codec, "sound-dai", 0);
 		if (!link->codec_of_node) {
 			dev_err(card->dev, "error getting codec phandle\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto error;
 		}
 
 		ret = snd_soc_of_get_dai_name(cpu, &link->cpu_dai_name);
-- 
2.23.0

