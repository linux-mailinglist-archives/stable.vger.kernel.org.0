Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A676BB04F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjCOMRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjCOMRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B7293E21
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0626AB81DFE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA76C4339C;
        Wed, 15 Mar 2023 12:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882609;
        bh=Ksdo4gq5LleItZIZw3xOCMqb04oxUFOuAVtFrddn7UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXL54uRowF+CLfYrCQCa1j1Ds1g1uJmlmRZv5pfvc75R5r4vu/xECsKj2+NZksfZo
         EYUK3ux2j5rqMuU7IROws+x0XzUMTrKAugku69aCYDClC2Rq6Lm5VRqKrEOyYPKomz
         JA3oeINZ7YfGb0e8WvxjaER8c/hw4/VaSuN+RRIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/39] kbuild: fix false-positive need-builtin calculation
Date:   Wed, 15 Mar 2023 13:12:35 +0100
Message-Id: <20230315115721.997810362@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit d9f78edfd81b9e484423534360350ef7253cc888 ]

The current implementation of need-builtin is false-positive,
for example, in the following Makefile:

  obj-m := foo/
  obj-y := foo/bar/

..., where foo/built-in.a is not required.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Stable-dep-of: 2e3d0e20d845 ("ARM: dts: exynos: correct TMU phandle in Odroid HC1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 64fac0ad32d6b..7635cc05fcfa3 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -541,7 +541,8 @@ targets += $(call intermediate_targets, .asn1.o, .asn1.c .asn1.h) \
 
 PHONY += $(subdir-ym)
 $(subdir-ym):
-	$(Q)$(MAKE) $(build)=$@ need-builtin=$(if $(findstring $@,$(subdir-obj-y)),1)
+	$(Q)$(MAKE) $(build)=$@ \
+	need-builtin=$(if $(filter $@/built-in.a, $(subdir-obj-y)),1)
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
-- 
2.39.2



