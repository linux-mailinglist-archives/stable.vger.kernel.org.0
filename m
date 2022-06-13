Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9C548769
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380460AbiFMN67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380007AbiFMNwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAC321B5;
        Mon, 13 Jun 2022 04:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8004B6124B;
        Mon, 13 Jun 2022 11:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64875C34114;
        Mon, 13 Jun 2022 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120011;
        bh=oxGTbtwvaj7U3xe6gnO0r+B1urpG/4/B1Kwal/S4P40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuQKBbbRnJwfghtd3zOoj9Ht6UixeFqyIj6LtrMZdSwoFTnaAELUGhHmJG3dGDniB
         DwEYqIeaTWJ+oSLBQ4GmIGuxRLmlZX3aR6OqDexkg2ou26O5LWgsaYJVkQg6zQh/Cu
         56598q2WL7uyHAzGMhX08dzTCIt77nSvWZiATACM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 199/339] x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()
Date:   Mon, 13 Jun 2022 12:10:24 +0200
Message-Id: <20220613094932.701407264@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 1df931d95f4dc1c11db1123e85d4e08156e46ef9 ]

As noted (and fixed) a couple of times in the past, "=@cc<cond>" outputs
and clobbering of "cc" don't work well together. The compiler appears to
mean to reject such, but doesn't - in its upstream form - quite manage
to yet for "cc". Furthermore two similar macros don't clobber "cc", and
clobbering "cc" is pointless in asm()-s for x86 anyway - the compiler
always assumes status flags to be clobbered there.

Fixes: 989b5db215a2 ("x86/uaccess: Implement macros for CMPXCHG on user addresses")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Message-Id: <485c0c0b-a3a7-0b7c-5264-7d00c01de032@suse.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 35f222aa66bf..913e593a3b45 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -439,7 +439,7 @@ do {									\
 		       [ptr] "+m" (*_ptr),				\
 		       [old] "+a" (__old)				\
 		     : [new] ltype (__new)				\
-		     : "memory", "cc");					\
+		     : "memory");					\
 	if (unlikely(__err))						\
 		goto label;						\
 	if (unlikely(!success))						\
-- 
2.35.1



