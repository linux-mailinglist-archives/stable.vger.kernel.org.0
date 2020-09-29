Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8976127CBF4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbgI2McB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgI2LXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:23:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B8A221E8;
        Tue, 29 Sep 2020 11:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378463;
        bh=rc12dbAf/EcJVbkGg4lUytsW5oyYLwKajNJbdmO3Wpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1xWPW9EBbFHbsXYwRXue8Ir2csUAGg4fejPD2yV+YiOWKvrkKw8fHkv3N+kY01fM
         aR5w+9BKb1zLaucpFwjPAv/KLSPkTWtZHup8oH6autpp8m3eqJF91ydzkBFDX3SX4Y
         vDivAJdT53qN9DsRp7QQNeuILmjRjtC4XB6T3G4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Kitt <steve@sk2.org>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/245] clk/ti/adpll: allocate room for terminating null
Date:   Tue, 29 Sep 2020 12:57:54 +0200
Message-Id: <20200929105948.127161149@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Kitt <steve@sk2.org>

[ Upstream commit 7f6ac72946b88b89ee44c1c527aa8591ac5ffcbe ]

The buffer allocated in ti_adpll_clk_get_name doesn't account for the
terminating null. This patch switches to devm_kasprintf to avoid
overflowing.

Signed-off-by: Stephen Kitt <steve@sk2.org>
Link: https://lkml.kernel.org/r/20191019140634.15596-1-steve@sk2.org
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index 688e403333b91..14926e07d09ae 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -193,15 +193,8 @@ static const char *ti_adpll_clk_get_name(struct ti_adpll_data *d,
 		if (err)
 			return NULL;
 	} else {
-		const char *base_name = "adpll";
-		char *buf;
-
-		buf = devm_kzalloc(d->dev, 8 + 1 + strlen(base_name) + 1 +
-				    strlen(postfix), GFP_KERNEL);
-		if (!buf)
-			return NULL;
-		sprintf(buf, "%08lx.%s.%s", d->pa, base_name, postfix);
-		name = buf;
+		name = devm_kasprintf(d->dev, GFP_KERNEL, "%08lx.adpll.%s",
+				      d->pa, postfix);
 	}
 
 	return name;
-- 
2.25.1



