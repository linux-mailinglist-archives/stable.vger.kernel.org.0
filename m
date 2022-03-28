Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF4C4E94B5
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbiC1Lb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241456AbiC1Lax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:30:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D656C2A;
        Mon, 28 Mar 2022 04:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB046CE12EF;
        Mon, 28 Mar 2022 11:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795A8C34110;
        Mon, 28 Mar 2022 11:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466660;
        bh=utaBIuZOLBtXiQN4N4Zh4kTBVWVw5hJbIvn9YJrb1B0=;
        h=From:To:Cc:Subject:Date:From;
        b=vR3TAlwEyggGr2rEKKMCrjSBP/eUHEOxTfurej2OaoxjH5gh2lVEIpPBg8JaF3hvI
         xE2HKQhnIYiIwyhbtby19ncUfcmBIDmj/LsIhEHUNZnQ4EJRFwNnBC7JGhM2Kt2ZOl
         eH697u2iHJeqmHko+z1XLd2RGRBespcLpUYmG9CR58hf+LdCEUlehMxj0vE0v488Dh
         i3Yc1M6BTAQZxZFl3oqzT4/mIrMVd3JjDLzA9AdsYgi+ZaaGeLJ2Ct00Y8MfzhlrPk
         OUUB3l8lQTWOY6JXOF9MWxWW2YBYcsYwbuQgL8GPPmWZ4S2POHDeckdH4LsSQ2pyHk
         I0pPrQezhTlzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/12] selinux: use correct type for context length
Date:   Mon, 28 Mar 2022 07:24:06 -0400
Message-Id: <20220328112417.1556946-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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
index 91dc3783ed94..9e803d2a687a 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -349,7 +349,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 	int rc;
 	struct xfrm_sec_ctx *ctx;
 	char *ctx_str = NULL;
-	int str_len;
+	u32 str_len;
 
 	if (!polsec)
 		return 0;
-- 
2.34.1

