Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165E860A49E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJXMNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiJXMM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:12:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0B6BFF;
        Mon, 24 Oct 2022 04:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5477E612C3;
        Mon, 24 Oct 2022 11:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64064C433D6;
        Mon, 24 Oct 2022 11:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612433;
        bh=T1RzVjYOnfsNgB+jghQGsmTf4DSzu07LR8BVos8WFwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yC4nDoDcChHXyCW70fXrotDveOrj3iQhI3DSika2TKySqv4SNdT4gW8YtyALvBp1Q
         b9af1PgrDoU4tFPlqbOSlyKT0nUMIwkbYVcF8lKkHljax6FxbR1/rt3NHfftooyNR+
         PQGFQLAHaM76hmJ7iZ9g7GZEflNL4Uqs/UwhxolA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Pattrick <mkp@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 169/210] openvswitch: Fix overreporting of drops in dropwatch
Date:   Mon, 24 Oct 2022 13:31:26 +0200
Message-Id: <20221024113002.443916899@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Pattrick <mkp@redhat.com>

[ Upstream commit c21ab2afa2c64896a7f0e3cbc6845ec63dcfad2e ]

Currently queue_userspace_packet will call kfree_skb for all frames,
whether or not an error occurred. This can result in a single dropped
frame being reported as multiple drops in dropwatch. This functions
caller may also call kfree_skb in case of an error. This patch will
consume the skbs instead and allow caller's to use kfree_skb.

Signed-off-by: Mike Pattrick <mkp@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2109957
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 42616aca0ce4..8319628ab428 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -553,8 +553,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 out:
 	if (err)
 		skb_tx_error(skb);
-	kfree_skb(user_skb);
-	kfree_skb(nskb);
+	consume_skb(user_skb);
+	consume_skb(nskb);
+
 	return err;
 }
 
-- 
2.35.1



