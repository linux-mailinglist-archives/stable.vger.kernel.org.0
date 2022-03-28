Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFAA4E9519
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbiC1Lkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241902AbiC1Ld4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:33:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC835838F;
        Mon, 28 Mar 2022 04:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10AE2B81055;
        Mon, 28 Mar 2022 11:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ED7C340EC;
        Mon, 28 Mar 2022 11:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466698;
        bh=zZZ8+bt+swbdKgisPUds2B86Lnz7Y1ZXyD/TXnFQ/U8=;
        h=From:To:Cc:Subject:Date:From;
        b=g/68It5+Vs6MG/zmg69c4xiQcT/sMm5PMZEN7KjgFyVcQYS5xUa6vEPw+wUAt8vz0
         QgpoHAzegm/ikk8yqa2d2qINbFG7UDwtHdtVifr/bj4ttvT7NCFEL5azwcarp2DTjy
         L8rSeysTgjI3kFMeUNGprN0pVh49evl3Evwfwnj5/0bjw/9BT9TnlxcIkIN9gf6a4c
         P6I6h8pp6DHhMplM2/vij7BmMSVwkvB+5RPTIJNpwQhoA5SKXPpH7lHYOQaMi0kLRS
         5Swso7/524C/gpcp5ICcpjZPuRRzTF1etnaJcLGSgYXmtfIYUhbWB6rqu7ULusPb1f
         tqY0QMwlnSLuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/8] selinux: use correct type for context length
Date:   Mon, 28 Mar 2022 07:24:49 -0400
Message-Id: <20220328112456.1557226-1-sashal@kernel.org>
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
index 56e354fcdfc6..5304dd49e054 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -344,7 +344,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 	int rc;
 	struct xfrm_sec_ctx *ctx;
 	char *ctx_str = NULL;
-	int str_len;
+	u32 str_len;
 
 	if (!polsec)
 		return 0;
-- 
2.34.1

