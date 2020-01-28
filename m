Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B194E14BB0E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgA1OnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:43:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgA1OL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:11:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7601820678;
        Tue, 28 Jan 2020 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220718;
        bh=+U6b4XD2WqxgEkprIzTowYWBmXQtV3ncKvDWiac7q+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGORmmcLeFSlvAArTQlTXYmcx1SEvgWgxemd60AJw/g5YfnU9QbZiYx8um52A8exb
         lzfvZ7ATREs+QpTEvrOPzsv8dDncEs2MNb/204suOCTzJD20sWr1xe9LLBMpmfVDAr
         pRnSF8/xwKw7deSLUrsLvp1S5GjlN4/dLscslly4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 112/183] libertas_tf: Use correct channel range in lbtf_geo_init
Date:   Tue, 28 Jan 2020 15:05:31 +0100
Message-Id: <20200128135841.105057769@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2ec4ad49b98e4a14147d04f914717135eca7c8b1 ]

It seems we should use 'range' instead of 'priv->range'
in lbtf_geo_init(), because 'range' is the corret one
related to current regioncode.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 691cdb49388b ("libertas_tf: command helper functions for libertas_tf")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/libertas_tf/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 909ac3685010f..2b193f1257a5a 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -69,7 +69,7 @@ static void lbtf_geo_init(struct lbtf_private *priv)
 			break;
 		}
 
-	for (ch = priv->range.start; ch < priv->range.end; ch++)
+	for (ch = range->start; ch < range->end; ch++)
 		priv->channels[CHAN_TO_IDX(ch)].flags = 0;
 }
 
-- 
2.20.1



