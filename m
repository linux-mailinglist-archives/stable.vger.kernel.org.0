Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF95201853
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbgFSOg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387524AbgFSOgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:36:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C3B208B8;
        Fri, 19 Jun 2020 14:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577383;
        bh=kQbqdj8REMwrIl4FmTaEqGjxQ70zFvb4uKvsRKKwsZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOsvRTpiOAt67bMeWyn5aaPIHsmfGdknbQy9fVhB2dGiWMlLkfC96L7Xmh3smscow
         dUI9Vy7VjNZFeNUg1ySPISdSedbKxxn4bcZMoInFyDElrisB3ZvH8dIgYnYHAxPv08
         yMC2TwHmOSWylZyV+J4UeNgYdsFdaLesW0N5opWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 028/101] spi: No need to assign dummy value in spi_unregister_controller()
Date:   Fri, 19 Jun 2020 16:32:17 +0200
Message-Id: <20200619141615.556571212@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
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
 drivers/spi/spi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c132c676df3a..e5460d84ed08 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1917,8 +1917,6 @@ static int __unregister(struct device *dev, void *null)
  */
 void spi_unregister_master(struct spi_master *master)
 {
-	int dummy;
-
 	if (master->queued) {
 		if (spi_destroy_queue(master))
 			dev_err(&master->dev, "queue remove failed\n");
@@ -1928,7 +1926,7 @@ void spi_unregister_master(struct spi_master *master)
 	list_del(&master->list);
 	mutex_unlock(&board_lock);
 
-	dummy = device_for_each_child(&master->dev, NULL, __unregister);
+	device_for_each_child(&master->dev, NULL, __unregister);
 	device_unregister(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
-- 
2.25.1



