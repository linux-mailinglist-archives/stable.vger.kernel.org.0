Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0755D499AC4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347931AbiAXVqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456650AbiAXVjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296A1C0419C1;
        Mon, 24 Jan 2022 12:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAB0F61506;
        Mon, 24 Jan 2022 20:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2045C340E5;
        Mon, 24 Jan 2022 20:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055945;
        bh=Q3ypDHHx3RUbuMxMVkYb3TNXwem+cB96Bf8NslW8Bak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuY1FS2Sq8YEtRCP2/hIxoQ7mlHrf/koqdbwAKKFSIyszhvv2btwdIvg/2bY3UTRZ
         n4BO9bcnvTPD5A0qlXT8h/jmTWQWGSgHvYZEJgPuDlA1FBcvgbbUgjr0oSg8J+oz6J
         Pe4sZBeuxNnhiTsCGzqq8TU40uaFiOQAogMeXcyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/846] rocker: fix a sleeping in atomic bug
Date:   Mon, 24 Jan 2022 19:37:15 +0100
Message-Id: <20220124184111.873437874@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 3e1ca7a8d0295..bc70c6abd6a5b 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2783,7 +2783,8 @@ static void ofdpa_fib4_abort(struct rocker *rocker)
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



