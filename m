Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7D75C033F
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiIUQBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiIUQAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E830726B8;
        Wed, 21 Sep 2022 08:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 412DDB830CD;
        Wed, 21 Sep 2022 15:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D701C433C1;
        Wed, 21 Sep 2022 15:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775557;
        bh=4rwkvD/DNcjNXfcsWGkTsOeqnSDE+8I7hUNF1BK6CT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alM5bQd1URenuOWGw/SCHwZU7rkC3TERvcsniYvlTVYHrLpIaPuDnrlOXTXWzrBJf
         C1gHjsfmmKAFjEQppOTo7p6y8W91ZwsvZObIpndSqqW22fHWJEJ37/5XG1lBf/nDVG
         2TOIXgjdafwli4uNq/OHVBq87MjocpVEj4qoRi2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Youling Tang <tangyouling@loongson.cn>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/39] mksysmap: Fix the mismatch of L0 symbols in System.map
Date:   Wed, 21 Sep 2022 17:46:41 +0200
Message-Id: <20220921153646.896567524@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 9aa23d15862a..ad8bbc52267d 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -41,4 +41,4 @@
 # so we just ignore them to let readprofile continue to work.
 # (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)' > $2
+$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)\|\( L0\)' > $2
-- 
2.35.1



