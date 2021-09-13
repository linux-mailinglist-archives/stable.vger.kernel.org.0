Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B44091AC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343778AbhIMODa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343929AbhIMOB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BAF661A60;
        Mon, 13 Sep 2021 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540274;
        bh=GJNOncqH2W/ivQ9e4eSevRzDSsul7NmD2/lW4RAA1Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2C908+BmkW4TCBCZBgm8EQfpPkb/jdr1TUtcNEmAiXzoVvl+aU8Vf1oBsu1Xk0AS
         D81SUJHi07GC6ynJPrL/4mT084xFHA8onfTSKjYonwr50eB0DLnoptW4ZHJ6NqiGYG
         2xhx9J0JQXn9LGuQrOEBx0bmfncgvhwszsXKxmEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>,
        Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 093/300] gve: fix the wrong AdminQ buffer overflow check
Date:   Mon, 13 Sep 2021 15:12:34 +0200
Message-Id: <20210913131112.525394716@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 53864f200599..b175f2b2f5bc 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -233,7 +233,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
 
 	// Check if next command will overflow the buffer.
-	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
+	    (tail & priv->adminq_mask)) {
 		int err;
 
 		// Flush existing commands to make room.
@@ -243,7 +244,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 
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



