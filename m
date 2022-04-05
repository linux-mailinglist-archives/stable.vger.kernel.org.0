Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63A84F2C67
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbiDEJED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241526AbiDEIs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A4929C9D;
        Tue,  5 Apr 2022 01:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5484B61515;
        Tue,  5 Apr 2022 08:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BEFC385A0;
        Tue,  5 Apr 2022 08:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147800;
        bh=YhiSsJ3TnEyST2jyx9qSBcFa+5qpcWGpbNlsUtKc+X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4yqA9CpyAwHLTrjq5C1PfgS8lzrdOhUOfmSmCGUDDt63wz31d0YS0xJv1ZbEUf8h
         +/qLAaDLnqmNSnI6FM6Zs6hj1D47jwrNoBX8uCE1VshpY9GD4pmfu9n62I43YBoF8S
         eiuYavGx7sSS/2ediLV0LKUrwOrGwSvKhQKCbfds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Engraf <david.engraf@sysgo.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 0127/1017] arm64: signal: nofpsimd: Do not allocate fp/simd context when not available
Date:   Tue,  5 Apr 2022 09:17:20 +0200
Message-Id: <20220405070357.969110479@linuxfoundation.org>
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


