Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4694E93FB
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbiC1LZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbiC1LZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:25:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062B65F87;
        Mon, 28 Mar 2022 04:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2E87B80EAE;
        Mon, 28 Mar 2022 11:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE36EC36AE3;
        Mon, 28 Mar 2022 11:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466589;
        bh=2S2WN7lbSNG7gDajWPNwg0YM4+H6wviOd9QuIF14ciY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHxUw7EqBviZo/LHlU6o3+zA+JL1VuPMNDMKuQDddKAf1hhJfs61rHmj8+0jbFI0a
         rStMKc9aHPMvumr69CwOeYj0QOc3q516mQVP3iOwo7Sh3QCv6yBGDuPP/yKCNCjdbf
         u0q9DpGEc0PrkPF8rq3Da+2SNKYENYnld3v11yPu7y2x1HEVu9qOolEfl9R8gf56a3
         ZNTkPmtG4mhPChDcw3EuEzBd45P3/Ie1bjoL1bzOSLQCDKxhJ07lR4gXTQ88cVQW0j
         SMASw1D8bz1wNYRcP4vSlPlVvwUA5YRaNSScKDjkkuFc9SP8Ga+cGreOHR2UDa+LxN
         4Ra7BkAMQo1Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/21] selinux: use correct type for context length
Date:   Mon, 28 Mar 2022 07:22:39 -0400
Message-Id: <20220328112254.1556286-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112254.1556286-1-sashal@kernel.org>
References: <20220328112254.1556286-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit b97df7c098c531010e445da88d02b7bf7bf59ef6 ]

security_sid_to_context() expects a pointer to an u32 as the address
where to store the length of the computed context.

Reported by sparse:

    security/selinux/xfrm.c:359:39: warning: incorrect type in arg 4
                                    (different signedness)
    security/selinux/xfrm.c:359:39:    expected unsigned int
                                       [usertype] *scontext_len
    security/selinux/xfrm.c:359:39:    got int *

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
[PM: wrapped commit description]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/xfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 7314196185d1..00e95f8bd7c7 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -346,7 +346,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 	int rc;
 	struct xfrm_sec_ctx *ctx;
 	char *ctx_str = NULL;
-	int str_len;
+	u32 str_len;
 
 	if (!polsec)
 		return 0;
-- 
2.34.1

