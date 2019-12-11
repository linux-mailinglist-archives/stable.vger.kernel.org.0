Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D3D11B374
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388240AbfLKPm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733143AbfLKP1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B1FB2173E;
        Wed, 11 Dec 2019 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078060;
        bh=ew/c3b39JyxgF0P/lZTDP2FSEn1SkE99vdKwJGXmN6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ncescyo7sQ47dLYgd/Xl00A6XYYl943tM97vUhdUoot41lL99jxs/jCTHEAfMqGxn
         p1ftUCMJWBcIWC1hBkl6CMdU9Wj+rzVdzWFtBsSZr2fYotNHxXte7j/NyWxdjB/fHy
         K1tx4702b62Oo933HBtfGLgCvqE3R5U/m275no3c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Duggan <aduggan@synaptics.com>,
        Federico Cerutti <federico@ceres-c.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 53/79] HID: rmi: Check that the RMI_STARTED bit is set before unregistering the RMI transport device
Date:   Wed, 11 Dec 2019 10:26:17 -0500
Message-Id: <20191211152643.23056-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
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
index 9e33165250a34..a5b6b2be9cda8 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -737,7 +737,8 @@ static void rmi_remove(struct hid_device *hdev)
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

