Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E53F55C7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbfKHTEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbfKHTEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42285214DB;
        Fri,  8 Nov 2019 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239877;
        bh=AesfdGlm8YQjMxu4s+FElDE3//jeAMGU3vcsCdV64L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5WUNBy8+IwF3/GBqvk3wI5Qoph2VeVQFVdRAcSSznw152ynvT0bwDH3uAR4sXCAS
         KKzC1rP7iGtPUbStKjK1dEZuuexhpnWIsm5HavCr93UGg5HVU15gfZUOObNB2YCMW3
         Wa50U9wPjVPhRQoWMnkqzaOmmca1mcoCU1ADHK6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keyon Jie <yang.jie@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 013/140] ASoC: SOF: topology: fix parse fail issue for byte/bool tuple types
Date:   Fri,  8 Nov 2019 19:49:01 +0100
Message-Id: <20191108174902.528253660@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keyon Jie <yang.jie@linux.intel.com>

[ Upstream commit 2e305a074061121220a2828f97a57d315cf8efba ]

We are using sof_parse_word_tokens() to parse tokens with
bool/byte/short/word tuple types, here add the missing check, to fix the
parsing failure at byte/bool tuple types.

Signed-off-by: Keyon Jie <yang.jie@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927200538.660-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 432ae343f9602..96230329e678f 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -907,7 +907,9 @@ static void sof_parse_word_tokens(struct snd_soc_component *scomp,
 		for (j = 0; j < count; j++) {
 			/* match token type */
 			if (!(tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_WORD ||
-			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_SHORT))
+			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_SHORT ||
+			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_BYTE ||
+			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_BOOL))
 				continue;
 
 			/* match token id */
-- 
2.20.1



