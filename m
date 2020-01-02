Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A6512EBFE
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgABWOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgABWOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C94E24653;
        Thu,  2 Jan 2020 22:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003251;
        bh=RgwvjIZONL5ZWANMEt1LiIYYnYCkycmum9J0tQGrhDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJSb/B7tmpGbHxaZiOokRtbPEtotaGJqaWsgq1Q1BE73fc9p65spFRuPDCpNa/v0B
         S/vmNHZ0Y4QeQ2CNLlHgtCVU74ME9EOgWGOvO66Dg65pJdlDfINsc7U4A2AsIHzezw
         iUnJJycg+DTCN0e79iUgIbeSkUGON7yKI8zZ7xqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Duggan <aduggan@synaptics.com>,
        Federico Cerutti <federico@ceres-c.it>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/191] HID: rmi: Check that the RMI_STARTED bit is set before unregistering the RMI transport device
Date:   Thu,  2 Jan 2020 23:06:04 +0100
Message-Id: <20200102215838.729753573@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7c6abd7e0979..9ce22acdfaca 100644
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



