Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9476BB050
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjCOMRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjCOMRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7EB943A7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD1356174E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03AFC433D2;
        Wed, 15 Mar 2023 12:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882612;
        bh=MMoxCHcaLjGBWb3D/8yHeW0++B1tTSkl/z9v30vqLNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4caRKf+e1h+KdE5NwpoYlMJOJa8aYgKo0DIPUIp+fgyBn9kCspq5P88+q8ehsqAa
         ueQzvy1ggbigb1AWLRU5hXRE/0WQBbCc+DJyS0bHglVxfY/RJk9i5nyEqkC1ldL/EL
         MQ+U+50seG6Kaj4TE/o51Shv9F5mr+OHdRYakNJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/39] kbuild: generate modules.order only in directories visited by obj-y/m
Date:   Wed, 15 Mar 2023 13:12:36 +0100
Message-Id: <20230315115722.047084693@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 4f2c8f3089f538f556c86f26603a062865e4aa94 ]

The modules.order files in directories visited by the chain of obj-y
or obj-m are merged to the upper-level ones, and become parts of the
top-level modules.order. On the other hand, there is no need to
generate modules.order in directories visited by subdir-y or subdir-m
since they would become orphan anyway.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Stable-dep-of: 2e3d0e20d845 ("ARM: dts: exynos: correct TMU phandle in Odroid HC1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 7635cc05fcfa3..97f59fa3e0ed9 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -542,7 +542,8 @@ targets += $(call intermediate_targets, .asn1.o, .asn1.c .asn1.h) \
 PHONY += $(subdir-ym)
 $(subdir-ym):
 	$(Q)$(MAKE) $(build)=$@ \
-	need-builtin=$(if $(filter $@/built-in.a, $(subdir-obj-y)),1)
+	need-builtin=$(if $(filter $@/built-in.a, $(subdir-obj-y)),1) \
+	need-modorder=$(if $(need-modorder),$(if $(filter $@/modules.order, $(modorder)),1))
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
-- 
2.39.2



