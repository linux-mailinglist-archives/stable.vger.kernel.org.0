Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DD364A110
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiLLNeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiLLNee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:34:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB53C13E21
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:34:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498E76105A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFB9C433D2;
        Mon, 12 Dec 2022 13:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852072;
        bh=R4x7psRlPUMF5lwLakU0Rk7V+V8YrqjfCKSwZ6+ROjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neV1XvJmd5OMoGvhCja4R03w2dvRXTXEU5TT9rSEPmVOJhaTn6Wjv82dX3aLS0xy8
         SVHzH+BCQvRihFxbNJ1oWOnpQ3tsDp4vjIL1c9U8C4TFcJyTIgvn85oJklHtPWVNdy
         WOmTHNm+Yr2MFsLyyaJVagrwX02HuxdzJFMji70M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/123] block: move CONFIG_BLOCK guard to top Makefile
Date:   Mon, 12 Dec 2022 14:18:07 +0100
Message-Id: <20221212130932.445448138@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4c928904ff771a8e830773b71a080047365324a5 ]

Every object under block/ depends on CONFIG_BLOCK.

Move the guard to the top Makefile since there is no point to
descend into block/ if CONFIG_BLOCK=n.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210927140000.866249-5-masahiroy@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 998b30c3948e ("io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile       | 3 ++-
 block/Makefile | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index bc1cf1200b62..0acea54c2ffd 100644
--- a/Makefile
+++ b/Makefile
@@ -1150,7 +1150,8 @@ export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y			+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/
+core-$(CONFIG_BLOCK)	+= block/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/block/Makefile b/block/Makefile
index 41aa1ba69c90..74df168729ec 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the kernel block layer
 #
 
-obj-$(CONFIG_BLOCK) := bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
+obj-y		:= bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-flush.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-timeout.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
-- 
2.35.1



