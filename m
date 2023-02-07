Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89BF68D787
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjBGNBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjBGNBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C555139B9E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DC89B8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7802C433EF;
        Tue,  7 Feb 2023 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774824;
        bh=9Nnww4gVOtCn0x++Llj7t0hGkytjEwJegwNb4hHg1QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gs8w3MM9T8JCZbTrBSggH/7HrNK5SK3BZ6ZVE/jZW4Yhu7XrHKoH0msqI2ua9H5gZ
         LuhHV5oTyzH9P145jVyYyNcdNqYT2Ge0UaH0wqEG5sTuXYrlVMTQcGXRZunJY0oCVT
         1r2+4NIceVtkD4x0D6gS0+UblPBX4LLFaplBrIaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/208] skb: Do mix page pool and page referenced frags in GRO
Date:   Tue,  7 Feb 2023 13:54:59 +0100
Message-Id: <20230207125636.320473562@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 7d2c89b325874a35564db5630a459966afab04cc ]

GSO should not merge page pool recycled frames with standard reference
counted frames. Traditionally this didn't occur, at least not often.
However as we start looking at adding support for wireless adapters there
becomes the potential to mix the two due to A-MSDU repartitioning frames in
the receive path. There are possibly other places where this may have
occurred however I suspect they must be few and far between as we have not
seen this issue until now.

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Reported-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/167475990764.1934330.11960904198087757911.stgit@localhost.localdomain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index 1b4abfb9a7a1..352f966cb1da 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	struct sk_buff *lp;
 	int segs;
 
+	/* Do not splice page pool based packets w/ non-page pool
+	 * packets. This can result in reference count issues as page
+	 * pool pages will not decrement the reference count and will
+	 * instead be immediately returned to the pool or have frag
+	 * count decremented.
+	 */
+	if (p->pp_recycle != skb->pp_recycle)
+		return -ETOOMANYREFS;
+
 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
 	gro_max_size = READ_ONCE(p->dev->gro_max_size);
 
-- 
2.39.0



