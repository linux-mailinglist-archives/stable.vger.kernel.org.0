Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626603BD023
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhGFLcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235775AbhGFLa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2943161DE4;
        Tue,  6 Jul 2021 11:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570510;
        bh=uNeipIKXrHdGL9rAuof73YYg8QiXPXN5XDsB8t2siVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9hWHEYQj5OIp8lFePtuUEfbpV/4H2W1MExi4p6ydM5INdf8n0V2EdhhD3U9xUWtX
         fh9g+KPkQwwygwKyZIjG/LEcTBJ/3XIKeutTHVPS/yVdox12Nf3i0mj6UvOz28CXMP
         GZBiEjssV6ZHgwzkXKLCasu3BAOmEYPB32YlRz9q862NYgK5IQYMohp9D7JPhfJB4b
         Dh5WOZnDlY9knDq/fzNX+MXk7kXf3m+L868PzRDkVyjwbhTmra/MwZnujRmwl2P62q
         CxqGe1/Yjl6EXG5eytoN7cuP41LTp0ZykjPL1KmvYjAGhe9vYa2f4z9z1TfhRArekE
         rPejSJSGkQeOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 152/160] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Tue,  6 Jul 2021 07:18:18 -0400
Message-Id: <20210706111827.2060499-152-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 64b0e68c68eb..a97e5c476adf 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4136,6 +4136,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
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

