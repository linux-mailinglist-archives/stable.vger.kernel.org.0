Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805A23BD253
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbhGFLmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237614AbhGFLgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F1F461F50;
        Tue,  6 Jul 2021 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570923;
        bh=flRU1/nWCDRQ6R0bshuPatNPWKM0h0EUK/k/aA8oMCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9YVj14tZ60OPO0qN2cgr3yzVJKu6W01MZsDLetMjvU98IrWJ/K6LycT7Ypy7B/x4
         nBXHa1Ys4L1M1A9sxhoARZh67d5YyQRpSVebGtoipHaCN4QuSBZt0k/tHQsaouftq3
         Wru3zy+2tXu0htq20DrKxatJn56T4WY2sc+1kigVBv3ytNlZ/rLLgZfsGtP9sxodoc
         cHEfdxhh0MkNIucCG0cvGpKBLQfhO4V9FdUJaDntYdNwX0iD81bpTSJ9RKAgYabmzY
         lBHZWk0gKaNiwJVaG6xUzqqb6Wj0cD46Mt2+aUJrhRYky9lWMWb1DRRsxGLuPqkNdl
         1vh7X2NxLx7dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 43/45] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Tue,  6 Jul 2021 07:27:47 -0400
Message-Id: <20210706112749.2065541-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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
index 424f399cc79b..f2e84e09c970 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2614,6 +2614,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
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

