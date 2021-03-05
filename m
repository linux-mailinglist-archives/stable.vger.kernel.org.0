Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAFE32E81F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCEMZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhCEMYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FBD6501D;
        Fri,  5 Mar 2021 12:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947091;
        bh=/m9csJFacHPuZim9ofhYapu01vcHuY+CZuxXvdqizww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeDuZMsq9LefxZVObLo3HBUN0znLSKxFPvywY97/4yNHNY1M+KVkIA/LNcOvM39Z+
         1lfBFWPXYzWKOcf5JqkEHzDREnUi+QmMFq1fxIyiqalEcpGEwmENXJRctLDbtDT0wb
         Zm4kG4nODWHvvuaIrUL80vDjBaeRv9jnXaL+cPGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claire Chang <tientzu@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 044/104] Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl
Date:   Fri,  5 Mar 2021 13:20:49 +0100
Message-Id: <20210305120905.331494419@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit 7f9f2c3f7d99b8ae773459c74ac5e99a0dd46db9 ]

Realtek Bluetooth controllers can do both LE scan and BR/EDR inquiry
at once, need to set HCI_QUIRK_SIMULTANEOUS_DISCOVERY quirk.

Signed-off-by: Claire Chang <tientzu@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 7be16a7f653b..95ecd30e6619 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -906,6 +906,11 @@ static int h5_btrtl_setup(struct h5 *h5)
 	/* Give the device some time before the hci-core sends it a reset */
 	usleep_range(10000, 20000);
 
+	/* Enable controller to do both LE scan and BR/EDR inquiry
+	 * simultaneously.
+	 */
+	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &h5->hu->hdev->quirks);
+
 out_free:
 	btrtl_free(btrtl_dev);
 
-- 
2.30.1



