Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7657A3C5576
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGLIK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353666AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C54361CF4;
        Mon, 12 Jul 2021 07:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076575;
        bh=dkebn8beVt2hG4JsRPfs3GMgsno86/jY+cJ4qjOL/mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ECZjr0QPp9H2tHVmIdLBWDBgu94ziPFAKWoC8qWIZjEmpR11N9XVCC44ujngsoOg
         3XeR+EO++b4t8Jbc+56sK+7z8lOigQ/xZ92fUL+T+oow7HvjfjesB81YyDuIP8iObc
         YL5DIdA2lp5KO3OSsdQVgJYGkGizf1z1fah02rrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 660/800] leds: lp50xx: Put fwnode in error case during ->probe()
Date:   Mon, 12 Jul 2021 08:11:23 +0200
Message-Id: <20210712061037.166133273@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit f1e1d532da7e6ef355528a22fb97d9a8fbf76c4e ]

fwnode_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

OTOH, the successful iteration will drop reference count under the hood, no need
to do it twice.

Fixes: 242b81170fb8 ("leds: lp50xx: Add the LP50XX family of the RGB LED driver")
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp50xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp50xx.c b/drivers/leds/leds-lp50xx.c
index 06230614fdc5..401df1e2e05d 100644
--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -490,6 +490,7 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 			ret = fwnode_property_read_u32(led_node, "color",
 						       &color_id);
 			if (ret) {
+				fwnode_handle_put(led_node);
 				dev_err(priv->dev, "Cannot read color\n");
 				goto child_out;
 			}
@@ -512,7 +513,6 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 			goto child_out;
 		}
 		i++;
-		fwnode_handle_put(child);
 	}
 
 	return 0;
-- 
2.30.2



