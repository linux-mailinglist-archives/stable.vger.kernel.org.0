Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4150557DE9D
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiGVJ1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbiGVJ1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:27:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E57CB75E;
        Fri, 22 Jul 2022 02:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 833A8B827BE;
        Fri, 22 Jul 2022 09:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAFAC341C6;
        Fri, 22 Jul 2022 09:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481420;
        bh=N7xRo/S7eUzo2YjbTTxDeIjczUHyBLeWeth9bT8iJ9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJBbh2/vuYN2ZUj1ULpSSI5wpzVU592KPg34QkxBpAS/lO7U4NAaRa3bFdjAgg/CT
         4xBAfBfhZ7iq5v5vjsJCgjXQACfXsKrEkQw082UXzYDkNLmMLZonf52F/ZNv8Tr453
         gU36VVhG7zB5WRqPfA58QRZdSep/jFUxcErTchl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 61/89] x86/speculation: Fix SPEC_CTRL write on SMT state change
Date:   Fri, 22 Jul 2022 11:11:35 +0200
Message-Id: <20220722091136.770741443@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 56aa4d221f1ee2c3a49b45b800778ec6e0ab73c5 upstream.

If the SMT state changes, SSBD might get accidentally disabled.  Fix
that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1451,7 +1451,8 @@ static void __init spectre_v2_select_mit
 
 static void update_stibp_msr(void * __unused)
 {
-	write_spec_ctrl_current(x86_spec_ctrl_base, true);
+	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
+	write_spec_ctrl_current(val, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */


