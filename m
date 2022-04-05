Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7939C4F4439
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382537AbiDEMPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243433AbiDEKfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8933553A5A;
        Tue,  5 Apr 2022 03:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27321616D7;
        Tue,  5 Apr 2022 10:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3039CC385A0;
        Tue,  5 Apr 2022 10:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154096;
        bh=OBxEfYhzCvPlaf1L8GH5GI+UgRcsxLFcLA/QQnqss/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=navi5g8U91wKpNL25InKqGaL8Bgil18xoZieAAafkVhvF2YTNeH4sP09jBVCDuMuY
         oUAIAuvJDAhBaGn9xwpcHNW6zjLltBL/DGYKCc8uj3PzBbtfoV+LWHHfBlRjj+ZgOs
         skwTCsDgVmzASWDncwOuH/lNcSerIneRe4hrBHBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 457/599] Fix incorrect type in assignment of ipv6 port for audit
Date:   Tue,  5 Apr 2022 09:32:31 +0200
Message-Id: <20220405070312.429644357@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 5c90b9fa4d40..b36b8668f1f4 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2506,7 +2506,7 @@ static int smk_ipv6_check(struct smack_known *subject,
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



