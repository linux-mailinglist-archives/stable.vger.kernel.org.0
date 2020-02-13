Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EB115C780
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgBMPW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbgBMPW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:26 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475CC24691;
        Thu, 13 Feb 2020 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607344;
        bh=r3ITya3+iLuggfTp/Cp5GzvU6us3UZStXpWPGQ4bTj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1qlIsHGhmqvB6/hgRK4mE0MbuIxC7vGKRSTQcF8/eHY4C+r/c/nxv30hmKx71zqF
         c78ee8wf6TcHJ9i8NFaFKq54levznBFXUyED38aAFQWfwH956xuOwhO9l7oNYjOm0a
         vlsRCOinFSxoS05odEh3fTgoSPQz4Q2lENTG6a1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Patrick Lai <plai@codeaurora.org>,
        Banajit Goswami <bgoswami@codeaurora.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 04/91] ASoC: qcom: Fix of-node refcount unbalance to link->codec_of_node
Date:   Thu, 13 Feb 2020 07:19:21 -0800
Message-Id: <20200213151823.036410808@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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



