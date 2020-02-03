Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBD7150CE7
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgBCQge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgBCQgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:32 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1197C20721;
        Mon,  3 Feb 2020 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747792;
        bh=ttOpHtv7xndE090OhbMhp/CLgVcdCcJfkXoIqd/I0e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPt7WOGfywNBjiXKi6a23W5kZbOhIZMjauNkY5Xd8xyc/c4SjTWDBXFSkWHT5+CnG
         hHuXtx+GjfwQ6OxH9LjswOQbd8bhRTFB/QVt16JEZ6Kt95qMZuz8GEVzTSm+XOKJvg
         250XUEez6gPidOO4730qQb2bMX9WFpyEMgoKEQlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 73/90] led: max77650: add of_match table
Date:   Mon,  3 Feb 2020 16:20:16 +0000
Message-Id: <20200203161926.266715392@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 2424415d25a765d4302ddfb4de75427e9294dc09 ]

We need the of_match table if we want to use the compatible string in
the pmic's child node and get the led driver loaded automatically.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-max77650.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/leds/leds-max77650.c b/drivers/leds/leds-max77650.c
index 4c2d0b3c6dadc..a0d4b725c9178 100644
--- a/drivers/leds/leds-max77650.c
+++ b/drivers/leds/leds-max77650.c
@@ -135,9 +135,16 @@ static int max77650_led_probe(struct platform_device *pdev)
 	return rv;
 }
 
+static const struct of_device_id max77650_led_of_match[] = {
+	{ .compatible = "maxim,max77650-led" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, max77650_led_of_match);
+
 static struct platform_driver max77650_led_driver = {
 	.driver = {
 		.name = "max77650-led",
+		.of_match_table = max77650_led_of_match,
 	},
 	.probe = max77650_led_probe,
 };
-- 
2.20.1



