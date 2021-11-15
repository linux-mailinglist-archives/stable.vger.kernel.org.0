Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22185450F0C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhKOSZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:25:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241539AbhKOSWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88A3963414;
        Mon, 15 Nov 2021 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998789;
        bh=FzyUlUWB2ClNhaYI5im7P9AoIa7CyhYvfNz6wbi/a1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNUf7Yssud+1RjDbqQe2FXQylzA7NPlmM4q4m3u21DJ4Ag2yfKwOOEo27Jc4LeZPg
         YYa5nrhIBeRB/F/T9imezC3aPucW1NpDMFFNXFF7T5HslmN3D1F3HrVryEWvIdgjAL
         RPo73MnujTluSWbqBxInBq/6RlPSkdDSzDdBUw68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 061/849] net: sparx5: Add of_node_put() before goto
Date:   Mon, 15 Nov 2021 17:52:24 +0100
Message-Id: <20211115165422.089078510@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit d9fd7e9fccfac466fb528a783f2fc76f2982604c ]

Fix following coccicheck warning:
./drivers/net/ethernet/microchip/sparx5/s4parx5_main.c:723:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before goto

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index f666133a15dea..6e9058265d43e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -743,6 +743,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 			err = dev_err_probe(sparx5->dev, PTR_ERR(serdes),
 					    "port %u: missing serdes\n",
 					    portno);
+			of_node_put(portnp);
 			goto cleanup_config;
 		}
 		config->portno = portno;
-- 
2.33.0



