Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA420128A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392683AbgFSPw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393069AbgFSPWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4FB920B80;
        Fri, 19 Jun 2020 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580169;
        bh=84y+gW41dURSJi/gdvoDOb2sY4x5qag2jIQ+OeQgv8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z29a/qUgLLSuq9nG9n02tIhvD6vqASzPXrOAkKedbrAYWDpY876pV4T3xCiCv++3r
         5qJDhOPRsO9ru13U9fhMNe0g+0B0bHin0BM+cM3rd5lXQkr3k8nX2MNBMebS7a0GbU
         xH6o+q0XreYYCJUwMn9Y1Gz/cqrYNE1mFVfNtwcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 118/376] Bluetooth: Adding driver and quirk defs for multi-role LE
Date:   Fri, 19 Jun 2020 16:30:36 +0200
Message-Id: <20200619141715.931612587@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Michaud <alainm@chromium.org>

[ Upstream commit 220915857e29795ae5ba4222806268b4a99c19c1 ]

This change adds the relevant driver and quirk to allow drivers to
report the le_states as being trustworthy.

This has historically been disabled as controllers did not reliably
support this. In particular, this will be used to relax this condition
for controllers that have been well tested and reliable.

	/* Most controller will fail if we try to create new connections
	 * while we have an existing one in slave role.
	 */
	if (hdev->conn_hash.le_num_slave > 0)
		return NULL;

Signed-off-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c   | 1 +
 include/net/bluetooth/hci.h | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3bdec42c9612..3d9313c746f3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -58,6 +58,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_CW6622		0x100000
 #define BTUSB_MEDIATEK		0x200000
 #define BTUSB_WIDEBAND_SPEECH	0x400000
+#define BTUSB_VALID_LE_STATES   0x800000
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 5f60e135aeb6..25c2e5ee81dc 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -214,6 +214,15 @@ enum {
 	 * This quirk must be set before hci_register_dev is called.
 	 */
 	HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
+
+	/* When this quirk is set, the controller has validated that
+	 * LE states reported through the HCI_LE_READ_SUPPORTED_STATES are
+	 * valid.  This mechanism is necessary as many controllers have
+	 * been seen has having trouble initiating a connectable
+	 * advertisement despite the state combination being reported as
+	 * supported.
+	 */
+	HCI_QUIRK_VALID_LE_STATES,
 };
 
 /* HCI device flags */
-- 
2.25.1



