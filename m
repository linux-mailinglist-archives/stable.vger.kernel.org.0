Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730A24F32AF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbiDEJxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243418AbiDEJI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE69F6E5;
        Tue,  5 Apr 2022 01:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F78461574;
        Tue,  5 Apr 2022 08:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94805C385A0;
        Tue,  5 Apr 2022 08:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149083;
        bh=nTo5q30PPqsFi2+GkQvzuK8vFIkgLEuVQEnryNps5rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/V/U6o5xam35r3g8pxq0dbkYh1i1iIT57o1bcc5jFha/ZJCDQwSMfwqZ7XToS+Bh
         61e2Wj7KN6ZqVhC3MOHvp7jKMMJ1VLGnKvDKP6tal3nawtbDVIdFKTMOPDLBdp5qbA
         ok+fAm1Oydt4bvYcflpnmGdRBOnPcrVigYokeb9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0587/1017] xtensa: add missing XCHAL_HAVE_WINDOWED check
Date:   Tue,  5 Apr 2022 09:25:00 +0200
Message-Id: <20220405070411.703420324@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 8c9ab55c0fbdc76cb876140c2dad75a610bb23ef ]

Add missing preprocessor conditions to secondary reset vector code.

Fixes: 09af39f649da ("xtensa: use register window specific opcodes only when present")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/mxhead.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/xtensa/kernel/mxhead.S b/arch/xtensa/kernel/mxhead.S
index 9f3843742726..b702c0908b1f 100644
--- a/arch/xtensa/kernel/mxhead.S
+++ b/arch/xtensa/kernel/mxhead.S
@@ -37,11 +37,13 @@ _SetupOCD:
 	 * xt-gdb to single step via DEBUG exceptions received directly
 	 * by ocd.
 	 */
+#if XCHAL_HAVE_WINDOWED
 	movi	a1, 1
 	movi	a0, 0
 	wsr	a1, windowstart
 	wsr	a0, windowbase
 	rsync
+#endif
 
 	movi	a1, LOCKLEVEL
 	wsr	a1, ps
-- 
2.34.1



