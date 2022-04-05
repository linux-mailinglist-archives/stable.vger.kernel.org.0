Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C504F38E6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377381AbiDEL24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349996AbiDEJwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:52:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968CC35DF4;
        Tue,  5 Apr 2022 02:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A455B81B76;
        Tue,  5 Apr 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF862C385A3;
        Tue,  5 Apr 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152216;
        bh=8rzxR8C9aV5joxDkLw1fv1HzRyps0zkC5tErCCANSjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ccg5LMaYYmbkTgTeLs7/ZmmtgUHBVOmwUbfcMaHcYuKuMxF7MxX3JP+hK+M/Ob4k6
         2ld7xLiZeJLF7PvQWFHD27MDvCoUd9uxmhA/R1E2jDznGQXmPftvR/6igKa4xgfrSg
         RqHc64e3IcMQFf94zw1hpeD7m0SOXqmPo6jK9xcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 696/913] Fix incorrect type in assignment of ipv6 port for audit
Date:   Tue,  5 Apr 2022 09:29:18 +0200
Message-Id: <20220405070400.697492322@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit a5cd1ab7ab679d252a6d2f483eee7d45ebf2040c ]

Remove inappropriate use of ntohs() and assign the
port value directly.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 21a0e7c3b8de..3f3f56f6be4d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2505,7 +2505,7 @@ static int smk_ipv6_check(struct smack_known *subject,
 #ifdef CONFIG_AUDIT
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 	ad.a.u.net->family = PF_INET6;
-	ad.a.u.net->dport = ntohs(address->sin6_port);
+	ad.a.u.net->dport = address->sin6_port;
 	if (act == SMK_RECEIVING)
 		ad.a.u.net->v6info.saddr = address->sin6_addr;
 	else
-- 
2.34.1



