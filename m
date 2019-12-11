Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED7711AEB8
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfLKPHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730010AbfLKPHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DF4B20663;
        Wed, 11 Dec 2019 15:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076858;
        bh=LKxzpUfyF+oYSQX+FKuJTBK46/nO+5dzYVqWq0NnofU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbP8AwfAjPxu/DGbMEvlz+0xgga6ge+hui840zxyHN2pcjA6BQ/rVIE0whCRUmpkZ
         xcrV1gJ5pIFjaFqP32U0J1nZiRZCwVkl8fogWblXo0LdP6LI1rQdywNxJsAsEGCrlo
         3QeMwCymzKkWzk8nNWa45oHvyIvomQ/n4++U6Dw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 5.4 18/92] serial: ifx6x60: add missed pm_runtime_disable
Date:   Wed, 11 Dec 2019 16:05:09 +0100
Message-Id: <20191211150226.990625436@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 50b2b571c5f3df721fc81bf9a12c521dfbe019ba upstream.

The driver forgets to call pm_runtime_disable in remove.
Add the missed calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191118024833.21587-1-hslester96@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/ifx6x60.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -1230,6 +1230,9 @@ static int ifx_spi_spi_remove(struct spi
 	struct ifx_spi_device *ifx_dev = spi_get_drvdata(spi);
 	/* stop activity */
 	tasklet_kill(&ifx_dev->io_work_tasklet);
+
+	pm_runtime_disable(&spi->dev);
+
 	/* free irq */
 	free_irq(gpio_to_irq(ifx_dev->gpio.reset_out), ifx_dev);
 	free_irq(gpio_to_irq(ifx_dev->gpio.srdy), ifx_dev);


