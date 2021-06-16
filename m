Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93993A9FC6
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhFPPlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234912AbhFPPji (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59EF061356;
        Wed, 16 Jun 2021 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857815;
        bh=GhkXtGXIL0fNxS3zp4DWV6PenphHRFaLCBus3LYh8hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBbZaI4r8DVeTZqti6HqD4G/qDtJnAUAqaLrtMzrreU7Xw96EXgUs1bNPDlSJBi9Z
         4wyzM9vrjAg5daxibihN228T7pBNxItzrK6jV9evqltIQQhJLLnX12RZOZNXw9r4H2
         o5BdGKeJXexqlqtSU0w1ur05DUlcwDnYaNDHgUK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chu Lin <linchuyuan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 17/48] hwmon/pmbus: (q54sj108a2) The PMBUS_MFR_ID is actually 6 chars instead of 5
Date:   Wed, 16 Jun 2021 17:33:27 +0200
Message-Id: <20210616152837.197474947@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chu Lin <linchuyuan@google.com>

[ Upstream commit f0fb26c456a30d6009faa2c9d44aa22f5bf88c90 ]

The PMBUS_MFR_ID block is actually 6 chars for q54sj108a2.
/sys/bus/i2c/drivers/q54sj108a2_test# iotools smbus_read8 $BUS $ADDR 0x99
0x06

Tested: Devices are able to bind to the q54sj108a2 driver successfully.

Signed-off-by: Chu Lin <linchuyuan@google.com>
Link: https://lore.kernel.org/r/20210517222606.3457594-1-linchuyuan@google.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/q54sj108a2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/q54sj108a2.c b/drivers/hwmon/pmbus/q54sj108a2.c
index aec512766c31..0976268b2670 100644
--- a/drivers/hwmon/pmbus/q54sj108a2.c
+++ b/drivers/hwmon/pmbus/q54sj108a2.c
@@ -299,7 +299,7 @@ static int q54sj108a2_probe(struct i2c_client *client)
 		dev_err(&client->dev, "Failed to read Manufacturer ID\n");
 		return ret;
 	}
-	if (ret != 5 || strncmp(buf, "DELTA", 5)) {
+	if (ret != 6 || strncmp(buf, "DELTA", 5)) {
 		buf[ret] = '\0';
 		dev_err(dev, "Unsupported Manufacturer ID '%s'\n", buf);
 		return -ENODEV;
-- 
2.30.2



