Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF5B5B846A
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiINJLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiINJLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:11:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C48785B7;
        Wed, 14 Sep 2022 02:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FBCF61999;
        Wed, 14 Sep 2022 09:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E11C43470;
        Wed, 14 Sep 2022 09:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146311;
        bh=GSzmj0FzqakisPTTZIhSa7o3h/CHGOigwlG7aO/LbGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lj8Bmm5lN2o+NpUaj03AsPI13BX/VOCkKt9R6kf7fI5K2al8hNEplXwtW0l/8y9pU
         JK2QiVJdMztdZBvDRQRScl7nhEfeNeAWx5YUCyg7l7GNaagsXRUV5lk2DpHdSo2Jnw
         6x1wP6az4O3c6UwsqbBcVyuE/9cvD3hGFh4ZVkciYxOQ6quaIn7uNUQ2iEnLmR6rhs
         /B7Wr0nHQ1dsuoN07YrzFwXhVZFoWHTclBY/j8On6MRcGXx3tj7wj1PDGITHSfKomD
         W3lKHiZJeoy+Dr33JKhT4YH4eR6jcqSjjgg0L3SRDE6ZaqglPzrdTWVPkXNRAfFUym
         xoIC2S8yIbGfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youling Tang <tangyouling@loongson.cn>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, michal.lkml@markovi.net,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 9/9] mksysmap: Fix the mismatch of 'L0' symbols in System.map
Date:   Wed, 14 Sep 2022 05:04:43 -0400
Message-Id: <20220914090445.471489-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090445.471489-1-sashal@kernel.org>
References: <20220914090445.471489-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Youling Tang <tangyouling@loongson.cn>

[ Upstream commit c17a2538704f926ee4d167ba625e09b1040d8439 ]

When System.map was generated, the kernel used mksysmap to filter the
kernel symbols, we need to filter "L0" symbols in LoongArch architecture.

$ cat System.map | grep L0
9000000000221540 t L0

The L0 symbol exists in System.map, but not in .tmp_System.map. When
"cmp -s System.map .tmp_System.map" will show "Inconsistent kallsyms
data" error message in link-vmlinux.sh script.

Signed-off-by: Youling Tang <tangyouling@loongson.cn>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index 9aa23d15862a0..ad8bbc52267d0 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -41,4 +41,4 @@
 # so we just ignore them to let readprofile continue to work.
 # (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)' > $2
+$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)\|\( L0\)' > $2
-- 
2.35.1

