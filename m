Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DF44F2C30
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiDEKin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiDEJeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B86D81671;
        Tue,  5 Apr 2022 02:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6BC61654;
        Tue,  5 Apr 2022 09:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC01C385A0;
        Tue,  5 Apr 2022 09:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150626;
        bh=YhiSsJ3TnEyST2jyx9qSBcFa+5qpcWGpbNlsUtKc+X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUmdYR+kaO+MlucACf7CXlHUw++biXoweDtnCyR7CivE6fQzPYLOjdWIIkTXT2imW
         g2MqE9A3ISLqEpHRPjBOPFTZD6hjYS35D37EwJrJjJpmm5ss73k+dvOF+ftJy5jmf3
         jQgo+Qd0fLxRCdkOc5/DIPY/56NSo/G6MZMr5sxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Engraf <david.engraf@sysgo.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 121/913] arm64: signal: nofpsimd: Do not allocate fp/simd context when not available
Date:   Tue,  5 Apr 2022 09:19:43 +0200
Message-Id: <20220405070343.454672916@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: David Engraf <david.engraf@sysgo.com>

commit 0a32c88ddb9af30e8a16d41d7b9b824c27d29459 upstream.

Commit 6d502b6ba1b2 ("arm64: signal: nofpsimd: Handle fp/simd context for
signal frames") introduced saving the fp/simd context for signal handling
only when support is available. But setup_sigframe_layout() always
reserves memory for fp/simd context. The additional memory is not touched
because preserve_fpsimd_context() is not called and thus the magic is
invalid.

This may lead to an error when parse_user_sigframe() checks the fp/simd
area and does not find a valid magic number.

Signed-off-by: David Engraf <david.engraf@sysgo.com>
Reviwed-by: Mark Brown <broonie@kernel.org>
Fixes: 6d502b6ba1b267b3 ("arm64: signal: nofpsimd: Handle fp/simd context for signal frames")
Cc: <stable@vger.kernel.org> # 5.6.x
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220225104008.820289-1-david.engraf@sysgo.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -577,10 +577,12 @@ static int setup_sigframe_layout(struct
 {
 	int err;
 
-	err = sigframe_alloc(user, &user->fpsimd_offset,
-			     sizeof(struct fpsimd_context));
-	if (err)
-		return err;
+	if (system_supports_fpsimd()) {
+		err = sigframe_alloc(user, &user->fpsimd_offset,
+				     sizeof(struct fpsimd_context));
+		if (err)
+			return err;
+	}
 
 	/* fault information, if valid */
 	if (add_all || current->thread.fault_code) {


