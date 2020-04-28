Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E197D1BCB9F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgD1S6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbgD1S3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:29:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DFAB20730;
        Tue, 28 Apr 2020 18:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098543;
        bh=e3Ix0CKQnO2vFrhw8s5qjaLhbJuDinvzEZLMlqEOCsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ak4nOytHKWYQyUfIygc+xSZ5r+RTxULAW7Tv1zRjktzLiii9qKvhmFNGXo9/K85VQ
         2kThyHmNhh0pprbZcj0OyjxY6c98dKsQr8SuXm4628wYOi8rBdu/p2m03QrKpU8BnZ
         9L83P1CF3oB8dTdWeVO8W5DYrmUMSAw051fD8MAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/131] watchdog: reset last_hw_keepalive time at start
Date:   Tue, 28 Apr 2020 20:23:43 +0200
Message-Id: <20200428182226.602808871@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit 982bb70517aef2225bad1d802887b733db492cc0 ]

Currently the watchdog core does not initialize the last_hw_keepalive
time during watchdog startup. This will cause the watchdog to be pinged
immediately if enough time has passed from the system boot-up time, and
some types of watchdogs like K3 RTI does not like this.

To avoid the issue, setup the last_hw_keepalive time during watchdog
startup.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200302200426.6492-3-t-kristo@ti.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index e64aa88e99dab..10b2090f3e5e7 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -264,6 +264,7 @@ static int watchdog_start(struct watchdog_device *wdd)
 	if (err == 0) {
 		set_bit(WDOG_ACTIVE, &wdd->status);
 		wd_data->last_keepalive = started_at;
+		wd_data->last_hw_keepalive = started_at;
 		watchdog_update_worker(wdd);
 	}
 
-- 
2.20.1



