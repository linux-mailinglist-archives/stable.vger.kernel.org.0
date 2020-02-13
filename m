Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830BE15C318
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387711AbgBMP1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387707AbgBMP1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:49 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE3242465D;
        Thu, 13 Feb 2020 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607668;
        bh=K5GDi/oMQ+ieE+yMPPxgcSW5Fm1FmbEPK4ciFjOj3p8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJuWGcI/jYvQMEyJheS6W8AvwFqRePN/F2Hd8bmW94x5nZ1mZq4MIppDqqtcISj3C
         bgnQiAhRjzN5N4p4Qr/8HiHAO13L7LYgop/j8Won0nrSRV8xGavK8lh4o77BEP0IBT
         0joGkkcI9ynBBSMLZe8TM9Y92zWo7Rwztk0PJga4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 5.4 91/96] clk: meson: g12a: fix missing uart2 in regmap table
Date:   Thu, 13 Feb 2020 07:21:38 -0800
Message-Id: <20200213151913.033876186@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit b1b3f0622a9d52ac19a63619911823c89a4d85a4 upstream.

UART2 peripheral is missing from the regmap fixup table of the g12a family
clock controller. As it is, any access to this clock would Oops, which is
not great.

Add the clock to the table to fix the problem.

Fixes: 085a4ea93d54 ("clk: meson: g12a: add peripheral clock controller")
Reported-by: Dmitry Shmidt <dimitrysh@google.com>
Tested-by: Dmitry Shmidt <dimitrysh@google.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/meson/g12a.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -4692,6 +4692,7 @@ static struct clk_regmap *const g12a_clk
 	&g12a_bt656,
 	&g12a_usb1_to_ddr,
 	&g12a_mmc_pclk,
+	&g12a_uart2,
 	&g12a_vpu_intr,
 	&g12a_gic,
 	&g12a_sd_emmc_a_clk0,


