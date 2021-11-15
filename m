Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6F4511C3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbhKOTOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244126AbhKOTKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:10:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E014160F51;
        Mon, 15 Nov 2021 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000336;
        bh=J4WEKxdziVKZeSMKf6bYQgQWGqL2ENvoYxPShXVsfAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFt4ilnH4UpEySQLDq7cG1ssXIAv2esJ7rciGmO6ZjhjyWb8GkH8y4FmtZS0mp7Yd
         dXxlCPv0/pCNKpMRSO0vSF/z7ar7b5a68qvcf5MK0HIDp10VTfNjLXyhJjDvFQ9Sf7
         VBeapD0fECWEh6TQUYvPA6jOGflRoJmusKJdzIys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 623/849] soundwire: bus: stop dereferencing invalid slave pointer
Date:   Mon, 15 Nov 2021 18:01:46 +0100
Message-Id: <20211115165441.337243438@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 4cbbe74d906be0bcffbe1e74b43a00f99626a69c ]

Slave pointer is invalid after end of list iteration, using this
would result in below Memory abort.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
...
Call trace:
 __dev_printk+0x34/0x7c
 _dev_warn+0x6c/0x90
 sdw_bus_exit_clk_stop+0x194/0x1d0
 swrm_runtime_resume+0x13c/0x238
 pm_generic_runtime_resume+0x2c/0x48
 __rpm_callback+0x44/0x150
 rpm_callback+0x6c/0x78
 rpm_resume+0x314/0x558
 rpm_resume+0x378/0x558
 rpm_resume+0x378/0x558
 __pm_runtime_resume+0x3c/0x88

Use bus->dev instead to print this error message.

Fixes: b50bb8ba369cd ("soundwire: bus: handle -ENODATA errors in clock stop/start sequences")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20211012101521.32087-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 3e6d4addac2f6..98c526aaf24b8 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1103,7 +1103,7 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 	if (!simple_clk_stop) {
 		ret = sdw_bus_wait_for_clk_prep_deprep(bus, SDW_BROADCAST_DEV_NUM);
 		if (ret < 0)
-			dev_warn(&slave->dev, "clock stop deprepare wait failed:%d\n", ret);
+			dev_warn(bus->dev, "clock stop deprepare wait failed:%d\n", ret);
 	}
 
 	list_for_each_entry(slave, &bus->slaves, node) {
-- 
2.33.0



