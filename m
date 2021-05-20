Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8897A38A3A1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhETJz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234029AbhETJwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4617C61581;
        Thu, 20 May 2021 09:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503369;
        bh=2WHjvr9GkzDO1uT93ZbgQkhvdlHzfiDVYleSFNs5XR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSCDROR3JaVyaEALw0NuY99dALM2ctBGjsc2ThRHr0t8FsNqmcpyHLAoTVKBvAmmF
         tj24XtjCPSFiCWfKP4q1uk3mSS9BNhGpWB4kXI0RUEhRxlkvkbUKONVy9Y035d3cHI
         kW/brbo/35UovWm2SNz3DzNSsFOC0PjEOSFrdITU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 191/425] soundwire: bus: Fix device found flag correctly
Date:   Thu, 20 May 2021 11:19:20 +0200
Message-Id: <20210520092137.702096702@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit f03690f4f6992225d05dbd1171212e5be5a370dd ]

found flag is used to indicate SoundWire devices that are
both enumerated on the bus and available in the device list.
However this flag is not reset correctly after one iteration,
This could miss some of the devices that are enumerated on the
bus but not in device list. So reset this correctly to fix this issue!

Fixes: d52d7a1be02c ("soundwire: Add Slave status handling helpers")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210309104816.20350-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index df172bf3925f..0089b606b70d 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -514,7 +514,7 @@ static int sdw_program_device_num(struct sdw_bus *bus)
 	struct sdw_slave *slave, *_s;
 	struct sdw_slave_id id;
 	struct sdw_msg msg;
-	bool found = false;
+	bool found;
 	int count = 0, ret;
 	u64 addr;
 
@@ -545,6 +545,7 @@ static int sdw_program_device_num(struct sdw_bus *bus)
 
 		sdw_extract_slave_id(bus, addr, &id);
 
+		found = false;
 		/* Now compare with entries */
 		list_for_each_entry_safe(slave, _s, &bus->slaves, node) {
 			if (sdw_compare_devid(slave, id) == 0) {
-- 
2.30.2



