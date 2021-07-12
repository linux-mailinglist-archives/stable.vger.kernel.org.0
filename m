Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25363C4B46
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbhGLG4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239215AbhGLGtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 148526100B;
        Mon, 12 Jul 2021 06:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072404;
        bh=YOPLVcZnnOKUJg1NdL6BnZZfpR6zeOBOKoBiUW5o/Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GC3AsPjDfgUouJW3dc/ZuYOlI85dMHwsXsS/+pasxDEtBigC0gI2Mw69l1KcX/omV
         AkI/SSuzcFBgIWpDpWXelpHQhl8WzM1ey6dF00JWWjOzn3bUEtaqVnY/C7ke9nKn6D
         W8Q6+FSikS6oDG0jL1oJuqgJyeD8i67+YCoPdHRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/593] leds: lp50xx: Put fwnode in error case during ->probe()
Date:   Mon, 12 Jul 2021 08:10:44 +0200
Message-Id: <20210712060944.127673715@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index f13117eed976..d4529082935b 100644
--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -496,6 +496,7 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 			ret = fwnode_property_read_u32(led_node, "color",
 						       &color_id);
 			if (ret) {
+				fwnode_handle_put(led_node);
 				dev_err(priv->dev, "Cannot read color\n");
 				goto child_out;
 			}
@@ -519,7 +520,6 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 			goto child_out;
 		}
 		i++;
-		fwnode_handle_put(child);
 	}
 
 	return 0;
-- 
2.30.2



