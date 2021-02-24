Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CCD323D6A
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhBXNKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:10:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235653AbhBXND6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:03:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7421264F6A;
        Wed, 24 Feb 2021 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171227;
        bh=495vMUEs4+9RiH8DyQg4siaLF6wq1AnjE7jEP8RPGfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHt8DjI4wOtrPp14UENmZMmKFeAckTnQFggyXpeZfb+uaG0+wb8N5rhw1Coz9WIzl
         WcM9Qc9GBQa8IrpxlC0b9HQngTKBOsvJkviEwBWbkRUoo3L3OGx8DzZJmsEqIpZOmw
         C7lDBZqiS20tUi1d1EnCa+wRdpTFfMTTfVFP1ImJLULFnLeG06jL/P4NrAawu11B6C
         NR+yBRftUZqrPYz5nGegJz7HTVMyPs5kdt31cr3S3YNmBSRMNb70jH7ER7heurWqiR
         v/oiDhuq7braJQxz5XqiV3J+vc68/pwaNspvnafJ8QDhn/yEuMyQnhMoWIgXbxt1P6
         +tBMyi/C+5OuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claire Chang <tientzu@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/40] Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl
Date:   Wed, 24 Feb 2021 07:53:05 -0500
Message-Id: <20210224125340.483162-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e11af747395dd..bf3e23104194a 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -894,6 +894,11 @@ static int h5_btrtl_setup(struct h5 *h5)
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
2.27.0

