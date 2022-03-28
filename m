Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449704E94B0
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbiC1Lbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbiC1Lax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DED56C2E;
        Mon, 28 Mar 2022 04:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E0D61195;
        Mon, 28 Mar 2022 11:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25279C340EC;
        Mon, 28 Mar 2022 11:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466662;
        bh=sxBywIbmDzdEuccwtVSS+3Adnpc3kzgA4oswz3VyPA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO5MfwtiyUU93fLi55aEmsB1epiVTh0Y9+FQ4mqN+BZ3STjD2a6Wa8qhD65KViwSN
         kbmlO3NkBFq1SLQLaGL4+6NthA+P2Yaj33AZf0ATrjVqJCsTmE4eIbDR4odkwgPHIq
         SNKGWbE936KrQnJo5FDVwkni2wFNvr2T956iGNAK9NfQp5N9ljoVhz8zpeRHh0fL5t
         lcEoqKTqRn0wQIUINT9hxGFRON7fTm3ZvfttQVhtFBkS5W/xJdlWxn8UEpb5wDCgEu
         PMq//MRex/CrrcmLL0e08Q5XKJE7oeD9ywsSnn/n12uLhfQKzW+B3hCdrSM0L5qXsl
         ii7q4dbUZ6QMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, jmorris@namei.org,
        serge@hallyn.com, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/12] Fix incorrect type in assignment of ipv6 port for audit
Date:   Mon, 28 Mar 2022 07:24:08 -0400
Message-Id: <20220328112417.1556946-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112417.1556946-1-sashal@kernel.org>
References: <20220328112417.1556946-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 221de4c755c3..4f65d953fe31 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2586,7 +2586,7 @@ static int smk_ipv6_check(struct smack_known *subject,
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

