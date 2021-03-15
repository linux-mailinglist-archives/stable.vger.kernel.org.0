Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8F33B9DE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhCOOG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233299AbhCOOBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC62064EF3;
        Mon, 15 Mar 2021 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816839;
        bh=w4QaNXjUDjaiped9JuQNsCoByJ8C/CItVMR5fDiL4kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFTFgKeTqYkLIe3Gh9h+OJnTv6zShfSBjJi6noCCqsdRmAm1rN/XxpjuEJZiUK8Jw
         qScuke+OJlTnGH275VVnAvWxXvbG8WYC/Tfg6ZA2zMswHSB2XajPUgok2H4aPq3NtL
         slOJWSElXcMEHEjEXI//FHzZEVMkuBbCD3vxpzLk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@riseup.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/290] HID: logitech-dj: add support for the new lightspeed connection iteration
Date:   Mon, 15 Mar 2021 14:53:57 +0100
Message-Id: <20210315135546.778815639@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Filipe Laíns <lains@riseup.net>

[ Upstream commit fab3a95654eea01d6b0204995be8b7492a00d001 ]

This new connection type is the new iteration of the Lightspeed
connection and will probably be used in some of the newer gaming
devices. It is currently use in the G Pro X Superlight.

This patch should be backported to older versions, as currently the
driver will panic when seing the unsupported connection. This isn't
an issue when using the receiver that came with the device, as Logitech
has been using different PIDs when they change the connection type, but
is an issue when using a generic receiver (well, generic Lightspeed
receiver), which is the case of the one in the Powerplay mat. Currently,
the only generic Ligthspeed receiver we support, and the only one that
exists AFAIK, is ther Powerplay.

As it stands, the driver will panic when seeing a G Pro X Superlight
connected to the Powerplay receiver and won't send any input events to
userspace! The kernel will warn about this so the issue should be easy
to identify, but it is still very worrying how hard it will fail :(

[915977.398471] logitech-djreceiver 0003:046D:C53A.0107: unusable device of type UNKNOWN (0x0f) connected on slot 1

Signed-off-by: Filipe Laíns <lains@riseup.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index fcdc922bc973..271bd8d24339 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -995,7 +995,12 @@ static void logi_hidpp_recv_queue_notif(struct hid_device *hdev,
 		workitem.reports_supported |= STD_KEYBOARD;
 		break;
 	case 0x0d:
-		device_type = "eQUAD Lightspeed 1_1";
+		device_type = "eQUAD Lightspeed 1.1";
+		logi_hidpp_dev_conn_notif_equad(hdev, hidpp_report, &workitem);
+		workitem.reports_supported |= STD_KEYBOARD;
+		break;
+	case 0x0f:
+		device_type = "eQUAD Lightspeed 1.2";
 		logi_hidpp_dev_conn_notif_equad(hdev, hidpp_report, &workitem);
 		workitem.reports_supported |= STD_KEYBOARD;
 		break;
-- 
2.30.1



