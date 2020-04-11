Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28A11A58DB
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgDKXct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbgDKXJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF623215A4;
        Sat, 11 Apr 2020 23:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646597;
        bh=z9rtLhZlzhiOGVZoMMk3LzerzSTwqB0GfVjTvbMw2gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOXh0legb/7gX3v3+VUqtVMEvjOLTXzh884Tfou0vXXbWU2X0gwZfgh6ZbsE733/w
         /3l5Hhtn0r4UiHwRbKoG+kQrNWd5z5Fk+E51ECRcZNTrFXCZW4S9LEpPbUrds2QhUt
         mZdNsJevaziFu82amsH1ZsDdEKVIQDeoBmlsRp+w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonid Maksymchuk <leonmaxx@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 011/108] platform/x86: asus_wmi: Fix return value of fan_boost_mode_store
Date:   Sat, 11 Apr 2020 19:08:06 -0400
Message-Id: <20200411230943.24951-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonid Maksymchuk <leonmaxx@gmail.com>

[ Upstream commit edeee341fd6c1099de357c517af215bee2c6f766 ]

Function fan_boost_mode_store returns 0 if store is successful,
this leads to infinite loop after any write to it's sysfs entry:

# echo 0 >/sys/devices/platform/asus-nb-wmi/fan_boost_mode

This command never ends, one CPU core is at 100% utilization.
This patch fixes this by returning size of written data.

Fixes: b096f626a682 ("platform/x86: asus-wmi: Switch fan boost mode")
Signed-off-by: Leonid Maksymchuk <leonmaxx@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 982f0cc8270ce..977b813cc0fa9 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1712,7 +1712,7 @@ static ssize_t fan_boost_mode_store(struct device *dev,
 	asus->fan_boost_mode = new_mode;
 	fan_boost_mode_write(asus);
 
-	return result;
+	return count;
 }
 
 // Fan boost mode: 0 - normal, 1 - overboost, 2 - silent
-- 
2.20.1

