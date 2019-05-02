Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331D311D7F
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfEBPbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbfEBPbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B07820C01;
        Thu,  2 May 2019 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811066;
        bh=iMJvmuREUSOV9dkIFK+GQdhws+68M5+NrRRDFWHfCK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T75cVN/aLcAna1RSTAubZAK1+7antRjmujG/MOArOZtG8q0NWsRtI7MGn1SOiBpGH
         cDTiiceIQQ84tqyfdsGHn5DllitC2eMcOnZURjvrFs+TtLSWVa7vybqu77nIg7Kix5
         dYOmP9Opq3U+St7EBJN8sQ6ASu4vU0gzPpjEQXyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Andrew Jeffery <andrew@aj.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 060/101] gpio: aspeed: fix a potential NULL pointer dereference
Date:   Thu,  2 May 2019 17:21:02 +0200
Message-Id: <20190502143343.704810235@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6cf4511e9729c00a7306cf94085f9cc3c52ee723 ]

In case devm_kzalloc, the patch returns ENOMEM to avoid potential
NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index 854bce4fb9e7..217507002dbc 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1224,6 +1224,8 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 
 	gpio->offset_timer =
 		devm_kzalloc(&pdev->dev, gpio->chip.ngpio, GFP_KERNEL);
+	if (!gpio->offset_timer)
+		return -ENOMEM;
 
 	return aspeed_gpio_setup_irqs(gpio, pdev);
 }
-- 
2.19.1



