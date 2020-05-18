Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30201D8648
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgERRsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbgERRsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134DA207C4;
        Mon, 18 May 2020 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824082;
        bh=wUVPPEjiIhHY7brZale1h2jyk+zGoCYkcSBldVnpos4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTqKJ6xNo5AiIHClwIxU6aVHCL2HTuX71tP8FXcR8XDHMa5f6BDP4kZYTTlqcIeMk
         Z12zbJ8W7X6jzjN2h1+uck5t1+lTa9s84tkh5oxpwCLCvU9iuk9fUJAMMyfUxE44Qf
         kZbY/P9hG1mullGhrUx34FgjKJL0raI2h9CYHLDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 064/114] pinctrl: baytrail: Enable pin configuration setting for GPIO chip
Date:   Mon, 18 May 2020 19:36:36 +0200
Message-Id: <20200518173514.693315129@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ccd025eaddaeb99e982029446197c544252108e2 ]

It appears that pin configuration for GPIO chip hasn't been enabled yet
due to absence of ->set_config() callback.

Enable it here for Intel Baytrail.

Fixes: c501d0b149de ("pinctrl: baytrail: Add pin control operations")
Depends-on: 2956b5d94a76 ("pinctrl / gpio: Introduce .set_config() callback for GPIO chips")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 4fb3e44f91331..2ea4bb9ce6e16 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -1503,6 +1503,7 @@ static const struct gpio_chip byt_gpio_chip = {
 	.direction_output	= byt_gpio_direction_output,
 	.get			= byt_gpio_get,
 	.set			= byt_gpio_set,
+	.set_config		= gpiochip_generic_config,
 	.dbg_show		= byt_gpio_dbg_show,
 };
 
-- 
2.20.1



