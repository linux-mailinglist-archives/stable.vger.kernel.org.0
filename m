Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41AEE1454F7
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAVNRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgAVNRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:17:45 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15142205F4;
        Wed, 22 Jan 2020 13:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699064;
        bh=FWd7oeVOdPHJWI+flJGUGq8dp/t9StvJT23VskqObt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ftPX4mk1fmB2KMZdImDdDH52ISWgmbIBaQTs631KSgXTbx9oeuCy2FbeWjhhqjti
         iVQt4h25nGkkFJeIFwRaEgEqN+9Egxd1FTpiX4cUtnHmZamnlxyWAwLmmwzDyRGKR7
         6Yd+Qxk+7+tauh8vI1NlmhtxUYcM3nGZm1u565KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.4 030/222] clk: sunxi-ng: r40: Allow setting parent rate for external clock outputs
Date:   Wed, 22 Jan 2020 10:26:56 +0100
Message-Id: <20200122092835.626065575@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit c7b305267eb77fe47498676e9337324c9653494c upstream.

One of the uses of the external clock outputs is to provide a stable
32768 Hz clock signal to WiFi and Bluetooth chips. On the R40, the RTC
has an internal RC oscillator that is muxed with the external crystal.

Allow setting the parent rate for the external clock outputs so that
requests for 32768 Hz get passed to the RTC's clock driver to mux in
the external crystal if it isn't already muxed correctly.

Fixes: cd030a78f7aa ("clk: sunxi-ng: support R40 SoC")
Fixes: 01a7ea763fc4 ("clk: sunxi-ng: r40: Force LOSC parent to RTC LOSC output")
Cc: <stable@kernel.org>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/sunxi-ng/ccu-sun8i-r40.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/clk/sunxi-ng/ccu-sun8i-r40.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-r40.c
@@ -761,7 +761,8 @@ static struct ccu_mp outa_clk = {
 		.reg		= 0x1f0,
 		.features	= CCU_FEATURE_FIXED_PREDIV,
 		.hw.init	= CLK_HW_INIT_PARENTS("outa", out_parents,
-						      &ccu_mp_ops, 0),
+						      &ccu_mp_ops,
+						      CLK_SET_RATE_PARENT),
 	}
 };
 
@@ -779,7 +780,8 @@ static struct ccu_mp outb_clk = {
 		.reg		= 0x1f4,
 		.features	= CCU_FEATURE_FIXED_PREDIV,
 		.hw.init	= CLK_HW_INIT_PARENTS("outb", out_parents,
-						      &ccu_mp_ops, 0),
+						      &ccu_mp_ops,
+						      CLK_SET_RATE_PARENT),
 	}
 };
 


