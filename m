Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FEB15E928
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbgBNRFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:05:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392425AbgBNQPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83DC246DC;
        Fri, 14 Feb 2020 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696912;
        bh=hVrg8rRe/pnLXFS4sp1Q4wJtlR5vsf1nCybQKCaUqxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoVpXz0b2uYWxxLxTHxFNYCTozc8uvcxqQhVjmnCrXcEuFGOUJ9bAvJ9p5Ye+liTu
         t4mm8sF5v5LRMozOiUcu7DpK2wqlpgzHzn+aeSi/wud7MSPKX1prRtE9jHWiLMrgxs
         gbnXgid9VJI9l0pL62wyEtRS08oQ+xcFkEKuHJlY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, sparmaintainer@unisys.com
Subject: [PATCH AUTOSEL 4.19 161/252] visorbus: fix uninitialized variable access
Date:   Fri, 14 Feb 2020 11:10:16 -0500
Message-Id: <20200214161147.15842-161-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit caf82f727e69b647f09d57a1fc56e69d22a5f483 ]

The setup_crash_devices_work_queue function only partially initializes
the message it sends to chipset_init, leading to undefined behavior:

drivers/visorbus/visorchipset.c: In function 'setup_crash_devices_work_queue':
drivers/visorbus/visorchipset.c:333:6: error: '((unsigned char*)&msg.hdr.flags)[0]' is used uninitialized in this function [-Werror=uninitialized]
  if (inmsg->hdr.flags.response_expected)

Set up the entire structure, zero-initializing the 'response_expected'
flag.

This was apparently found by the patch that added the -O3 build option
in Kconfig.

Fixes: 12e364b9f08a ("staging: visorchipset driver to provide registration and other services")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200107202950.782951-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/visorbus/visorchipset.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/visorbus/visorchipset.c b/drivers/visorbus/visorchipset.c
index ca752b8f495fa..cb1eb7e05f871 100644
--- a/drivers/visorbus/visorchipset.c
+++ b/drivers/visorbus/visorchipset.c
@@ -1210,14 +1210,17 @@ static void setup_crash_devices_work_queue(struct work_struct *work)
 {
 	struct controlvm_message local_crash_bus_msg;
 	struct controlvm_message local_crash_dev_msg;
-	struct controlvm_message msg;
+	struct controlvm_message msg = {
+		.hdr.id = CONTROLVM_CHIPSET_INIT,
+		.cmd.init_chipset = {
+			.bus_count = 23,
+			.switch_count = 0,
+		},
+	};
 	u32 local_crash_msg_offset;
 	u16 local_crash_msg_count;
 
 	/* send init chipset msg */
-	msg.hdr.id = CONTROLVM_CHIPSET_INIT;
-	msg.cmd.init_chipset.bus_count = 23;
-	msg.cmd.init_chipset.switch_count = 0;
 	chipset_init(&msg);
 	/* get saved message count */
 	if (visorchannel_read(chipset_dev->controlvm_channel,
-- 
2.20.1

