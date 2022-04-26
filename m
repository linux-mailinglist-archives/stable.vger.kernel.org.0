Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4150F63B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345744AbiDZIwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346751AbiDZIuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBD9156E19;
        Tue, 26 Apr 2022 01:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EE5460A29;
        Tue, 26 Apr 2022 08:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1D6C385A0;
        Tue, 26 Apr 2022 08:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962330;
        bh=E3YA0VDkKR9MVzQZUwZQbMCrslKr57iOaOn7doSJ9vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rvvgv8eVzjyhHL/PssLzMXTlloXInxu7MSactj3fySNoKYcC9IS8LNevLzDq4FMX0
         j+TgEwfseiCghqMnLhzbNp0jFMMQK+sQsw2q1dve4v/36YghvShd3pI+k4x0Rq7n9K
         0RYfllRJSD8ZsIjdK+ZkfPm29w1Xdzevn/NDDeRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongbin Wang <wh_bin@126.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/124] vxlan: fix error return code in vxlan_fdb_append
Date:   Tue, 26 Apr 2022 10:21:01 +0200
Message-Id: <20220426081749.007506940@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongbin Wang <wh_bin@126.com>

[ Upstream commit 7cea5560bf656b84f9ed01c0cc829d4eecd0640b ]

When kmalloc and dst_cache_init failed,
should return ENOMEM rather than ENOBUFS.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 141635a35c28..129e270e9a7c 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -711,11 +711,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
 	rd = kmalloc(sizeof(*rd), GFP_ATOMIC);
 	if (rd == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
 		kfree(rd);
-		return -ENOBUFS;
+		return -ENOMEM;
 	}
 
 	rd->remote_ip = *ip;
-- 
2.35.1



