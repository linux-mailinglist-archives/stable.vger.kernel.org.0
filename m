Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D287F56082
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfFZDlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbfFZDlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:35 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E002C2146E;
        Wed, 26 Jun 2019 03:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520495;
        bh=bDkVQeypVwfhZfCq1//tGQg0D9nICTUmO2ePc9iVSdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6epzu6BdolQ6IDJJvGF27MzA3qoXZM/1sFZiISFvIxefN31YhE+jTxpDksiGmlfM
         C3HLWVo1Db5VPDDp8dYkj4GfitQgJcEVmmwC9iSd0FecurSdyeskeroaBRkzLqgAkt
         wU9y8N/ntLuyhxL5fVSjUyAshIZ9lwOGIAIUi2EM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 07/51] ASoC: soc-dpm: fixup DAI active unbalance
Date:   Tue, 25 Jun 2019 23:40:23 -0400
Message-Id: <20190626034117.23247-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit f7c4842abfa1a219554a3ffd8c317e8fdd979bec ]

snd_soc_dai_link_event() is updating snd_soc_dai :: active,
but it is unbalance.
It counts up if it has startup callback.

	case SND_SOC_DAPM_PRE_PMU:
		...
		snd_soc_dapm_widget_for_each_source_path(w, path) {
			...
			if (source->driver->ops->startup) {
				...
=>				source->active++;
			}
			...
		}
		...

But, always counts down

	case SND_SOC_DAPM_PRE_PMD:
		...
		snd_soc_dapm_widget_for_each_source_path(w, path) {
			...
=>			source->active--;
			...
		}

This patch always counts up when SND_SOC_DAPM_PRE_PMD.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 5d9d7678e4fa..1ee67716d558 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3831,8 +3831,8 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 						ret);
 					goto out;
 				}
-				source->active++;
 			}
+			source->active++;
 			ret = soc_dai_hw_params(&substream, params, source);
 			if (ret < 0)
 				goto out;
@@ -3853,8 +3853,8 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 						ret);
 					goto out;
 				}
-				sink->active++;
 			}
+			sink->active++;
 			ret = soc_dai_hw_params(&substream, params, sink);
 			if (ret < 0)
 				goto out;
-- 
2.20.1

