Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3240729C2E0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821142AbgJ0Rkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760136AbgJ0Ode (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7089A20709;
        Tue, 27 Oct 2020 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809214;
        bh=nEy3KQc75AODhb3w+D7cEiRV0ucGu6iMc/bQjzlVVto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFOsGQRIx1fJIW4nLWNTmbif1JzCf24VLN76wB9lA9gPHhwnTPUvGfD/wzrx69VsC
         WJQAOVmZ7bVUFSaRNyf8UlrinKzGUWtdWoDfD1asacQzmV0PglbQ5HDv81p6Apr3S9
         N60lYsU+YkBScHHyoVuZMi7VR4BaJZolHPfZ1Hqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Foreman <foremans@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/408] hwmon: (pmbus/max34440) Fix status register reads for MAX344{51,60,61}
Date:   Tue, 27 Oct 2020 14:50:24 +0100
Message-Id: <20201027135459.061686852@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 6c094b31ea2ad773824362ba0fccb88d36f8d32d ]

Starting with MAX34451, the chips of this series support STATUS_IOUT and
STATUS_TEMPERATURE commands, and no longer report over-current and
over-temperature status with STATUS_MFR_SPECIFIC.

Fixes: 7a001dbab4ade ("hwmon: (pmbus/max34440) Add support for MAX34451.")
Fixes: 50115ac9b6f35 ("hwmon: (pmbus/max34440) Add support for MAX34460 and MAX34461")
Reported-by: Steve Foreman <foremans@google.com>
Cc: Steve Foreman <foremans@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/max34440.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/max34440.c b/drivers/hwmon/pmbus/max34440.c
index 5c63a66007293..e22617def70bf 100644
--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -387,7 +387,6 @@ static struct pmbus_driver_info max34440_info[] = {
 		.func[18] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[19] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[20] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
-		.read_byte_data = max34440_read_byte_data,
 		.read_word_data = max34440_read_word_data,
 		.write_word_data = max34440_write_word_data,
 	},
@@ -418,7 +417,6 @@ static struct pmbus_driver_info max34440_info[] = {
 		.func[15] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[16] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[17] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
-		.read_byte_data = max34440_read_byte_data,
 		.read_word_data = max34440_read_word_data,
 		.write_word_data = max34440_write_word_data,
 	},
@@ -454,7 +452,6 @@ static struct pmbus_driver_info max34440_info[] = {
 		.func[19] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[20] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
 		.func[21] = PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
-		.read_byte_data = max34440_read_byte_data,
 		.read_word_data = max34440_read_word_data,
 		.write_word_data = max34440_write_word_data,
 	},
-- 
2.25.1



