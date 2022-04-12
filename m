Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8984FD00C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiDLGlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245566AbiDLGkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D591A377D4;
        Mon, 11 Apr 2022 23:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7474F61890;
        Tue, 12 Apr 2022 06:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E50EC385A1;
        Tue, 12 Apr 2022 06:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745337;
        bh=ebqmPI9QBsvnd/i0AlzmYA6z6zPq8pJ2MHIxdXg4m8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHPwnmlfPNT/e/33mJXmn2AKC4/xpIdypBOtlrBtlRWJm79HrjZNzzssgYDZweV33
         8m/z/s8a6STDNcqht7i1c0hSBFp6YIB9XcCel3q1pyyPgmvfTjV4Byh9WarilzkiCk
         jAWOWUc1cEqleF8d8abGwr9/eo3B1JzxJlte/VIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Shuklin <george.shuklin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/171] net: account alternate interface name memory
Date:   Tue, 12 Apr 2022 08:29:12 +0200
Message-Id: <20220412062929.648234642@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5d26cff5bdbebdf98ba48217c078ff102536f134 ]

George reports that altnames can eat up kernel memory.
We should charge that memory appropriately.

Reported-by: George Shuklin <george.shuklin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9ff6d4160dab..77b3d9cc08a1 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3632,7 +3632,7 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 	if (err)
 		return err;
 
-	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
 
-- 
2.35.1



