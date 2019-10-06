Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE08ECD565
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfJFRft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730071AbfJFRex (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:34:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFB942087E;
        Sun,  6 Oct 2019 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383292;
        bh=ZFiPp8ngyxu+/Da+Enw9S3iTkIS4pdRuux3QPVR7nWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeJL2z8p60I3MhR/ijHN98bTOKSxOVWrChoKsk9zIqMMoAcKbfLYQxp1owjD/cFgR
         kD68eSY9jAiOjxLQCGPLBDxkWi9V1schpw34oFdguerb94hHHd15Ykwk+fu8j1fUHO
         w/5pwgOAm0r6ptzFEESr3zWTqqyeaewmxuXNpH2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 051/137] clk: meson: axg-audio: Dont reference clk_init_data after registration
Date:   Sun,  6 Oct 2019 19:20:35 +0200
Message-Id: <20191006171213.024227401@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 1610dd79d0f6202c5c1a91122255fa598679c13a ]

A future patch is going to change semantics of clk_register() so that
clk_hw::init is guaranteed to be NULL after a clk is registered. Avoid
referencing this member here so that we don't run into NULL pointer
exceptions.

Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190731193517.237136-4-sboyd@kernel.org
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/axg-audio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/meson/axg-audio.c b/drivers/clk/meson/axg-audio.c
index 8028ff6f66107..db0b73d53551d 100644
--- a/drivers/clk/meson/axg-audio.c
+++ b/drivers/clk/meson/axg-audio.c
@@ -992,15 +992,18 @@ static int axg_audio_clkc_probe(struct platform_device *pdev)
 
 	/* Take care to skip the registered input clocks */
 	for (i = AUD_CLKID_DDR_ARB; i < data->hw_onecell_data->num; i++) {
+		const char *name;
+
 		hw = data->hw_onecell_data->hws[i];
 		/* array might be sparse */
 		if (!hw)
 			continue;
 
+		name = hw->init->name;
+
 		ret = devm_clk_hw_register(dev, hw);
 		if (ret) {
-			dev_err(dev, "failed to register clock %s\n",
-				hw->init->name);
+			dev_err(dev, "failed to register clock %s\n", name);
 			return ret;
 		}
 	}
-- 
2.20.1



