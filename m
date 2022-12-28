Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA934657E2E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiL1Pu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiL1Pu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:50:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9E917886
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A71DB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06622C433EF;
        Wed, 28 Dec 2022 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242654;
        bh=H7SQm+nsc6E7nY8m6I1Nzd5PkMSJcdD1Syg4IkKJv7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiu0x3y9v2k+3ufQ4mfihF5jYUb3heoqXpyiILSrSGxRILXoHQUTtD9PyKWOLIrIQ
         /yo16lrksjFqbuazUS1z/AyHQm0Dv2lnR7GwunOtdiZjc7g3YUGZPnOZicjMPuop1n
         qrCb4oY/mPuWxGfPjDfUsaOasqmII+hA0xCF6qzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0436/1073] wifi: mac80211: fix memory leak in ieee80211_if_add()
Date:   Wed, 28 Dec 2022 15:33:44 +0100
Message-Id: <20221228144339.869825563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293 ]

When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
isn't released. Fix it.

Fixes: 5a490510ba5f ("mac80211: use per-CPU TX/RX statistics")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221117064500.319983-1-shaozhengchao@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 95b58c5cac07..c3eb08b5a47e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2414,6 +2414,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
+			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
-- 
2.35.1



