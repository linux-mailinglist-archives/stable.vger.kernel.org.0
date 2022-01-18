Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58D4491C6E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356072AbiARDPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42398 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348143AbiARDJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:09:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA59B80932;
        Tue, 18 Jan 2022 03:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADD2C36AEF;
        Tue, 18 Jan 2022 03:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475352;
        bh=zSkZappaJtuwv/bZPtL8x6NlRSEZ+4OEZLu9qlnKwxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhWvwOVqeuO/9xD6/gHlBu+OJmboZKMNTEEd60lpBf5Z2jLayvMBX+OBzCxuMjEY5
         q++EjJLAYc7TfxvC/Tpa2Sn2905zKWZqpnT9irIOUG0ralCXlfONeunayKfYcZaJXN
         +QH5nHEVK+DQpGz7u0BghHDuiUf05d1Q/xJZBG+xDUKdx6wcY6KiAqxCnyerrOkQ7D
         wOqFK1NWb5MfImzxpVD9vezfaEsT0it4n0IJy14zLuHjQfWCFvD/n43FU0h8odPP9X
         YPRbWkTn51nawd0n1Iijuy+gTjixQYP8lUf9w1bJuvdWNipzBBDEHTQIQpMvSS0gsA
         l5k5CAcRG2WMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, mathias.nyman@linux.intel.com,
        Thinh.Nguyen@synopsys.com, dan.carpenter@oracle.com,
        rajatja@google.com, cuibixuan@huawei.com, chris.chiu@canonical.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 17/29] usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0
Date:   Mon, 17 Jan 2022 22:08:10 -0500
Message-Id: <20220118030822.1955469-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 00558586382891540c59c9febc671062425a6e47 ]

When a new USB device gets plugged to nested hubs, the affected hub,
which connects to usb 2-1.4-port2, doesn't report there's any change,
hence the nested hubs go back to runtime suspend like nothing happened:
[  281.032951] usb usb2: usb wakeup-resume
[  281.032959] usb usb2: usb auto-resume
[  281.032974] hub 2-0:1.0: hub_resume
[  281.033011] usb usb2-port1: status 0263 change 0000
[  281.033077] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[  281.049797] usb 2-1: usb wakeup-resume
[  281.069800] usb 2-1: Waited 0ms for CONNECT
[  281.069810] usb 2-1: finish resume
[  281.070026] hub 2-1:1.0: hub_resume
[  281.070250] usb 2-1-port4: status 0203 change 0000
[  281.070272] usb usb2-port1: resume, status 0
[  281.070282] hub 2-1:1.0: state 7 ports 4 chg 0010 evt 0000
[  281.089813] usb 2-1.4: usb wakeup-resume
[  281.109792] usb 2-1.4: Waited 0ms for CONNECT
[  281.109801] usb 2-1.4: finish resume
[  281.109991] hub 2-1.4:1.0: hub_resume
[  281.110147] usb 2-1.4-port2: status 0263 change 0000
[  281.110234] usb 2-1-port4: resume, status 0
[  281.110239] usb 2-1-port4: status 0203, change 0000, 10.0 Gb/s
[  281.110266] hub 2-1.4:1.0: state 7 ports 4 chg 0000 evt 0000
[  281.110426] hub 2-1.4:1.0: hub_suspend
[  281.110565] usb 2-1.4: usb auto-suspend, wakeup 1
[  281.130998] hub 2-1:1.0: hub_suspend
[  281.137788] usb 2-1: usb auto-suspend, wakeup 1
[  281.142935] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[  281.177828] usb 2-1: usb wakeup-resume
[  281.197839] usb 2-1: Waited 0ms for CONNECT
[  281.197850] usb 2-1: finish resume
[  281.197984] hub 2-1:1.0: hub_resume
[  281.198203] usb 2-1-port4: status 0203 change 0000
[  281.198228] usb usb2-port1: resume, status 0
[  281.198237] hub 2-1:1.0: state 7 ports 4 chg 0010 evt 0000
[  281.217835] usb 2-1.4: usb wakeup-resume
[  281.237834] usb 2-1.4: Waited 0ms for CONNECT
[  281.237845] usb 2-1.4: finish resume
[  281.237990] hub 2-1.4:1.0: hub_resume
[  281.238067] usb 2-1.4-port2: status 0263 change 0000
[  281.238148] usb 2-1-port4: resume, status 0
[  281.238152] usb 2-1-port4: status 0203, change 0000, 10.0 Gb/s
[  281.238166] hub 2-1.4:1.0: state 7 ports 4 chg 0000 evt 0000
[  281.238385] hub 2-1.4:1.0: hub_suspend
[  281.238523] usb 2-1.4: usb auto-suspend, wakeup 1
[  281.258076] hub 2-1:1.0: hub_suspend
[  281.265744] usb 2-1: usb auto-suspend, wakeup 1
[  281.285976] hub 2-0:1.0: hub_suspend
[  281.285988] usb usb2: bus auto-suspend, wakeup 1

USB 3.2 spec, 9.2.5.4 "Changing Function Suspend State" says that "If
the link is in a non-U0 state, then the device must transition the link
to U0 prior to sending the remote wake message", but the hub only
transits the link to U0 after signaling remote wakeup.

So be more forgiving and use a 20ms delay to let the link transit to U0
for remote wakeup.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20211215120108.336597-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 66dda8d018caf..6097977f83a31 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1054,7 +1054,10 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 		} else {
 			hub_power_on(hub, true);
 		}
-	}
+	/* Give some time on remote wakeup to let links to transit to U0 */
+	} else if (hub_is_superspeed(hub->hdev))
+		msleep(20);
+
  init2:
 
 	/*
-- 
2.34.1

