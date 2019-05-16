Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E2620507
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfEPLk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbfEPLkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:40:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F94216F4;
        Thu, 16 May 2019 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006822;
        bh=PXifvUHuuQK85JMTllo051teFNdbF1ONRuJwNs8C5bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXfuqfmamnjARqxFxA6wUg5uszLFM2FYm5K/Oh2qt/w+uyKZT35TGf6aQP3sVSS3h
         UUz9sr0H6vNEeekt4JJtyHcBYqCWiJ2EFirYG98R0HYd2zgSFocTKYx0AQUaLtIn8r
         g5nJG61yT/s4LQ2dSFH/PGj0hfuJ0VHkIgBMT7gU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        skidnik <skidnik@gmail.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 31/34] i2c: designware: ratelimit 'transfer when suspended' errors
Date:   Thu, 16 May 2019 07:39:28 -0400
Message-Id: <20190516113932.8348-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 6bac9bc273cdab6157ad7a2ead09400aabfc445b ]

There are two problems with dev_err() here. One: It is not ratelimited.
Two: We don't see which driver tried to transfer something with a
suspended adapter. Switch to dev_WARN_ONCE to fix both issues. Drawback
is that we don't see if multiple drivers are trying to transfer while
suspended. They need to be discovered one after the other now. This is
better than a high CPU load because a really broken driver might try to
resend endlessly.

Link: https://bugs.archlinux.org/task/62391
Fixes: 275154155538 ("i2c: designware: Do not allow i2c_dw_xfer() calls while suspended")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reported-by: skidnik <skidnik@gmail.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: skidnik <skidnik@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-master.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index bb8e3f1499796..d464799e40a30 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -426,8 +426,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 
 	pm_runtime_get_sync(dev->dev);
 
-	if (dev->suspended) {
-		dev_err(dev->dev, "Error %s call while suspended\n", __func__);
+	if (dev_WARN_ONCE(dev->dev, dev->suspended, "Transfer while suspended\n")) {
 		ret = -ESHUTDOWN;
 		goto done_nolock;
 	}
-- 
2.20.1

