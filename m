Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7459B3CD9B7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbhGSObW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243245AbhGSO24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:28:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD8961242;
        Mon, 19 Jul 2021 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707314;
        bh=fvKy1X4vRSJubuRPvcduF5CfYzHb+OZ32u0JTjFbEKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Da0ERFgWqDQ7EH+tzW+TeznZ6sLXZsBccSBfukqHMzozm/g0xWkbDrcMSZuf3PM9Z
         FTBOqRAuhAJKedwn9F/QOpeJ53GmovlrSUtjDfjachX0nyyFXWCg4IufAKqWXL+jDj
         fdywYAt1cVQYERwDZreWqC5imuK2evo9LOLEQFEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 111/245] staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()
Date:   Mon, 19 Jul 2021 16:50:53 +0200
Message-Id: <20210719144944.011705769@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4a36e160856db8a8ddd6a3d2e5db5a850ab87f82 ]

There needs to be a check to verify that we don't read beyond the end
of "buf".  This function is called from do_rx().  The "buf" is the USB
transfer_buffer and "len" is "urb->actual_length".

Fixes: 61e121047645 ("staging: gdm7240: adding LTE USB driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YMcnl4zCwGWGDVMG@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gdm724x/gdm_lte.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index e72dfa9699f3..1bc2b3365e32 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -689,6 +689,7 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 	struct multi_sdu *multi_sdu = (struct multi_sdu *)buf;
 	struct sdu *sdu = NULL;
 	u8 *data = (u8 *)multi_sdu->data;
+	int copied;
 	u16 i = 0;
 	u16 num_packet;
 	u16 hci_len;
@@ -702,6 +703,12 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 				      multi_sdu->num_packet);
 
 	for (i = 0; i < num_packet; i++) {
+		copied = data - multi_sdu->data;
+		if (len < copied + sizeof(*sdu)) {
+			pr_err("rx prevent buffer overflow");
+			return;
+		}
+
 		sdu = (struct sdu *)data;
 
 		cmd_evt = gdm_dev16_to_cpu(phy_dev->
@@ -715,7 +722,8 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 			pr_err("rx sdu wrong hci %04x\n", cmd_evt);
 			return;
 		}
-		if (hci_len < 12) {
+		if (hci_len < 12 ||
+		    len < copied + sizeof(*sdu) + (hci_len - 12)) {
 			pr_err("rx sdu invalid len %d\n", hci_len);
 			return;
 		}
-- 
2.30.2



