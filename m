Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD634A43F1
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359297AbiAaLZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41252 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377471AbiAaLXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92A41B82A68;
        Mon, 31 Jan 2022 11:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C6BC340E8;
        Mon, 31 Jan 2022 11:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628177;
        bh=jaShq98JWt/4G1rxxT0SsgxNhjhM7Xe664ljyLbL7BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNwtSP/DP/L1ttW4iU6tlntf0QEYqXbychRXLI2EvPn6PKh50YpoHtSdO7r3DHBKH
         4dM+PFFRYtIOOSlgNWS8SxAoSxwP/Zu+UU/Efp4/5SBl+UbgTw1dwO5Yh6rSq/9TD8
         YIKkqtkG5qkU2GavPWSXcQtJheSt0bBDE7/EcqHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 149/200] octeontx2-pf: Forward error codes to VF
Date:   Mon, 31 Jan 2022 11:56:52 +0100
Message-Id: <20220131105238.574507596@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit a8db854be28622a2477cb21cdf7f829adbb2c42d ]

PF forwards its VF messages to AF and corresponding
replies from AF to VF. AF sets proper error code in the
replies after processing message requests. Currently PF
checks the error codes in replies and sends invalid
message to VF. This way VF lacks the information of
error code set by AF for its messages. This patch
changes that such that PF simply forwards AF replies
so that VF can handle error codes.

Fixes: d424b6c02415 ("octeontx2-pf: Enable SRIOV and added VF mbox handling")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 1e0d0c9c1dac3..ba7f6b295ca55 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -394,7 +394,12 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 		dst_mdev->msg_size = mbox_hdr->msg_size;
 		dst_mdev->num_msgs = num_msgs;
 		err = otx2_sync_mbox_msg(dst_mbox);
-		if (err) {
+		/* Error code -EIO indicate there is a communication failure
+		 * to the AF. Rest of the error codes indicate that AF processed
+		 * VF messages and set the error codes in response messages
+		 * (if any) so simply forward responses to VF.
+		 */
+		if (err == -EIO) {
 			dev_warn(pf->dev,
 				 "AF not responding to VF%d messages\n", vf);
 			/* restore PF mbase and exit */
-- 
2.34.1



