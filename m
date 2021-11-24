Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52845C3BB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345643AbhKXNmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350500AbhKXNkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C7161881;
        Wed, 24 Nov 2021 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758642;
        bh=h7oNJwJI9SFyfWSf6gY+J+ZUwBZzXZZJnqW3zBPQv4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcYsRq17W+/BqpizcAdod4hox6IQjftB9Wz9qpd4vn9Uorp678HYzNXCRXsEwodsm
         IC/Q1bi9qSXdMlLQrsqpGND/9pLOK0ehwsRsGPa8kdUvwCdX8IQkyjPNnFRjDyRmQm
         OfLUFUJXqzW/hBheneLT2NxzjumOgMr/I1N4S6ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/154] net: nfc: nci: Change the NCI close sequence
Date:   Wed, 24 Nov 2021 12:58:25 +0100
Message-Id: <20211124115705.814506942@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

[ Upstream commit f011539e723c737b74876ac47345e40270a3c384 ]

If there is a NCI command in work queue after closing the NCI device at
nci_unregister_device, The NCI command timer starts at flush_workqueue
function and then NCI command timeout handler would be called 5 second
after flushing the NCI command work queue and destroying the queue.
At that time, the timeout handler would try to use NCI command work queue
that is destroyed already. it will causes the problem. To avoid this
abnormal situation, change the sequence to prevent the NCI command timeout
handler from being called after destroying the NCI command work queue.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 5e55cb6c087a2..4d3ab0f44c9f4 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -568,11 +568,11 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	clear_bit(NCI_INIT, &ndev->flags);
 
-	del_timer_sync(&ndev->cmd_timer);
-
 	/* Flush cmd wq */
 	flush_workqueue(ndev->cmd_wq);
 
+	del_timer_sync(&ndev->cmd_timer);
+
 	/* Clear flags */
 	ndev->flags = 0;
 
-- 
2.33.0



