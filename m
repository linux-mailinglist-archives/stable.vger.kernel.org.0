Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A99D1D8260
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbgERRzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730045AbgERRzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B8620674;
        Mon, 18 May 2020 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824552;
        bh=K7jZZPVMfrBt271YsEJAtDJW9/HOKk7msYrUtYwBtAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ur7c1fbH4pu93ffyyme8cmhAi24DW0kr632wrrKqmaV/jPjqfD2tYQNQPNy5BgDEY
         yR+hxH/8EyY16LRTXC9BQXpW+tourQAgAO7iTIZiEldgw0EluAqPs/L4JXO6g6GCvz
         TlYgFRiBEJMTLTLlEtQ49unCQQn9LOR29qnWIVis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/147] pinctrl: baytrail: Enable pin configuration setting for GPIO chip
Date:   Mon, 18 May 2020 19:36:20 +0200
Message-Id: <20200518173521.070679231@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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
index 606fe216f902a..cae7caf5ab282 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -1297,6 +1297,7 @@ static const struct gpio_chip byt_gpio_chip = {
 	.direction_output	= byt_gpio_direction_output,
 	.get			= byt_gpio_get,
 	.set			= byt_gpio_set,
+	.set_config		= gpiochip_generic_config,
 	.dbg_show		= byt_gpio_dbg_show,
 };
 
-- 
2.20.1



