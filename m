Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64685B70DB
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiIMOcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbiIMOcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:32:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D035EDF1;
        Tue, 13 Sep 2022 07:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6F17B80F01;
        Tue, 13 Sep 2022 14:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC9FC433D6;
        Tue, 13 Sep 2022 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078620;
        bh=jOv8v60wKjLg//lVQgOMfjenwYCSv7sZQmxfzg2d6BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBlOtCKPVAylC/mxqICOPx3t+HvC1CkM63vl1Jt7gDaUiAczmALpKa1IR4fF4bzbS
         uTpYB7XhSO5TRHNKspgnZfav4aw3SP/54RciQTDTeqT27hEJsxaPCEM6MtZdDNswmp
         eq5iFaW7D/w9HtWyMM3sJxCk1HkS8aQEB54pZ4no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/121] arm64/signal: Raise limit on stack frames
Date:   Tue, 13 Sep 2022 16:03:30 +0200
Message-Id: <20220913140358.164630048@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 7ddcaf78e93c9282b4d92184f511b4d5bee75355 ]

The signal code has a limit of 64K on the size of a stack frame that it
will generate, if this limit is exceeded then a process will be killed if
it receives a signal. Unfortunately with the advent of SME this limit is
too small - the maximum possible size of the ZA register alone is 64K. This
is not an issue for practical systems at present but is easily seen using
virtual platforms.

Raise the limit to 256K, this is substantially more than could be used by
any current architecture extension.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220817182324.638214-2-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index b3e1beccf4588..8fdb89afd2b85 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -91,7 +91,7 @@ static size_t sigframe_size(struct rt_sigframe_user_layout const *user)
  * not taken into account.  This limit is not a guarantee and is
  * NOT ABI.
  */
-#define SIGFRAME_MAXSZ SZ_64K
+#define SIGFRAME_MAXSZ SZ_256K
 
 static int __sigframe_alloc(struct rt_sigframe_user_layout *user,
 			    unsigned long *offset, size_t size, bool extend)
-- 
2.35.1



