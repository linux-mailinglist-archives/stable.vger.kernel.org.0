Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEC9608B03
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJVJVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJVJUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:20:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8540FAE6A;
        Sat, 22 Oct 2022 01:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21BD460B90;
        Sat, 22 Oct 2022 08:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7CCC433D6;
        Sat, 22 Oct 2022 08:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425859;
        bh=xlDA8pfPkFAaw/9xQEsxhHEEkQh9btgLLPQGvlm7iec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UO3opyeNqpkRbFo8uZv86FTAJ+jr3Cia1hkvDLM5JoW+Bvqff9c6faL0KRUPjNr4v
         lqeA76u8TJDpJmHYCMD1goxN6qJfP6zzpAD4fOj5zqMD7Tv1ULSsrPsWuKM0KOtE9t
         VPsTAlRfjAMDzHeaOXVxOq96PdduTiVM4bwIfzww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 639/717] kselftest/arm64: Fix validatation termination record after EXTRA_CONTEXT
Date:   Sat, 22 Oct 2022 09:28:38 +0200
Message-Id: <20221022072526.690184750@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 84c36bee4d82..d98828cb542b 100644
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



