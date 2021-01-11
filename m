Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3D62F14E1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbhAKNP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731879AbhAKNP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD4A7227C3;
        Mon, 11 Jan 2021 13:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370885;
        bh=acif9ItcE+J1Fn1mgBfQPEX361VIIqCAwFDdZuTiARo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZzcUQ7wyvQ3hB+yGJgk3E7EP1QgYC3J4+NyksK5PyvYrTF0p4Fz9y8q9b6hJGbob
         ecCVmGvJYEH/VXi01r+MmWCzv3SCs8RfgFrxBojGHUn2lDXyegHHz1z9bKfT7ir/fH
         l5a1qRSbVndEw1XFNKS/fsBK2AqwOJJFA1U5bx+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YANG LI <abaci-bugfix@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 046/145] ibmvnic: fix: NULL pointer dereference.
Date:   Mon, 11 Jan 2021 14:01:10 +0100
Message-Id: <20210111130050.736495477@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YANG LI <abaci-bugfix@linux.alibaba.com>

[ Upstream commit 862aecbd9569e563b979c0e23a908b43cda4b0b9 ]

The error is due to dereference a null pointer in function
reset_one_sub_crq_queue():

if (!scrq) {
    netdev_dbg(adapter->netdev,
               "Invalid scrq reset. irq (%d) or msgs(%p).\n",
		scrq->irq, scrq->msgs);
		return -EINVAL;
}

If the expression is true, scrq must be a null pointer and cannot
dereference.

Fixes: 9281cf2d5840 ("ibmvnic: avoid memset null scrq msgs")
Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
Acked-by: Lijun Pan <ljp@linux.ibm.com>
Link: https://lore.kernel.org/r/1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2869,9 +2869,7 @@ static int reset_one_sub_crq_queue(struc
 	int rc;
 
 	if (!scrq) {
-		netdev_dbg(adapter->netdev,
-			   "Invalid scrq reset. irq (%d) or msgs (%p).\n",
-			   scrq->irq, scrq->msgs);
+		netdev_dbg(adapter->netdev, "Invalid scrq reset.\n");
 		return -EINVAL;
 	}
 


