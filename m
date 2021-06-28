Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287F43B602C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhF1OWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233303AbhF1OV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF4C3619BE;
        Mon, 28 Jun 2021 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889964;
        bh=WY0OnpG93RgCN2GYAhlXJTBoSACnR0NInZ7LIzcwT1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggbtV1nhkNdOVAAc7ZMKBISSbp0is77DVJPDg4YEZGwXM1VYvmB9vkzP/aD4Fe0aB
         qgaUzk2KqrAmFj2bKDvjkSqYQUZi+yy8xKy7W8oc+/SgK7L+3wIh02rZO0nTsav3N9
         z1+qOq14g98moLzOJ4cLYXWTR/pZ2TALURYb/HPFhHzpa911eV2SBVtyrdCj8+LsOW
         46Ry3ADgg0DNE6svZY8QX40xQ7QC0OODmA1ndwLzL0AQd8wXdKxDxZRJof0kQTPfqz
         BMzPqa8VsIYpbSkO+eeUCnlfHipyQXwXztOB0T87bzS+2MSjEgYbGXGst99b5F3lmD
         jGQGWJKuAV21A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Knezek <gabeknez@linux.microsoft.com>,
        Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 065/110] gpiolib: cdev: zero padding during conversion to gpioline_info_changed
Date:   Mon, 28 Jun 2021 10:17:43 -0400
Message-Id: <20210628141828.31757-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 1631727bf0da..c7b5446d01fd 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1880,6 +1880,7 @@ static void gpio_v2_line_info_changed_to_v1(
 		struct gpio_v2_line_info_changed *lic_v2,
 		struct gpioline_info_changed *lic_v1)
 {
+	memset(lic_v1, 0, sizeof(*lic_v1));
 	gpio_v2_line_info_to_v1(&lic_v2->info, &lic_v1->info);
 	lic_v1->timestamp = lic_v2->timestamp_ns;
 	lic_v1->event_type = lic_v2->event_type;
-- 
2.30.2

