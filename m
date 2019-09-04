Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C582A8B2A
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbfIDQCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733170AbfIDQCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5717A22DBF;
        Wed,  4 Sep 2019 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612926;
        bh=WoyyH/WhkP+nV+Xgh7izRnrD3GtpnV452JYFcLCroqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGjVky6fr7edf3L+cjTMs/R2JF8fytGhp53iHqpPOyKUMe10CpyLReJht5lk0Ucl9
         mBY2OrvL7kIcV9m0U2ifyD6OgeS2PsVxhKqeKQ6crayUxGSMkcdPWUkEdoSK9Qzo2o
         H+Qwk4l3CKq8qNLMxAyKdKPlUEtUUFOvoxluLYNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Krzysztof Adamski <krzysztof.adamski@nokia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/36] i2c: designware: Synchronize IRQs when unregistering slave client
Date:   Wed,  4 Sep 2019 12:01:14 -0400
Message-Id: <20190904160122.4179-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

