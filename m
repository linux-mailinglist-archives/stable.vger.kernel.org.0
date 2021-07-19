Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95E23CDF0F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbhGSPHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345814AbhGSPFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A83E2601FD;
        Mon, 19 Jul 2021 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709541;
        bh=bbVd+2bxpCaXUxcAOnOAX0hB/3BAyItTF/C8oJeB/XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEwAfciXicvI1McHW1yNM1j0nwNmm7hR+IQ02wXOzjjmxTukEY4CGY6gVs32cRMrG
         cKDalVp6LVawPXYBCLdwUGOBaqL7R5BahPchu03r3uIrIdXt9mQDM0CNMS/PfQzhO0
         j1VwnsVWLzE/rVbW51vXF51fBa+Em9yvTVT5f75M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 402/421] rtc: fix snprintf() checking in is_rtc_hctosys()
Date:   Mon, 19 Jul 2021 16:53:33 +0200
Message-Id: <20210719145000.282930642@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 54b909436ede47e0ee07f1765da27ec2efa41e84 ]

The scnprintf() function silently truncates the printf() and returns
the number bytes that it was able to copy (not counting the NUL
terminator).  Thus, the highest value it can return here is
"NAME_SIZE - 1" and the overflow check is dead code.  Fix this by
using the snprintf() function which returns the number of bytes that
would have been copied if there was enough space and changing the
condition from "> NAME_SIZE" to ">= NAME_SIZE".

Fixes: 92589c986b33 ("rtc-proc: permit the /proc/driver/rtc device to use other devices")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/YJov/pcGmhLi2pEl@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index a9dd9218fae2..b8c5b93102ce 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -26,8 +26,8 @@ static bool is_rtc_hctosys(struct rtc_device *rtc)
 	int size;
 	char name[NAME_SIZE];
 
-	size = scnprintf(name, NAME_SIZE, "rtc%d", rtc->id);
-	if (size > NAME_SIZE)
+	size = snprintf(name, NAME_SIZE, "rtc%d", rtc->id);
+	if (size >= NAME_SIZE)
 		return false;
 
 	return !strncmp(name, CONFIG_RTC_HCTOSYS_DEVICE, NAME_SIZE);
-- 
2.30.2



