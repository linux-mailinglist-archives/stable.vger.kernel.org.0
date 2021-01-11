Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167292F160C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbhAKNsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:48:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731159AbhAKNKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1995D227C3;
        Mon, 11 Jan 2021 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370606;
        bh=hLLzEPQY8VAY5q5euyvIb5OFtst85ZLzRA/q33b3Yfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+ikz1aA3fIbsssvW68Tmz+2e1npQAPNhdObwvDYoInMv5Vbyl+BuXvnTtHqekihN
         fuVeqHt0K3ecfffy/TKFOe89JuLPpYoWrp4qzQwAGG/2KvS3FAbqU4kuPkdpwL9FlA
         piPrrJ9BsHbq4UCpy2MCV/QooHmaz/XYIoZDsz18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 19/92] ibmvnic: continue fatal error reset after passive init
Date:   Mon, 11 Jan 2021 14:01:23 +0100
Message-Id: <20210111130040.084133057@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
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
@@ -2152,8 +2152,7 @@ static void __ibmvnic_reset(struct work_
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
-		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
-				adapter->from_passive_init)) {
+		} else {
 			rc = do_reset(adapter, rwi, reset_state);
 		}
 		kfree(rwi);


