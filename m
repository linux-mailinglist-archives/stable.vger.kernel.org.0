Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B517C63AF47
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiK1Rk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiK1Rjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:39:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F8429351;
        Mon, 28 Nov 2022 09:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54842B80EA6;
        Mon, 28 Nov 2022 17:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F619C433D7;
        Mon, 28 Nov 2022 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657124;
        bh=uima7NwaS8OwqnhFDlO2OGrm2y1ElcTnY0VnoLuZ2Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smVYNVjf9Ce6P9zvFLy5D6Bk7dQOffx+qctPI31fCSLnhfQ7vRkOI13lTuMz0CnMw
         NEovWGBpeZvNCwc21bBn8UViOWA/PdzqPkNbWky6dG0a8Semec+dSTMT/wwK8cGfeM
         q9C36URI1tFUitwNhdXm03QY5wMs7KjAs7MyYS2WQCKtMFuOAB+cEViUM132EP8eKY
         Gtxt7nMvgeHfNSyMbx2pxmxvjwEyoqLa0Diz/JjZhR7eOhUAqefFfc8NrBM5RgM0a0
         gx6cxkC4pnKzu3Hcj7/vfn6jYPAwXcGqT8/hmdkYxnWuA6EfmKDRVq2I1R5Jm9LEur
         SPcx6BIi7ajbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        loongarch@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 23/39] LoongArch: Makefile: Use "grep -E" instead of "egrep"
Date:   Mon, 28 Nov 2022 12:36:03 -0500
Message-Id: <20221128173642.1441232-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 83f638bca0ccd94942bc3c4eb9bcec24dd8a1cf9 ]

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E

Fix this up by changing the LoongArch Makefile to use "grep -E" instead.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index ec3de6191276..9123feb69854 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -68,7 +68,7 @@ KBUILD_LDFLAGS	+= -m $(ld-emul)
 
 ifdef CONFIG_LOONGARCH
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
-	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
+	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif
 
-- 
2.35.1

