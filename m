Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF274FD722
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352030AbiDLHdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354736AbiDLH0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C51246B20;
        Tue, 12 Apr 2022 00:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC4FDB81B4F;
        Tue, 12 Apr 2022 07:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41C7C385A1;
        Tue, 12 Apr 2022 07:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747189;
        bh=blGm2AT+cTPGsrJEUISAdrsP2vZTBXy06uJ2DzObYds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHtEH8mewo7ghXeJhZS8POGc26y3Okkoh8ULsCmUqQ/MioWjgX654oWbxUA+9vHEk
         /oX9QJ797CXD/ISwYuFzMAigizYSZqwaA/TCv2Q+RtXArXfJQOJthAvp3ZeUq5ZoyS
         bQYks7aPXTvk708FF044yyFnUoVwf1jl/Mb9NCFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Zhong <yang.zhong@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <bonzini@gnu.org>
Subject: [PATCH 5.16 274/285] x86/fpu/xstate: Fix the ARCH_REQ_XCOMP_PERM implementation
Date:   Tue, 12 Apr 2022 08:32:11 +0200
Message-Id: <20220412062951.564252341@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Yang Zhong <yang.zhong@intel.com>

commit 063452fd94d153d4eb38ad58f210f3d37a09cca4 upstream.

ARCH_REQ_XCOMP_PERM is supposed to add the requested feature to the
permission bitmap of thread_group_leader()->fpu. But the code overwrites
the bitmap with the requested feature bit only rather than adding it.

Fix the code to add the requested feature bit to the master bitmask.

Fixes: db8268df0983 ("x86/arch_prctl: Add controls for dynamic XSTATE components")
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <bonzini@gnu.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220129173647.27981-2-chang.seok.bae@intel.com
[chang: Backport for 5.16]
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1626,7 +1626,7 @@ static int __xstate_request_perm(u64 per
 		return ret;
 
 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
-	WRITE_ONCE(fpu->perm.__state_perm, requested);
+	WRITE_ONCE(fpu->perm.__state_perm, mask);
 	/* Protected by sighand lock */
 	fpu->perm.__state_size = ksize;
 	fpu->perm.__user_state_size = usize;


