Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8CD450F0F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbhKOSZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:25:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241660AbhKOSYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA42061B3D;
        Mon, 15 Nov 2021 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998838;
        bh=hluf1lhAZxa2HGKmCxKsmPzSF81QUgVz22aWRQIcOvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJHEoAhpKx7Y32RBOvY7wbs7mfTTbU+e1qOfyqBARPNGI3m3kAGPiwNZrJHahXpja
         plh8C8bJv37Vgc6+f1vXaIgEGu7e3fS25LBcxF46f27hXT32rguEHEgn0bcDzwFFE3
         RvUckea3f0ogZgEd67ZFALugmQh/i6DVIhpfaOYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asmaa Mnebhi <asmaa@nvidia.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 081/849] gpio: mlxbf2.c: Add check for bgpio_init failure
Date:   Mon, 15 Nov 2021 17:52:44 +0100
Message-Id: <20211115165422.796303989@linuxfoundation.org>
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



