Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2665E5055EE
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239095AbiDRNbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244716AbiDRNat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF59C12ACD;
        Mon, 18 Apr 2022 05:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A94B60FD9;
        Mon, 18 Apr 2022 12:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61089C385A1;
        Mon, 18 Apr 2022 12:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286505;
        bh=zZZ8+bt+swbdKgisPUds2B86Lnz7Y1ZXyD/TXnFQ/U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2Kavqx0ww/l7t1HeOdcBSP7lGrYQoVgfNb0TqxU3GfscpHZ71071hzXi582w9gqH
         wP3Va7yMX78mDM96YtUu57Yq3p8PBeqS813l0N7CeGlhSTtxLj+yRMPiB9+EYFMRb6
         7jNu6RxkqwY10QlMb+iihTMwvlRrWUcdU9PWxTEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/284] selinux: use correct type for context length
Date:   Mon, 18 Apr 2022 14:12:16 +0200
Message-Id: <20220418121216.124701381@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



