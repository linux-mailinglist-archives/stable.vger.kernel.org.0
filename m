Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246A840942A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346368AbhIMO2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345668AbhIMO0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13B6615E0;
        Mon, 13 Sep 2021 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540956;
        bh=RnTGpitOVSK49PGxxzBG9ysRsU0zQvCJoT8zuvJi518=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AesD8LO52uH1np/1l6deALA6zI8UjG4d2wMrcCL7amh1QYM/0SHHOtlaa6OnX/65p
         nyTBvmofVV7f6HOKIQHP4GoMDAgIhrNGkU4Vj2X1VZaj1H/FAJ1l+YzO1x2HagVEgD
         wzjFivlk7ccSK1bvH3/1qrLUhVBXh3F8mkLcWL0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>,
        Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 096/334] gve: fix the wrong AdminQ buffer overflow check
Date:   Mon, 13 Sep 2021 15:12:30 +0200
Message-Id: <20210913131116.622442421@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

[ Upstream commit 63a9192b8fa1ea55efeba1f18fad52bb24d9bf12 ]

The 'tail' pointer is also free-running count, so it needs to be masked
as 'adminq_prod_cnt' does, to become an index value of AdminQ buffer.

Fixes: 5cdad90de62c ("gve: Batch AQ commands for creating and destroying queues.")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 5bb56b454541..f089d33dd48e 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -322,7 +322,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
 
 	// Check if next command will overflow the buffer.
-	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
+	    (tail & priv->adminq_mask)) {
 		int err;
 
 		// Flush existing commands to make room.
@@ -332,7 +333,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 
 		// Retry.
 		tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
-		if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+		if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
+		    (tail & priv->adminq_mask)) {
 			// This should never happen. We just flushed the
 			// command queue so there should be enough space.
 			return -ENOMEM;
-- 
2.30.2



