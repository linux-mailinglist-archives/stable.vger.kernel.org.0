Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0905360425E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiJSLAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiJSK7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618B7169CC1;
        Wed, 19 Oct 2022 03:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 166E0B824A6;
        Wed, 19 Oct 2022 09:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C767C433D6;
        Wed, 19 Oct 2022 09:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170517;
        bh=F91BAdOXkp+xhwYRMD0QHptsZMxc0ARjOGzeltr8YbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORSPEH+lKHqonU4LO7/hZG2t52IKRnBr8Dy2BGItcLwQQCmT3RLhJ43BAf01or4XA
         0c20p5pP3OPUL2LTguWZ81aOGV620iC1QdkAIbDWbQcwxZlgk2EUPemuY81io8VLKs
         4s9PxUjBbir8tXK/kwZXMAaRtL2SwoGXLWcl509Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Pattrick <mkp@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 686/862] openvswitch: Fix overreporting of drops in dropwatch
Date:   Wed, 19 Oct 2022 10:32:53 +0200
Message-Id: <20221019083320.298823380@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b68ba3c72519..93c596e3b22b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -558,8 +558,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
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



