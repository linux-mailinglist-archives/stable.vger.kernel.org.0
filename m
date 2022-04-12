Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC124FD43C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350670AbiDLH2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354089AbiDLHRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ECD4AE22;
        Mon, 11 Apr 2022 23:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCE0961589;
        Tue, 12 Apr 2022 06:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EFCC385A1;
        Tue, 12 Apr 2022 06:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746692;
        bh=OUlAb3UGaOKkAhEIqpIsvBCTN/p5eXDozdHw2+Y4nRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQEqslw67f3GguLNQfII2qrgMlds7XHFEesGtZX7JXD/lgglcmn5eatBX0K/eeSpc
         2KICodIuEmMpaulCp3PKZw6jQdGHReHq+xwKWN6dGhSDBgL7m2cctR3UzYYLyZG9Ni
         kSiTKQwD6TTeVh6D8O4gfSb1NxZ26SB5iW+4GkA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Shuklin <george.shuklin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 096/285] net: account alternate interface name memory
Date:   Tue, 12 Apr 2022 08:29:13 +0200
Message-Id: <20220412062946.436406625@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
index 8b5c5703d758..6a7883ec0489 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3637,7 +3637,7 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 	if (err)
 		return err;
 
-	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
 
-- 
2.35.1



