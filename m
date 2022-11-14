Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E8C627F1D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbiKNMzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbiKNMzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:55:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D1A27B1E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7C1CB80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65F1C433C1;
        Mon, 14 Nov 2022 12:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430534;
        bh=wXUUY/9VD2+ChxNAIxXUTO6bsxV2DpLuSXvu3t2Mj40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VD3fHdf1fR6VShHATKAzRUXJIffjQGjfhkRVK7e54xzxLEcK7gW0vWLX3YwVDVmxv
         aC+dj75NxS7Ohi/oAAckwW2IKH7KXgV3T0BtwpoOJUG6s5KUY29Hl6Xy/CcjuDAQ3P
         wXCd1G2yWqeJUTxklvItB0UAl6n0JVF6473fSaI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/131] netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()
Date:   Mon, 14 Nov 2022 13:45:25 +0100
Message-Id: <20221114124451.091785656@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 03832a32bf8ff0a8305d94ddd3979835a807248f ]

When type is NFNL_CB_MUTEX and -EAGAIN error occur in nfnetlink_rcv_msg(),
it does not execute nfnl_unlock(). That would trigger potential dead lock.

Fixes: 50f2db9e368f ("netfilter: nfnetlink: consolidate callback types")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7e2c8dd01408..2cce4033a70a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -290,6 +290,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			nfnl_lock(subsys_id);
 			if (nfnl_dereference_protected(subsys_id) != ss ||
 			    nfnetlink_find_client(type, ss) != nc) {
+				nfnl_unlock(subsys_id);
 				err = -EAGAIN;
 				break;
 			}
-- 
2.35.1



