Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25DF5B8475
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiINJMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiINJLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:11:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56E6796AB;
        Wed, 14 Sep 2022 02:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99293B8171A;
        Wed, 14 Sep 2022 09:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08FAC433C1;
        Wed, 14 Sep 2022 09:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146283;
        bh=GSzmj0FzqakisPTTZIhSa7o3h/CHGOigwlG7aO/LbGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGIDsCZHW9epHAYgTIE+cs0IcnH/oCxqtnXUc7pPzGihHk+UNJ1dOoxWyYCAtRHpn
         +wVDJlawSgXEx5tv0FYwHncjgSSa21id3VKqoihH0tfHrHlZp7POpCHMBpMyqi87nx
         MZm9OcRvmjxTg31N/0Ixu+xpBY3RBZj2hz/J+lw8gxmSG0T7MEbAMsHYfUpRMARaUm
         nQyeZQQwJ3zmPJPtC0DzAgbNa958JmWSXoTV2ZBT+nvD9eQP9aRSwZ85iT0/R9QgcW
         4DKqDKp1xjASSKi3bm786dOPJa0wrU2RQhjISJdPymXjaABM4xIZn8HC8nw7XK0IYr
         nHr80LbIJqRuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youling Tang <tangyouling@loongson.cn>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, michal.lkml@markovi.net,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/12] mksysmap: Fix the mismatch of 'L0' symbols in System.map
Date:   Wed, 14 Sep 2022 05:04:05 -0400
Message-Id: <20220914090407.471328-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090407.471328-1-sashal@kernel.org>
References: <20220914090407.471328-1-sashal@kernel.org>
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

