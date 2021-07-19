Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA56F3CD7D4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbhGSOTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241627AbhGSOSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 212266113A;
        Mon, 19 Jul 2021 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706757;
        bh=gO7RSFHlOEUnNLWCbNSgyRNjz9Vqus4iwXYwDKAzR0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDts61/DvA9jt7Ot6m0bK7Ub1yyxh1/Pkzf8Xl9fNIi4vR+Ff7cJ7ua0y5BqgVPkU
         7rqb+QkCNv5kEqw+iWtmTG3NEaPl9jajIDmWeGmZ+6GbSas6nOeZ7YC8eBvqwlixuW
         5iihHeBy05Zh20payOiL70cDsesyrWlEA04MV2Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 086/188] staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()
Date:   Mon, 19 Jul 2021 16:51:10 +0200
Message-Id: <20210719144933.106652877@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index 79de678807cc..1eacf82d1bd0 100644
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



