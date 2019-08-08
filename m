Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A53F86992
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404532AbfHHTIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404940AbfHHTIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AD862173E;
        Thu,  8 Aug 2019 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291315;
        bh=+fdep5RJVQSc0mu4tM0fr/rxAD8tPOhZXxWz/dcPWLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JpKN5EPF6oX4LITzRC41KJ5nuvpDXj/YkHDf+C5YHCW26PNbngPnhon1EWm0Lp/y
         a5VUO2sXwm+hbQFS4GVcfByZO1fvUczSGCfResFG1Pf06oEsnZqy5EA5P4RjhwXwCa
         hVzM6nAqyQsbwQjtSsiSgWe244WuyO+eLVuzsKmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 13/45] bnx2x: Disable multi-cos feature.
Date:   Thu,  8 Aug 2019 21:04:59 +0200
Message-Id: <20190808190454.503212078@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

[ Upstream commit d1f0b5dce8fda09a7f5f04c1878f181d548e42f5 ]

Commit 3968d38917eb ("bnx2x: Fix Multi-Cos.") which enabled multi-cos
feature after prolonged time in driver added some regression causing
numerous issues (sudden reboots, tx timeout etc.) reported by customers.
We plan to backout this commit and submit proper fix once we have root
cause of issues reported with this feature enabled.

Fixes: 3968d38917eb ("bnx2x: Fix Multi-Cos.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1936,8 +1936,7 @@ u16 bnx2x_select_queue(struct net_device
 	}
 
 	/* select a non-FCoE queue */
-	return fallback(dev, skb, NULL) %
-	       (BNX2X_NUM_ETH_QUEUES(bp) * bp->max_cos);
+	return fallback(dev, skb, NULL) % (BNX2X_NUM_ETH_QUEUES(bp));
 }
 
 void bnx2x_set_num_queues(struct bnx2x *bp)


