Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A01956FD17
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiGKJuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiGKJt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE27022BDD;
        Mon, 11 Jul 2022 02:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56508CE1264;
        Mon, 11 Jul 2022 09:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E788C341C8;
        Mon, 11 Jul 2022 09:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531460;
        bh=V+WDw0l5UMQAs734NnB/Vod18HHkXveYEPQ8H8oYbvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWNbtq3QcTvnFeTkN0WH+5GNWu79Y5aTpk4pzAFnOifrvHuuX9DulPT0yYe9+ek5h
         aVkGW2G85j8RvyGKEJ/D+XqbH/Re7APJ2Xr3T8U5CtTAaiqS9a1YsvS3/u3U4G3toF
         q5TDjOUwcdan5B3NlZdaP2/jbBMm7jMBFIDGspDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/230] uapi/linux/stddef.h: Add include guards
Date:   Mon, 11 Jul 2022 11:06:09 +0200
Message-Id: <20220711090607.272184014@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

[ Upstream commit 55037ed7bdc62151a726f5685f88afa6a82959b1 ]

Add include guard wrapper define to uapi/linux/stddef.h to prevent macro
redefinition errors when stddef.h is included more than once. This was not
needed before since the only contents already used a redefinition test.

Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220329171252.57279-1-tadeusz.struk@linaro.org
Fixes: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/stddef.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 3021ea25a284..7837ba4fe728 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -1,4 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_STDDEF_H
+#define _UAPI_LINUX_STDDEF_H
+
 #include <linux/compiler_types.h>
 
 #ifndef __always_inline
@@ -41,3 +44,4 @@
 		struct { } __empty_ ## NAME; \
 		TYPE NAME[]; \
 	}
+#endif
-- 
2.35.1



