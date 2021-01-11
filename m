Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19FC2F152A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731874AbhAKNgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731981AbhAKNNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF2A21534;
        Mon, 11 Jan 2021 13:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370809;
        bh=kNO3KipiFXEsWPJ01ZPZn2Txoo8zY+/9Xz4w4VV+vno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvGvBRtUwESUOp0i9BNktgrwj1s3rp6NKXtBn8tJMqqtH4LUUrbv506MSxccTvwbY
         ElvCI4OEBj1N3g9TiHxLK11aTnzfIGlkNjlQtjd/FF2are8vxzxYbU2iz5u7APabGv
         oha2jT/lwO0ONFB9Ij953O+s4F/C9JSLQzVUFd5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 014/145] ibmvnic: continue fatal error reset after passive init
Date:   Mon, 11 Jan 2021 14:00:38 +0100
Message-Id: <20210111130049.198080120@linuxfoundation.org>
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

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 1f45dc22066797479072978feeada0852502e180 ]

Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
says "If the passive
CRQ initialization occurs before the FATAL reset task is processed,
the FATAL error reset task would try to access a CRQ message queue
that was freed, causing an oops. The problem may be most likely to
occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
process will automatically issue a change MTU request.
Fix this by not processing fatal error reset if CRQ is passively
initialized after client-driven CRQ initialization fails."

Even with this commit, we still see similar kernel crashes. In order
to completely solve this problem, we'd better continue the fatal error
reset, capture the kernel crash, and try to fix it from that end.

Fixes: f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Link: https://lore.kernel.org/r/20201219214034.21123-1-ljp@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2248,8 +2248,7 @@ static void __ibmvnic_reset(struct work_
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
-		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
-				adapter->from_passive_init)) {
+		} else {
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);


