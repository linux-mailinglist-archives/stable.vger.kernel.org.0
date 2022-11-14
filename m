Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646E8628061
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiKNNFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbiKNNF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121B92A707
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C13BEB80EB8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0EDC433D6;
        Mon, 14 Nov 2022 13:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431122;
        bh=34We7NeJxOWKK6/o/I0v9/bqmfoYv7XgHgrCfkc5CSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wM5gh9VaxB09vqQkYIaoG7VXSAg00Lcr3higYjt8hBUFI8dlm6/tikSFBEt0Phhbm
         hqtj4CzTfCtl6rKndKB1OBDBtFIDkIqwPOu8atrSXW7HsTKPKYbShHtrR8/3jcCkVU
         N17/WAWFCmKeZRT/XfldfnXtTfOWeDQg/nkbbS44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 079/190] netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()
Date:   Mon, 14 Nov 2022 13:45:03 +0100
Message-Id: <20221114124502.135541893@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index 9c44518cb70f..6d18fb346868 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -294,6 +294,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			nfnl_lock(subsys_id);
 			if (nfnl_dereference_protected(subsys_id) != ss ||
 			    nfnetlink_find_client(type, ss) != nc) {
+				nfnl_unlock(subsys_id);
 				err = -EAGAIN;
 				break;
 			}
-- 
2.35.1



