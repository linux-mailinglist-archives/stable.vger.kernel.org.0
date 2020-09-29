Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF8427C463
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgI2LNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbgI2LNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:13:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C3DD221E7;
        Tue, 29 Sep 2020 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378009;
        bh=FTn1Kzua1foQM2Tm0+Dr/bPtM5tkJRU8+Es3JWSissk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKLAefA5Izvq7gzlXT5P7aO/CHxRoBR6DMdV4fkxorGbjNU/bNiHbWZE/kiasMipF
         YkJl3guH8tiylqWuuOZfA7TM9hVoWjyz6JyuYiENoN1gEwOQGvRC9P3Z3P0/1n1IMd
         tuGn25O9QBBu6/VURtEsh3qOpgGrOX0jIWikNYEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Kitt <steve@sk2.org>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 030/166] clk/ti/adpll: allocate room for terminating null
Date:   Tue, 29 Sep 2020 12:59:02 +0200
Message-Id: <20200929105936.711106163@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
index d6036c788fab8..2738ecb1511b1 100644
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



