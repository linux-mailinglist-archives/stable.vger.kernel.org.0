Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60197582C85
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbiG0Qrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240404AbiG0Qqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168775247D;
        Wed, 27 Jul 2022 09:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CCAB61A4F;
        Wed, 27 Jul 2022 16:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B00C433C1;
        Wed, 27 Jul 2022 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939509;
        bh=smYeKmamlWhHlqS80zNjKhdEHi3FB7mA4ILpi3O5Zzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM1FrO4C80moDNu+gMaG0FciS45KLeUhDNrlhmOAqs7zQXwLFjdxLD9uZgM7La90N
         V+B1IjiMTTAdg7NqYq8dcBvPFQ0tgavFd9RDRqLsr1qlKaQvnfSpGorhTMAx7TdY55
         WIjrfZ+96p3Gsb+AhFtUkWFYcfmGNI0/Ch/i8UX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 87/87] x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()
Date:   Wed, 27 Jul 2022 18:11:20 +0200
Message-Id: <20220727161012.576805216@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 1df931d95f4dc1c11db1123e85d4e08156e46ef9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -498,7 +498,7 @@ __pu_label:							\
 		       [ptr] "+m" (*_ptr),				\
 		       [old] "+a" (__old)				\
 		     : [new] ltype (__new)				\
-		     : "memory", "cc");					\
+		     : "memory");					\
 	if (unlikely(__err))						\
 		goto label;						\
 	if (unlikely(!success))						\


