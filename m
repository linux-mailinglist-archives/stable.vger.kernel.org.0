Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0ABC4B4B78
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbiBNKCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345248AbiBNKBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A2F13EAC;
        Mon, 14 Feb 2022 01:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E4A461252;
        Mon, 14 Feb 2022 09:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC4DC340E9;
        Mon, 14 Feb 2022 09:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832056;
        bh=0y/IZM+9R7R9WIPYSINAAR4GixoHnxscFamQq446Yng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzZeL5HBiUnfz8QblB/gFcD9v1E5irTq1FZBlmGyy3xAq8AdlIZI92EnJqfmYsh3L
         WRF4iVIBpCT6EaQeEw0mEK2Q9+ieMAyFwf5EIxw/O4q2E0quoF3KHnKB0BdpwmN5Pz
         iknoeDhPdLgkAbrpTC4SQfL3GDL1NlMk74UVjvLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/172] sunrpc: Fix potential race conditions in rpc_sysfs_xprt_state_change()
Date:   Mon, 14 Feb 2022 10:24:52 +0100
Message-Id: <20220214092507.574818221@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 1a48db3fef499f615b56093947ec4b0d3d8e3021 ]

We need to use test_and_set_bit() when changing xprt state flags to
avoid potentially getting xps->xps_nactive out of sync.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sysfs.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 379cf0e4d965b..326a31422a3c1 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -305,25 +305,28 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 		goto release_tasks;
 	}
 	if (offline) {
-		set_bit(XPRT_OFFLINE, &xprt->state);
-		spin_lock(&xps->xps_lock);
-		xps->xps_nactive--;
-		spin_unlock(&xps->xps_lock);
+		if (!test_and_set_bit(XPRT_OFFLINE, &xprt->state)) {
+			spin_lock(&xps->xps_lock);
+			xps->xps_nactive--;
+			spin_unlock(&xps->xps_lock);
+		}
 	} else if (online) {
-		clear_bit(XPRT_OFFLINE, &xprt->state);
-		spin_lock(&xps->xps_lock);
-		xps->xps_nactive++;
-		spin_unlock(&xps->xps_lock);
+		if (test_and_clear_bit(XPRT_OFFLINE, &xprt->state)) {
+			spin_lock(&xps->xps_lock);
+			xps->xps_nactive++;
+			spin_unlock(&xps->xps_lock);
+		}
 	} else if (remove) {
 		if (test_bit(XPRT_OFFLINE, &xprt->state)) {
-			set_bit(XPRT_REMOVE, &xprt->state);
-			xprt_force_disconnect(xprt);
-			if (test_bit(XPRT_CONNECTED, &xprt->state)) {
-				if (!xprt->sending.qlen &&
-				    !xprt->pending.qlen &&
-				    !xprt->backlog.qlen &&
-				    !atomic_long_read(&xprt->queuelen))
-					rpc_xprt_switch_remove_xprt(xps, xprt);
+			if (!test_and_set_bit(XPRT_REMOVE, &xprt->state)) {
+				xprt_force_disconnect(xprt);
+				if (test_bit(XPRT_CONNECTED, &xprt->state)) {
+					if (!xprt->sending.qlen &&
+					    !xprt->pending.qlen &&
+					    !xprt->backlog.qlen &&
+					    !atomic_long_read(&xprt->queuelen))
+						rpc_xprt_switch_remove_xprt(xps, xprt);
+				}
 			}
 		} else {
 			count = -EINVAL;
-- 
2.34.1



