Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DDF59387A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241841AbiHOSme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243548AbiHOSlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:41:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD54B20F;
        Mon, 15 Aug 2022 11:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9542FB81082;
        Mon, 15 Aug 2022 18:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6209C433D6;
        Mon, 15 Aug 2022 18:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587884;
        bh=8e8cLGBEfOgW7SXzthoRIC0+pNV2OH/E5k8Ju7+lsF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6p55P+yZKrFjxjb2YmLEUgzIBuHqYqwy0oVSw3Rr502bCfl4SJy4hh6l1A5DlBHR
         reo38AOTE/vVVBLyQfByrdMrT83Noj1WAdIfDQQP3QWD0bCwljvG1nynHCqFsRWBvN
         ShQIQmNZlxmoKSrAwk0X7c+j1qb+oYKmwHybNfe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        "GONG, Ruiqi" <gongruiqi1@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, GONG@vger.kernel.org
Subject: [PATCH 5.15 194/779] stack: Declare {randomize_,}kstack_offset to fix Sparse warnings
Date:   Mon, 15 Aug 2022 19:57:18 +0200
Message-Id: <20220815180345.564511077@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: GONG, Ruiqi <gongruiqi1@huawei.com>

[ Upstream commit 375561bd6195a31bf4c109732bd538cb97a941f4 ]

Fix the following Sparse warnings that got noticed when the PPC-dev
patchwork was checking another patch (see the link below):

init/main.c:862:1: warning: symbol 'randomize_kstack_offset' was not declared. Should it be static?
init/main.c:864:1: warning: symbol 'kstack_offset' was not declared. Should it be static?

Which in fact are triggered on all architectures that have
HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET support (for instances x86, arm64
etc).

Link: https://lore.kernel.org/lkml/e7b0d68b-914d-7283-827c-101988923929@huawei.com/T/#m49b2d4490121445ce4bf7653500aba59eefcb67f
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: 39218ff4c625 ("stack: Optionally randomize kernel stack offset each syscall")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220629060423.2515693-1-gongruiqi1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/main.c b/init/main.c
index cf79b5a766cb..649d9e4201a8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -100,6 +100,7 @@
 #include <linux/kcsan.h>
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
+#include <linux/randomize_kstack.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
-- 
2.35.1



