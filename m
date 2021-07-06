Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9883BD53B
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbhGFMUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235825AbhGFLi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:38:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E75C461F9E;
        Tue,  6 Jul 2021 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625571008;
        bh=1sBETN6rIbaTwHUtC11AQYjCwr1sxghOp+CJdkx7l4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lb63hGEAA/1fILhbOpP8m4IYz68j+mm8jAe5s9Ns5ZgJRbO2e0VRN9T6a5HdT+J77
         wMejnBrBtf8D3puNKomO3gW5DxWE7WsLcSUHdhUA8HbSAKDonlOnkj0xtsk+NyoZtZ
         bqAjxAiu2Lk8dh+CT7kI2AoZzuVpDR9ZxFnzqWuznwsNIUSZidDezUelSuKOSMnWLE
         KNgeJABVC74GrlL80ijOzPAq2z4yPFDEdVLgURYFyna2JpyUvQq++uaIzNWNlsAu7W
         dMliXDQiXVkuydHGSMhEUJtSDqMuvTk0OOor3+8q6xk7/28o15DK8m++Qq6vQ9zMAG
         WBeACu6APw6ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 30/31] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Tue,  6 Jul 2021 07:29:30 -0400
Message-Id: <20210706112931.2066397-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
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
index 7039a58a6a4e..3d62f17111cb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2555,6 +2555,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
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

