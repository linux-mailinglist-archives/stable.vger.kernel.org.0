Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8B32AF60
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhCCASv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241207AbhCBMU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:20:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E28164F8C;
        Tue,  2 Mar 2021 11:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686286;
        bh=uk69YBXcdAyp0nQw0aevjIpokhcshJLj47jy1NPiWt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkxXAxMNdqFX0z6Qc/ILAcXkrhxkRDWtpIzG6CNsckuaA+2UHCykJuId+3LmnByLK
         HUXv9iGE+DIYQ1VkvNtEuEcHazO+diM5JHedhKR/R+D1D8qL9SfCsFCyujykH9xqXw
         dR/7SELlrqmq0TJHzHF11kR4pwHR58qv7yWpxT7OEwjp3wiCW8Fecm0ge/1/Y8We+1
         Ghq7IC26rOjZVZd5xmKeb6RfBhb+NTFfjCKZm/tVvh8M9zNCXWtl3Y4mixtPIWNJK7
         bmlddcTFpwXbTcrDWEuFTJhQjmezHi+akiJ1EJk4ZyNkqBH1PeLsHwykBjBOKtkG9U
         mwqBMi3/Y/QAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@riseup.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/33] HID: logitech-dj: add support for the new lightspeed connection iteration
Date:   Tue,  2 Mar 2021 06:57:29 -0500
Message-Id: <20210302115749.62653-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index e5550a5bf49d..82fb9b639ca0 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -994,7 +994,12 @@ static void logi_hidpp_recv_queue_notif(struct hid_device *hdev,
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

