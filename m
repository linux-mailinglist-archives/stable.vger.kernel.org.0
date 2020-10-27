Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972FA29B850
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1800006AbgJ0Peg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800000AbgJ0Pef (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25FC22275;
        Tue, 27 Oct 2020 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812874;
        bh=b/C4lllXJjGS1GFK3sZBG0HqndHL2ZzbzHRAvd5JtJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3JI2IbEx05WHY16emV507EwkjAtuwBAFw5G/JS6YVrPlSzRjIyNRyEwWKsvmvwnd
         HIKXmDIP3TN7Yn/rLoU8jxigdTipBOIIJ6kVV0mNJUZwGyP9CtPuTmz8GFjc146oub
         3NK0EganbrqRb1ML7buDD1vFwJc6FX85l+Ymnp1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 360/757] staging: rtl8712: Fix enqueue_reorder_recvframe()
Date:   Tue, 27 Oct 2020 14:50:10 +0100
Message-Id: <20201027135507.460350820@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 29838144f280fc03ca06a621568f34e1d0a65a4f ]

The logic of this function was accidentally broken by a checkpatch
inspired cleanup.  I've modified the code to restore the original
behavior and also make checkpatch happy.

Fixes: 98fe05e21a6e ("staging: rtl8712: Remove unnecesary else after return statement.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200929103548.GA493135@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/rtl8712_recv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index d83f421acfc1e..a397dc6231f13 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -477,11 +477,14 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 	while (!end_of_queue_search(phead, plist)) {
 		pnextrframe = container_of(plist, union recv_frame, u.list);
 		pnextattrib = &pnextrframe->u.hdr.attrib;
+
+		if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num))
+			return false;
+
 		if (SN_LESS(pnextattrib->seq_num, pattrib->seq_num))
 			plist = plist->next;
-		else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num))
-			return false;
-		break;
+		else
+			break;
 	}
 	list_del_init(&(prframe->u.hdr.list));
 	list_add_tail(&(prframe->u.hdr.list), plist);
-- 
2.25.1



