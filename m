Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FC13BD551
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhGFMTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235260AbhGFLgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 342E561F29;
        Tue,  6 Jul 2021 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570969;
        bh=grkEjosmlW7zlW8HPokuK+9bc9XrMK0ts/pfTBaXc38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyDgi2PEEG1dCGLX+LB3uTnYJKUN7qSc/BsowVgcd3OxoTa1wcIpZoi5CmJ+az1in
         wSlGvdZJ9xsNm3A/KXZbc+pp7zuE/CkGYj30PRCH3waKXfLWusbL/8ao8lsiOWW4Bg
         3ePsUzXjoaFJ4XAO5c80h3+dodherlmEYjoORVb4X0tH7nOtaiBuKP5yk6HRjFiVXs
         0tKrJR1mHlFbHgVGu8GhpcQX2y80t4rvscMOshTiDC1Jdyro5W8paHRYjEut+o1iMp
         oJv6r6hOt6AJQf0Z1SqIVCaEWV5Qn9kJAgZGdbs7XeJyp+CHZ7lztqskcRZTS+IF25
         FCEYTk7s1rwIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 34/35] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Tue,  6 Jul 2021 07:28:46 -0400
Message-Id: <20210706112848.2066036-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
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
index 4e3b24a0511f..30c09b9ddbf0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2508,6 +2508,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
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

