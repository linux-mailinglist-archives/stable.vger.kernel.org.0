Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F35D3B611E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhF1Ocm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234916AbhF1Oal (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E443661CC7;
        Mon, 28 Jun 2021 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890419;
        bh=Lwc4OapAykM3XWAJgQm9V+jdO+9llh9RAZpuM6Jm6yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miw2dsn9+nl8sL5YwHDlE00LW66rs7jnyRAVNAXUqNOlz2Cc4M6Ro4yoocCXTZrBT
         ++UdEciKW8wTMx0/+Fh90+xWOfRuFdaFWMHPFVmRFteW9ERQfeJ1IyW8WpOwAG2ldD
         Q/Vlkt0iJClwRCIaRGdkS+mQ9WKC31gaGv3JetzzYMsd+kuFSmZiM9MoMmL1W5xVpH
         3bUYXFwbWdtx0blzYYv5LB74DG3sC+eHWppPoszLFnnrHH0XsiHQFtkgTcys/IVgYS
         2wpAf230zcAUMd2MlbIrzXozKkteuTAwd2O9b+eYzIWBd0fy6TmrTORtn15k88ahxq
         ucQ5IA6/mfPXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Knezek <gabeknez@linux.microsoft.com>,
        Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/101] gpiolib: cdev: zero padding during conversion to gpioline_info_changed
Date:   Mon, 28 Jun 2021 10:25:26 -0400
Message-Id: <20210628142607.32218-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Knezek <gabeknez@linux.microsoft.com>

[ Upstream commit cb8f63b8cbf39845244f3ccae43bb7e63bd70543 ]

When userspace requests a GPIO v1 line info changed event,
lineinfo_watch_read() populates and returns the gpioline_info_changed
structure. It contains 5 words of padding at the end which are not
initialized before being returned to userspace.

Zero the structure in gpio_v2_line_info_change_to_v1() before populating
its contents.

Fixes: aad955842d1c ("gpiolib: cdev: support GPIO_V2_GET_LINEINFO_IOCTL and GPIO_V2_GET_LINEINFO_WATCH_IOCTL")
Signed-off-by: Gabriel Knezek <gabeknez@linux.microsoft.com>
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index ade3ecf2ee49..2613881a66e6 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1865,6 +1865,7 @@ static void gpio_v2_line_info_changed_to_v1(
 		struct gpio_v2_line_info_changed *lic_v2,
 		struct gpioline_info_changed *lic_v1)
 {
+	memset(lic_v1, 0, sizeof(*lic_v1));
 	gpio_v2_line_info_to_v1(&lic_v2->info, &lic_v1->info);
 	lic_v1->timestamp = lic_v2->timestamp_ns;
 	lic_v1->event_type = lic_v2->event_type;
-- 
2.30.2

