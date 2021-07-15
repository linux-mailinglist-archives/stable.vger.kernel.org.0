Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA1F3CA61F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhGOSqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237791AbhGOSqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6ECB61396;
        Thu, 15 Jul 2021 18:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374603;
        bh=qKftyMldNJJkti1WY/IjZLiVzOId06DRlCQU7Ju/szM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWbcf8451i24qz6lxPZl2lDo/KFaqnScOgI5RRDZQMNP75bwsvLgpr53JSgUJz3z5
         Dp7c1xIn2u3zG8RdTP4O9dFLeVsMBxWSCQBebVwoi3mCtx18SIzdFzXs+GX6AZdBeY
         fysoNx+lN3pEI+34FX6gL+1EXCapbnc3Hl1+1OXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Jiang <tjiang@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/122] Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
Date:   Thu, 15 Jul 2021 20:38:34 +0200
Message-Id: <20210715182507.263972658@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
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
index 27ff7a6e2fc9..6d643651d69f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3263,6 +3263,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
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



