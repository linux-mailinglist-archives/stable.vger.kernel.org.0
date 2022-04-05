Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAB14F3524
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242323AbiDEIhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238283AbiDEISr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD12CBF7;
        Tue,  5 Apr 2022 01:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CCC6093C;
        Tue,  5 Apr 2022 08:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59063C385A0;
        Tue,  5 Apr 2022 08:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146112;
        bh=nTo5q30PPqsFi2+GkQvzuK8vFIkgLEuVQEnryNps5rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOHzpQDE5HZDqO0IXHVRDrs0ASbqcVyt5JW5KIxle4yI6PZ38tWJO/svHt5v3y2O6
         jAL/aUhLS6PK/s5g09CzgAJcQFrkO+8XdFdIHlGqZI55qwq/DGTL/57QycPQDCy/G0
         4dOO6glPNORshA8Bp68L/oQ7H1goUggpm08q9jIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0648/1126] xtensa: add missing XCHAL_HAVE_WINDOWED check
Date:   Tue,  5 Apr 2022 09:23:15 +0200
Message-Id: <20220405070426.651837890@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



