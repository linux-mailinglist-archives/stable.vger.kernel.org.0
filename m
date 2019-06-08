Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63DA39DC5
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbfFHLnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbfFHLnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:43:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED530214D8;
        Sat,  8 Jun 2019 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994220;
        bh=sP0qLwiA1DHhTCbZonhR0vtEr78HRuXSuI/65FYYT1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPJgUK+MOl+3b2TW6Alkk4T/CLjmAN9SZQ8awzGhJDRuOBjGjrOj/0GBGq+JUcatg
         v0broGRw13caA5ZSmu02xdOZoQkXI1p2V2CkoJU5F6RNlk/hEo4wyt0GEBte92jsNT
         mDgVvJLnAaQGg5DHNWJzBxZZqm9T2lQOK42CKJO0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/49] i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr
Date:   Sat,  8 Jun 2019 07:42:07 -0400
Message-Id: <20190608114232.8731-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yingjoe Chen <yingjoe.chen@mediatek.com>

[ Upstream commit a0692f0eef91354b62c2b4c94954536536be5425 ]

If I2C_M_RECV_LEN check failed, msgs[i].buf allocated by memdup_user
will not be freed. Pump index up so it will be freed.

Fixes: 838bfa6049fb ("i2c-dev: Add support for I2C_M_RECV_LEN")
Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index ccd76c71af09..cb07651f4b46 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -283,6 +283,7 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 			    msgs[i].len < 1 || msgs[i].buf[0] < 1 ||
 			    msgs[i].len < msgs[i].buf[0] +
 					     I2C_SMBUS_BLOCK_MAX) {
+				i++;
 				res = -EINVAL;
 				break;
 			}
-- 
2.20.1

