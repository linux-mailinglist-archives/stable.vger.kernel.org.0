Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EBB498D79
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351928AbiAXTca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57036 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352064AbiAXT3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:29:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF356135E;
        Mon, 24 Jan 2022 19:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3EDC340E5;
        Mon, 24 Jan 2022 19:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052572;
        bh=ETqpcHCICc1tUB+WtR27CydYwT/UiM3pGK7XK2NBSNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFvpbW7wDgl/qFmbFcFK83tze/6thQYC5IyZ3jUj19NO7TcbpnxVXBx0dev5HjZ1P
         5FhDzMbXJ6qcX87J4RoKH7c6nvGOHoPJmgubpeNLYnzaXQKZV9JMnYHkfOcKy2qeNq
         DEa79Gyy9z/w+UW4dsDcFbGeaZaRm+RbTFziEWYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/320] rocker: fix a sleeping in atomic bug
Date:   Mon, 24 Jan 2022 19:41:28 +0100
Message-Id: <20220124183957.261941057@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 43d012123122cc69feacab55b71369f386c19566 ]

This code is holding the &ofdpa->flow_tbl_lock spinlock so it is not
allowed to sleep.  That means we have to pass the OFDPA_OP_FLAG_NOWAIT
flag to ofdpa_flow_tbl_del().

Fixes: 936bd486564a ("rocker: use FIB notifications instead of switchdev calls")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_ofdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 7072b249c8bd6..8157666209798 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2795,7 +2795,8 @@ static void ofdpa_fib4_abort(struct rocker *rocker)
 		if (!ofdpa_port)
 			continue;
 		nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-		ofdpa_flow_tbl_del(ofdpa_port, OFDPA_OP_FLAG_REMOVE,
+		ofdpa_flow_tbl_del(ofdpa_port,
+				   OFDPA_OP_FLAG_REMOVE | OFDPA_OP_FLAG_NOWAIT,
 				   flow_entry);
 	}
 	spin_unlock_irqrestore(&ofdpa->flow_tbl_lock, flags);
-- 
2.34.1



