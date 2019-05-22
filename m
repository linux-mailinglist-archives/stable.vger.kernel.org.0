Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24F326CA3
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbfEVTgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387394AbfEVTat (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:30:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FCAB20879;
        Wed, 22 May 2019 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553448;
        bh=XNkhpLjLvBtUXc50OWya9XnMmR58CeqoGxVIYpTTf4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBn28YaHeuDYkLCQf3P6g74HAFWse1IuYeA9J5M+h7ihPdF4fouPIP58Z2YY05HIT
         1fqE2SCYwsRw5X4m9QQfiwauxTHGMVHEko+4WF0f3aMw+K6wQ8iVJ3fmBFckW8clnX
         wU8eVMc/LM+Qy3G+W9zKeUfiF2VYmSee1BBPyd8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mariusz Bialonczyk <manio@skyboo.net>,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 018/114] w1: fix the resume command API
Date:   Wed, 22 May 2019 15:28:41 -0400
Message-Id: <20190522193017.26567-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mariusz Bialonczyk <manio@skyboo.net>

[ Upstream commit 62909da8aca048ecf9fbd7e484e5100608f40a63 ]

>From the DS2408 datasheet [1]:
"Resume Command function checks the status of the RC flag and, if it is set,
 directly transfers control to the control functions, similar to a Skip ROM
 command. The only way to set the RC flag is through successfully executing
 the Match ROM, Search ROM, Conditional Search ROM, or Overdrive-Match ROM
 command"

The function currently works perfectly fine in a multidrop bus, but when we
have only a single slave connected, then only a Skip ROM is used and Match
ROM is not called at all. This is leading to problems e.g. with single one
DS2408 connected, as the Resume Command is not working properly and the
device is responding with failing results after the Resume Command.

This commit is fixing this by using a Skip ROM instead in those cases.
The bandwidth / performance advantage is exactly the same.

Refs:
[1] https://datasheets.maximintegrated.com/en/ds/DS2408.pdf

Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
Reviewed-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index f4bc8c100a01b..a3ac582420ec4 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -437,8 +437,7 @@ int w1_reset_resume_command(struct w1_master *dev)
 	if (w1_reset_bus(dev))
 		return -1;
 
-	/* This will make only the last matched slave perform a skip ROM. */
-	w1_write_8(dev, W1_RESUME_CMD);
+	w1_write_8(dev, dev->slave_count > 1 ? W1_RESUME_CMD : W1_SKIP_ROM);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(w1_reset_resume_command);
-- 
2.20.1

