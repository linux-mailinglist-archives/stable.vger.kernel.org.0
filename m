Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3646611B699
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfLKPNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731393AbfLKPNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C54812464B;
        Wed, 11 Dec 2019 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077200;
        bh=aHg8pTeJxTgKJijpf2cEEJRvzMiodnvZkagbclORluA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFz2LROsV3KCaQ8m/N3RoFs4KbNVHCiHb5/UgtrPSJ6dk72HWdQZ9iCpSsTpD+Qwp
         M5kXne7UUmAMnccZpGQDrJECR5uZUFtYAJOQ/XLohv5I2rcryemngZ3R5hpnMvQBkW
         ISU+/W1OWRTr5T4QitVQ9lS85bfZss2HaERJ+nOk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Duggan <aduggan@synaptics.com>,
        Federico Cerutti <federico@ceres-c.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 083/134] HID: rmi: Check that the RMI_STARTED bit is set before unregistering the RMI transport device
Date:   Wed, 11 Dec 2019 10:10:59 -0500
Message-Id: <20191211151150.19073-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Duggan <aduggan@synaptics.com>

[ Upstream commit 8725aa4fa7ded30211ebd28bb1c9bae806eb3841 ]

In the event that the RMI device is unreachable, the calls to rmi_set_mode() or
rmi_set_page() will fail before registering the RMI transport device. When the
device is removed, rmi_remove() will call rmi_unregister_transport_device()
which will attempt to access the rmi_dev pointer which was not set.
This patch adds a check of the RMI_STARTED bit before calling
rmi_unregister_transport_device().  The RMI_STARTED bit is only set
after rmi_register_transport_device() completes successfully.

The kernel oops was reported in this message:
https://www.spinics.net/lists/linux-input/msg58433.html

[jkosina@suse.cz: reworded changelog as agreed with Andrew]
Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
Reported-by: Federico Cerutti <federico@ceres-c.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 7c6abd7e09797..9ce22acdfaca2 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -744,7 +744,8 @@ static void rmi_remove(struct hid_device *hdev)
 {
 	struct rmi_data *hdata = hid_get_drvdata(hdev);
 
-	if (hdata->device_flags & RMI_DEVICE) {
+	if ((hdata->device_flags & RMI_DEVICE)
+	    && test_bit(RMI_STARTED, &hdata->flags)) {
 		clear_bit(RMI_STARTED, &hdata->flags);
 		cancel_work_sync(&hdata->reset_work);
 		rmi_unregister_transport_device(&hdata->xport);
-- 
2.20.1

