Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED58450CCA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbhKORnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238530AbhKORlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3BD0632ED;
        Mon, 15 Nov 2021 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997223;
        bh=hluf1lhAZxa2HGKmCxKsmPzSF81QUgVz22aWRQIcOvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4e8nZO+EsSrK86zJiQfYUwkioxZb4XkwMnll4vvFjGwhfkNSrH3uPC1c9C+wVmer
         CJLaQcL5B/TckRBkZPIMg6SBoMHptmlIhxWR8KJQOqkGe4agsmAZhwt4yCfwhN44BV
         mAOroxto/2FBDv/sLbVqwzYOqY8BCihqsikYzpDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asmaa Mnebhi <asmaa@nvidia.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/575] gpio: mlxbf2.c: Add check for bgpio_init failure
Date:   Mon, 15 Nov 2021 17:56:33 +0100
Message-Id: <20211115165345.996606917@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit c0eee6fbfa2b3377f1efed10dad539abeb7312aa ]

Add a check if bgpio_init fails.

Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index befa5e1099439..d4b250b470b41 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -268,6 +268,11 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
 			NULL,
 			0);
 
+	if (ret) {
+		dev_err(dev, "bgpio_init failed\n");
+		return ret;
+	}
+
 	gc->direction_input = mlxbf2_gpio_direction_input;
 	gc->direction_output = mlxbf2_gpio_direction_output;
 	gc->ngpio = npins;
-- 
2.33.0



