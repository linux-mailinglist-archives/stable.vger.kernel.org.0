Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FAFB8657
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393858AbfISWSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389941AbfISWSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:18:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE04D20678;
        Thu, 19 Sep 2019 22:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931488;
        bh=WoyyH/WhkP+nV+Xgh7izRnrD3GtpnV452JYFcLCroqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/Is3bBe/wCXfwN+QIPQPyyWZ2xHxZiC1RLOfpA2v8XBAIGGLCEUUyT2avZg7WKFw
         tueguEZsFmiuJ4R1bkFkbUkTrjcyJ4uMD8aBDBG/Xmn0icZGzCZi0s5WSesH4f1q4N
         56bbTwoU9BLN12CQZnoLvLI0b1fh1RtDqInu8/tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Adamski <krzysztof.adamski@nokia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/59] i2c: designware: Synchronize IRQs when unregistering slave client
Date:   Fri, 20 Sep 2019 00:03:54 +0200
Message-Id: <20190919214806.776792993@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit c486dcd2f1bbdd524a1e0149734b79e4ae329650 ]

Make sure interrupt handler i2c_dw_irq_handler_slave() has finished
before clearing the the dev->slave pointer in i2c_dw_unreg_slave().

There is possibility for a race if i2c_dw_irq_handler_slave() is running
on another CPU while clearing the dev->slave pointer.

Reported-by: Krzysztof Adamski <krzysztof.adamski@nokia.com>
Reported-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-slave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-designware-slave.c b/drivers/i2c/busses/i2c-designware-slave.c
index ea9578ab19a15..fccf936f4b9b5 100644
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -206,6 +206,7 @@ static int i2c_dw_unreg_slave(struct i2c_client *slave)
 
 	dev->disable_int(dev);
 	dev->disable(dev);
+	synchronize_irq(dev->irq);
 	dev->slave = NULL;
 	pm_runtime_put(dev->dev);
 
-- 
2.20.1



