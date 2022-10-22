Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04107608935
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJVIbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbiJVIa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:30:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BBA2D083A;
        Sat, 22 Oct 2022 01:02:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B26D9B82E13;
        Sat, 22 Oct 2022 08:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4BEC433D7;
        Sat, 22 Oct 2022 08:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425713;
        bh=YIPJ25ERBUQJfRKFkqLFPqinasOAti3V9lF/D6mb+20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grFDLCm+K4jFQPVXID7HwcI0Uo1fFcl+A9KMHu0ecqMUDlhbQBTz9Ws8+/1e9s5wM
         A07psv6vHoX6tSILoX4G6ZIYosgRymq5a1aNT7niMo5KuXm8dls8bP5X4+8uEYo440
         sdwA8RlXao0YrpGdGk+zpgM/7B4PegBVExhzPivU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Pattrick <mkp@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 561/717] openvswitch: Fix double reporting of drops in dropwatch
Date:   Sat, 22 Oct 2022 09:27:20 +0200
Message-Id: <20221022072523.192986693@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Pattrick <mkp@redhat.com>

[ Upstream commit 1100248a5c5ccd57059eb8d02ec077e839a23826 ]

Frames sent to userspace can be reported as dropped in
ovs_dp_process_packet, however, if they are dropped in the netlink code
then netlink_attachskb will report the same frame as dropped.

This patch checks for error codes which indicate that the frame has
already been freed.

Signed-off-by: Mike Pattrick <mkp@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2109946
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 6c9d153afbee..b68ba3c72519 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -252,10 +252,17 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 
 		upcall.mru = OVS_CB(skb)->mru;
 		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
-		if (unlikely(error))
-			kfree_skb(skb);
-		else
+		switch (error) {
+		case 0:
+		case -EAGAIN:
+		case -ERESTARTSYS:
+		case -EINTR:
 			consume_skb(skb);
+			break;
+		default:
+			kfree_skb(skb);
+			break;
+		}
 		stats_counter = &stats->n_missed;
 		goto out;
 	}
-- 
2.35.1



