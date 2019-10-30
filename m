Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F84DE9F9B
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfJ3PuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfJ3Ptk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:49:40 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA212087E;
        Wed, 30 Oct 2019 15:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450579;
        bh=dyWpOrS8kPblaluBAYmqNzbntvaVnGy7CHkLumzzqAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny3avsmbZ+JH+1/gN8NdRePqKYGQynjcUVbPm+PNtCeGn32DXk12PnThKPp9SraNB
         8QXeVEbs7H7bz0njNWQtgepBAoVWp1R+ssUg8UT5zXuzsrQ836/w4WyiUEaC+RRNJx
         ANUd5raXwfN29hPTav7uZIt9M17h3+lGurtqoTOg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 05/81] ASoC: topology: Fix a signedness bug in soc_tplg_dapm_widget_create()
Date:   Wed, 30 Oct 2019 11:48:11 -0400
Message-Id: <20191030154928.9432-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 752c938a5c14b8cbf0ed3ffbfa637fb166255c3f ]

The "template.id" variable is an enum and in this context GCC will
treat it as an unsigned int so it can never be less than zero.

Fixes: 8a9782346dcc ("ASoC: topology: Add topology core")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20190925110624.GR3264@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index dc463f1a9e242..1cc5a07a2f5c7 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1588,7 +1588,7 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 
 	/* map user to kernel widget ID */
 	template.id = get_widget_id(le32_to_cpu(w->id));
-	if (template.id < 0)
+	if ((int)template.id < 0)
 		return template.id;
 
 	/* strings are allocated here, but used and freed by the widget */
-- 
2.20.1

