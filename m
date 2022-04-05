Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26F84F414E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382726AbiDEMQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243874AbiDEKhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:37:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE576C941;
        Tue,  5 Apr 2022 03:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90412B81C8A;
        Tue,  5 Apr 2022 10:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EE0C385A0;
        Tue,  5 Apr 2022 10:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154195;
        bh=2S2WN7lbSNG7gDajWPNwg0YM4+H6wviOd9QuIF14ciY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFQ/WOFtuLo4sFFha0GnFN/OllAUWaSRU8IRN5Ymvx7uunBfYmZGYHLQ5+xDSLpjX
         cBt4Z2gQxJhMzrLgoEOvWDq6qIU4gTtsSydnAVOVLRWu2cJLxN3bad6I7b0lPSbfkW
         rStlfRqXKP074EkhPxjbGB55sW2mHModrJK8N9mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 454/599] selinux: use correct type for context length
Date:   Tue,  5 Apr 2022 09:32:28 +0200
Message-Id: <20220405070312.340632969@linuxfoundation.org>
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



