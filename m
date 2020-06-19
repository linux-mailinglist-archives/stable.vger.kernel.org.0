Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97652015C0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390154AbgFSO4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390143AbgFSO4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:56:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 732882193E;
        Fri, 19 Jun 2020 14:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578612;
        bh=eBjUfeB8mo2ipYhlT9r1QU8k3Cxn/HX8rykQMP0iTnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0BYvJq4PKy7jO/2bp+we+W48+U3qEcz8rNEeqboBPPHAL8tpNjFACFZGCIxZoN6y
         HZyb0FteI2dYwlWFO05oqeI0RJU+eY+Rv0TLrn5aITgIQ0bHMJ5/QRAdyjVSTxbFMR
         9LkdmMJLBF0OtzHQUL5OCbYnmsUDDGL4cuiARWB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/267] spi: No need to assign dummy value in spi_unregister_controller()
Date:   Fri, 19 Jun 2020 16:30:43 +0200
Message-Id: <20200619141651.658299249@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ebc37af5e0a134355ea2b62ed4141458bdbd5389 ]

The device_for_each_child() doesn't require the returned value to be checked.
Thus, drop the dummy variable completely and have no warning anymore:

drivers/spi/spi.c: In function ‘spi_unregister_controller’:
drivers/spi/spi.c:2480:6: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
  int dummy;
      ^~~~~

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 88a8a8edd44b..0022a49797f9 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2305,7 +2305,6 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 {
 	struct spi_controller *found;
 	int id = ctlr->bus_num;
-	int dummy;
 
 	/* First make sure that this controller was ever added */
 	mutex_lock(&board_lock);
@@ -2319,7 +2318,7 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 	list_del(&ctlr->list);
 	mutex_unlock(&board_lock);
 
-	dummy = device_for_each_child(&ctlr->dev, NULL, __unregister);
+	device_for_each_child(&ctlr->dev, NULL, __unregister);
 	device_unregister(&ctlr->dev);
 	/* free bus id */
 	mutex_lock(&board_lock);
-- 
2.25.1



