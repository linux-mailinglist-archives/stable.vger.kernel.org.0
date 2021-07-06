Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3193BD509
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhGFMSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236951AbhGFLfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F09CE61C5C;
        Tue,  6 Jul 2021 11:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570691;
        bh=weH4CNkH3qClIGicJA8ZV2exCFsK3zq5d/yVwQmLTII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfGbyRz4qEcLJFYLyQVKvS/M8QaNj8YRj/MHvGGDSezmg/+tSnZ1cDRLtSF9ZHtYD
         MLOUxfkxIIgiK77OH0IFoMVJeSeSr8DaGKDC1+SpLjG+swOXUPIe6RJh/zUOgWFBSO
         k0ZitEqJu640sh96pdqmBD/6Q+xAP7CoBFRyUbVwTyTmxd3zl52l/VJdd+/Y7IWaOW
         +79zqTQH7vaIGtZSwA6xoEyna0LErkSGc0pG1SoSFwBjbC7cPSvTjAPavIfxL0rQZY
         hgTazPSzAmCh9IK0SSJBry9BEUI5apqCp4r1Buj6nO3ssd2QTLRCPKsln5uET1KvNM
         +nkNuaeeFSh9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 130/137] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Tue,  6 Jul 2021 07:21:56 -0400
Message-Id: <20210706112203.2062605-130-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index b3c63e06838d..afd2b1f12d49 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3558,6 +3558,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
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

