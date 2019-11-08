Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE6FCF55DE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391121AbfKHTFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfKHTFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:05:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0521A218AE;
        Fri,  8 Nov 2019 19:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239918;
        bh=dyWpOrS8kPblaluBAYmqNzbntvaVnGy7CHkLumzzqAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9ZYCjAukt9XCdiOtqgRy5nmH89MBLSwvRRuLqAe4TNqA0pRo7dJXVXg8iX0j8018
         Pfr85m4bNzelFk2r3HwHor1L+AzZzExGNzLDU66S+HFGWGYaXyGxaf3KLE6sUL3Sad
         auuZRYYnFH2PwZV8NKm7wvnXH4jFMX9ZC5eg+kSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 005/140] ASoC: topology: Fix a signedness bug in soc_tplg_dapm_widget_create()
Date:   Fri,  8 Nov 2019 19:48:53 +0100
Message-Id: <20191108174900.650765622@linuxfoundation.org>
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



