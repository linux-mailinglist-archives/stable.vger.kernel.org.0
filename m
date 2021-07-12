Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11F63C5525
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353618AbhGLIJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352891AbhGLIAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A521161A36;
        Mon, 12 Jul 2021 07:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076433;
        bh=/XH8VHetpeGGKDyF4zoCyzPHBVjcwLilhPt4VCDmUkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRGmWPcppoKfqJqjUCyFxS0V8SegdjEODLMhNz2oIvbiGmYpca0KQx3q3xFgGfRa7
         mcSlu5G+E3jF6PKkO7lm8h+4jSDESAcTjV4/M3fddLZm2IWXvmubUhiiMp1c2EzA/z
         JKTkIDkEfBxMxCMllucbrSv/jfBZXYuVn/N4Ucxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 640/800] backlight: lm3630a_bl: Put fwnode in error case during ->probe()
Date:   Mon, 12 Jul 2021 08:11:03 +0200
Message-Id: <20210712061035.192005277@linuxfoundation.org>
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

[ Upstream commit 6d1c32dbedd7d7e7372aa38033ec8782c39f6379 ]

device_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Cc: Brian Masney <masneyb@onstation.org>
Cc: Dan Murphy <dmurphy@ti.com>
Fixes: 8fbce8efe15cd ("backlight: lm3630a: Add firmware node support")
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Brian Masney <masneyb@onstation.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3630a_bl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index e88a2b0e5904..662029d6a3dc 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -482,8 +482,10 @@ static int lm3630a_parse_node(struct lm3630a_chip *pchip,
 
 	device_for_each_child_node(pchip->dev, node) {
 		ret = lm3630a_parse_bank(pdata, node, &seen_led_sources);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(node);
 			return ret;
+		}
 	}
 
 	return ret;
-- 
2.30.2



