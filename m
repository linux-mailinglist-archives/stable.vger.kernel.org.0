Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574BC3BCEB1
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhGFL1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234093AbhGFLXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DFF361D04;
        Tue,  6 Jul 2021 11:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570292;
        bh=9CZYZH1IJIqZRfQ/cPp5d9YX2cUsPDo8NZVgJPiZQHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZoxlgTlRJdGPxDuwRUtp4huAAbF8SRWq/ITUiR8VeJDGYdHmQvEVqPCwCcOP1/h2
         XObDL1GMqcU0MoaCVR6gNZumAiAQkSQytTaDYDb2f+7dggTg6cLR9NpH2TWJ8IR8BR
         eSDV7Eb0NSLP8Nz+ovO5AlzFPGznV5eFkHs+n+STV+5tO15rlP1b3LnAXK84lUTNzY
         gPUQrG+E26IpL9DbOlxfoFKkP3KHtwlXfYQYC7lzItu4/npmWwQwnrMdvUiieLhgT9
         5x8Oh7zMEBrE+cOyhun74nEVsjYfw8dXnY+UoeAC6knr5ddOI/HKXqhG3F0Cn/oQ/B
         hFO/5VpeYRMjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 181/189] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Tue,  6 Jul 2021 07:14:01 -0400
Message-Id: <20210706111409.2058071-181-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Jiang <tjiang@codeaurora.org>

[ Upstream commit 4f00bfb372674d586c4a261bfc595cbce101fbb6 ]

This is btsoc timing issue, after host start to downloading bt firmware,
ep2 need time to switch from function acl to function dfu, so host add
20ms delay as workaround.

Signed-off-by: Tim Jiang <tjiang@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1cec9b2353c6..6d23308119d1 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4071,6 +4071,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
 	sent += size;
 	count -= size;
 
+	/* ep2 need time to switch from function acl to function dfu,
+	 * so we add 20ms delay here.
+	 */
+	msleep(20);
+
 	while (count) {
 		size = min_t(size_t, count, QCA_DFU_PACKET_LEN);
 
-- 
2.30.2

