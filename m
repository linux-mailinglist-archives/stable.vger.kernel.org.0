Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B875A49D8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiH2LaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiH2L3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419BC11A0A;
        Mon, 29 Aug 2022 04:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4050B611D7;
        Mon, 29 Aug 2022 11:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C84DC433C1;
        Mon, 29 Aug 2022 11:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771817;
        bh=wp8U55d9Kn/DhgG7ZOW5xFAZkn6AbrlvNfjNqkzEp4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mmCE+dk0TFIhYq+TIXPOd9+WIz4qflrFNqOGSszNuJhLX29oVb9dfyJGpZg7sgv1
         aOiI8qBLE1EYN49qrLuqp5qZkQ44y+6DRBp0vtSfKgEpretrkC0a0StHmYsjPiWKXS
         MwkAPsbaym0DEUXVRY9FThZrMQlqIkopvOSx8IFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 080/158] net: Fix a data-race around netdev_unregister_timeout_secs.
Date:   Mon, 29 Aug 2022 12:58:50 +0200
Message-Id: <20220829105812.403037195@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 05e49cfc89e4f325eebbc62d24dd122e55f94c23 ]

While reading netdev_unregister_timeout_secs, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 19baeaf65a646..a77a979a4bf75 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10265,7 +10265,7 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
 				return dev;
 
 		if (time_after(jiffies, warning_time +
-			       netdev_unregister_timeout_secs * HZ)) {
+			       READ_ONCE(netdev_unregister_timeout_secs) * HZ)) {
 			list_for_each_entry(dev, list, todo_list) {
 				pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 					 dev->name, netdev_refcnt_read(dev));
-- 
2.35.1



