Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9240E5FB667
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiJKPES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJKPCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9275A3F47;
        Tue, 11 Oct 2022 07:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A7D611C1;
        Tue, 11 Oct 2022 14:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5B8C433D7;
        Tue, 11 Oct 2022 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500007;
        bh=4jU+b9rw56L/HuCT8xKDJBBo+NptefMm9VOF60OgbkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKMCmofiRdUNW92rc3wjox6BEb1OeVMZuGQim//b6ozke4JrRvNOlMaQwN8JfzQa3
         t2p0EtnxctnBxwgpFuLHgNmCL9EY1bWeMjVY9Qd3GrIzG70WJyI7VUpeq8DpZVgOb6
         ndRPHQCVQzQSEFgGcHXnJ/ZtOSzIt7DOBW5r+8ZkXIkcd4tbmTD9qXnL+o37vDZXfn
         fgYhM212kYem/4oXvRC7oTur24BPv1lP2lO8L0Brw2h8Qq88z6sgrRTCszhFikf3iB
         k2HB1VUTxPvTM55Kl/tq4n8X1urhClW58bKGuz/iYmi9LsuC87AR0i6h/ut6LQrsy9
         WeOJoAk1XYE7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/17] kselftest/arm64: Fix validatation termination record after EXTRA_CONTEXT
Date:   Tue, 11 Oct 2022 10:53:05 -0400
Message-Id: <20221011145312.1624341-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145312.1624341-1-sashal@kernel.org>
References: <20221011145312.1624341-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 5c152c2f66f9368394b89ac90dc7483476ef7b88 ]

When arm64 signal context data overflows the base struct sigcontext it gets
placed in an extra buffer pointed to by a record of type EXTRA_CONTEXT in
the base struct sigcontext which is required to be the last record in the
base struct sigframe. The current validation code attempts to check this
by using GET_RESV_NEXT_HEAD() to step forward from the current record to
the next but that is a macro which assumes it is being provided with a
struct _aarch64_ctx and uses the size there to skip forward to the next
record. Instead validate_extra_context() passes it a struct extra_context
which has a separate size field. This compiles but results in us trying
to validate a termination record in completely the wrong place, at best
failing validation and at worst just segfaulting. Fix this by passing
the struct _aarch64_ctx we meant to into the macro.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220829160703.874492-4-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/testcases/testcases.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
index 61ebcdf63831..a3ac5c2d8aac 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
@@ -33,7 +33,7 @@ bool validate_extra_context(struct extra_context *extra, char **err)
 		return false;
 
 	fprintf(stderr, "Validating EXTRA...\n");
-	term = GET_RESV_NEXT_HEAD(extra);
+	term = GET_RESV_NEXT_HEAD(&extra->head);
 	if (!term || term->magic || term->size) {
 		*err = "Missing terminator after EXTRA context";
 		return false;
-- 
2.35.1

