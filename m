Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5280E38A442
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhETKC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234492AbhETKAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF478613CB;
        Thu, 20 May 2021 09:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503546;
        bh=03+9eMx7MuugkvL3VbqTibyPzQJwSWfXjP0G3pkTcpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGAaP+bXQ8BAhEvnrdJKka+ZBoAHTmn5p4DGRDAq9U66weMRvQ6I9YmMDi3f3yxjv
         g/ULkER6VlquWDxKh1oxs0vHqRG7x0EwtViqc7mw09Va3mU5pHvA7VvItQ4RhA+hnd
         SqEnd4c84PZRV+nUCF7kzz6dU2pWD0Kki681+y7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 271/425] ASoC: ak5558: correct reset polarity
Date:   Thu, 20 May 2021 11:20:40 +0200
Message-Id: <20210520092140.347388850@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 0b93bbc977af55fd10687f2c96c807cba95cb927 ]

Reset (aka power off) happens when the reset gpio is made active.
The reset gpio is GPIO_ACTIVE_LOW

Fixes: 920884777480 ("ASoC: ak5558: Add support for AK5558 ADC driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1618382024-31725-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak5558.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak5558.c b/sound/soc/codecs/ak5558.c
index 73c418517f8d..dda165b14222 100644
--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -271,7 +271,7 @@ static void ak5558_power_off(struct ak5558_priv *ak5558)
 	if (!ak5558->reset_gpiod)
 		return;
 
-	gpiod_set_value_cansleep(ak5558->reset_gpiod, 0);
+	gpiod_set_value_cansleep(ak5558->reset_gpiod, 1);
 	usleep_range(1000, 2000);
 }
 
@@ -280,7 +280,7 @@ static void ak5558_power_on(struct ak5558_priv *ak5558)
 	if (!ak5558->reset_gpiod)
 		return;
 
-	gpiod_set_value_cansleep(ak5558->reset_gpiod, 1);
+	gpiod_set_value_cansleep(ak5558->reset_gpiod, 0);
 	usleep_range(1000, 2000);
 }
 
-- 
2.30.2



