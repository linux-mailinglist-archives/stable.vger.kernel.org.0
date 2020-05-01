Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D1D1C134D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgEAN2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgEAN23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:28:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF4D424953;
        Fri,  1 May 2020 13:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339709;
        bh=RTn+kV+lIHQIsGh0H3v5uQledyZ87fbiPFxJRLw6Yfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyEYSHRLNNuE1RGAeN+ni3dPbbYTvrtP0M6vmHypMHB7iExAEfEcVAwIm9bZMstxp
         9XORlbhYUjYzo6wd6ZWRnrH78YMFAR6bx5QBYd2jQ6g/7nAA9xLfs1UE7MZJkkZESp
         mra4/T/tyuRIWZ46jacntdKeYOKfGCSUIcBxiJKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/80] watchdog: reset last_hw_keepalive time at start
Date:   Fri,  1 May 2020 15:21:01 +0200
Message-Id: <20200501131515.244885263@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
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
index 977fe74e5abe2..9e17d933ea941 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -237,6 +237,7 @@ static int watchdog_start(struct watchdog_device *wdd)
 	if (err == 0) {
 		set_bit(WDOG_ACTIVE, &wdd->status);
 		wd_data->last_keepalive = started_at;
+		wd_data->last_hw_keepalive = started_at;
 		watchdog_update_worker(wdd);
 	}
 
-- 
2.20.1



