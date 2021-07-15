Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F783CA913
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241989AbhGOTFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242359AbhGOTDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71854613C4;
        Thu, 15 Jul 2021 18:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375576;
        bh=uNeipIKXrHdGL9rAuof73YYg8QiXPXN5XDsB8t2siVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qREWxDFyeeSuxGDQvUu+xI+6Owhrt34FYkIhk9+ahnBjVkPZz6cK6xSqb7zyB6wB
         smZktILM5USN3fjzBSFviqImNPIJjSC10jyVnSsYats7JLKWma+D9QdgKruh9QJYNU
         AEDeT3MChFs8IRI8hS2kkfYLds3OXWbXGEdMnYnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 145/242] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Thu, 15 Jul 2021 20:38:27 +0200
Message-Id: <20210715182618.735895954@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



