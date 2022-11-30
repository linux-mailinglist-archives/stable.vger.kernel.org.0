Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9527E63DDAA
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiK3S3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiK3S3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:29:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5C78BD17
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8561B81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252B1C433D6;
        Wed, 30 Nov 2022 18:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832960;
        bh=MParWbmd7+bweXazyzr3Uficig2HbVrkR/7htE4luG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIRtaAhRLWaID754H6AAQgVEOHjwSIo33kH7elsrVpufw3RX1xLNeiNM6TfgKzAL8
         goD4nuSw7gltnSUlt4LRNS/IuW2nKJPLyhSVoHZuLs4sgKaV4DXyrcF9RSRCSVqSsq
         6pJDt9qO4s8MMJFQQB0YpHaGVSxpJWUJEN1Udrbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/162] net: sched: allow act_ct to be built without NF_NAT
Date:   Wed, 30 Nov 2022 19:22:35 +0100
Message-Id: <20221130180530.513694824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8427fd100c7b7793650e212a81e42f1cf124613d ]

In commit f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT"),
it fixed the build failure when NF_NAT is m and NET_ACT_CT is y by
adding depends on NF_NAT for NET_ACT_CT. However, it would also cause
NET_ACT_CT cannot be built without NF_NAT, which is not expected. This
patch fixes it by changing to use "(!NF_NAT || NF_NAT)" as the depend.

Fixes: f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/b6386f28d1ba34721795fb776a91cbdabb203447.1668807183.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index d762e89ab74f..bc4e5da76fa6 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -976,7 +976,7 @@ config NET_ACT_TUNNEL_KEY
 
 config NET_ACT_CT
 	tristate "connection tracking tc action"
-	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
+	depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT) && NF_FLOW_TABLE
 	help
 	  Say Y here to allow sending the packets to conntrack module.
 
-- 
2.35.1



