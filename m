Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30655AAEDB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiIBMaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236632AbiIBM3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:29:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3B51A055;
        Fri,  2 Sep 2022 05:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FE8962136;
        Fri,  2 Sep 2022 12:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D96C433C1;
        Fri,  2 Sep 2022 12:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121448;
        bh=paKNAQeXMCDMISOWcxTEovCut/IjgSNxzq091djQun8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1Lbj4blNzhLvQ79UaqMErXFz9pbvFsCYwz0B5AfQyKGUssi7A3sgbVa5xTCh39H+
         O3BnnlB6Rs3goctJYVugj95xokBFf1K6lEmk/fSKKoAi2uQCvcGeUxbB8mjEqT5KMr
         1J3yLjlm+QGycJ816iV5kzQuUT9PJ2oQ4TDAy5pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernard Pidoux <f6bvp@free.fr>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Thomas DL9SAU Osterried <thomas@osterried.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/56] rose: check NULL rose_loopback_neigh->loopback
Date:   Fri,  2 Sep 2022 14:18:31 +0200
Message-Id: <20220902121400.564738562@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Pidoux <f6bvp@free.fr>

[ Upstream commit 3c53cd65dece47dd1f9d3a809f32e59d1d87b2b8 ]

Commit 3b3fd068c56e3fbea30090859216a368398e39bf added NULL check for
`rose_loopback_neigh->dev` in rose_loopback_timer() but omitted to
check rose_loopback_neigh->loopback.

It thus prevents *all* rose connect.

The reason is that a special rose_neigh loopback has a NULL device.

/proc/net/rose_neigh illustrates it via rose_neigh_show() function :
[...]
seq_printf(seq, "%05d %-9s %-4s   %3d %3d  %3s     %3s %3lu %3lu",
	   rose_neigh->number,
	   (rose_neigh->loopback) ? "RSLOOP-0" : ax2asc(buf, &rose_neigh->callsign),
	   rose_neigh->dev ? rose_neigh->dev->name : "???",
	   rose_neigh->count,

/proc/net/rose_neigh displays special rose_loopback_neigh->loopback as
callsign RSLOOP-0:

addr  callsign  dev  count use mode restart  t0  tf digipeaters
00001 RSLOOP-0  ???      1   2  DCE     yes   0   0

By checking rose_loopback_neigh->loopback, rose_rx_call_request() is called
even in case rose_loopback_neigh->dev is NULL. This repairs rose connections.

Verification with rose client application FPAC:

FPAC-Node v 4.1.3 (built Aug  5 2022) for LINUX (help = h)
F6BVP-4 (Commands = ?) : u
Users - AX.25 Level 2 sessions :
Port   Callsign     Callsign  AX.25 state  ROSE state  NetRom status
axudp  F6BVP-5   -> F6BVP-9   Connected    Connected   ---------

Fixes: 3b3fd068c56e ("rose: Fix Null pointer dereference in rose_send_frame()")
Signed-off-by: Bernard Pidoux <f6bvp@free.fr>
Suggested-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Thomas DL9SAU Osterried <thomas@osterried.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_loopback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index c318e5c9f6df3..56eea298b8ef7 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -99,7 +99,8 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}
 
 		if (frametype == ROSE_CALL_REQUEST) {
-			if (!rose_loopback_neigh->dev) {
+			if (!rose_loopback_neigh->dev &&
+			    !rose_loopback_neigh->loopback) {
 				kfree_skb(skb);
 				continue;
 			}
-- 
2.35.1



