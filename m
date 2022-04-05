Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76A64F2783
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiDEIHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbiDEH7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D242D40A3A;
        Tue,  5 Apr 2022 00:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84E55B81B9C;
        Tue,  5 Apr 2022 07:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D416DC3410F;
        Tue,  5 Apr 2022 07:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145339;
        bh=TM2CW2otMmrdC61r+VarD9obVtQxh+xCYtRj5/TwWb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwEsecBt95BCOWFv398ISaC1Mp0TojstwWl7BXF3GGBX/8nJ2Su4lcHAe9GLLq7RO
         NLaG8l14li+4MEjAq/Dy7wiC22V40hqPpTiS2mFx5N/trYBLWNtA7ml8vNRDk0T7w3
         44IMHaysLEhFtfelcMGXmXcAq3LDdBELEC1JYFkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0369/1126] selftests/lkdtm: Add UBSAN config
Date:   Tue,  5 Apr 2022 09:18:36 +0200
Message-Id: <20220405070418.458074457@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 1900be289b598b2c553b3add13e491c0bb8a8550 ]

UBSAN_BOUNDS and UBSAN_TRAP depend on UBSAN config option.
merge_config.sh script generates following warnings if parent config
doesn't have UBSAN config already enabled and UBSAN_BOUNDS/UBSAN_TRAP
config options don't get added to the parent config.

Value requested for CONFIG_UBSAN_BOUNDS not in final .config
Requested value:  CONFIG_UBSAN_BOUNDS=y
Actual value:

Value requested for CONFIG_UBSAN_TRAP not in final .config
Requested value:  CONFIG_UBSAN_TRAP=y
Actual value:

Fix this by including UBSAN config.

Fixes: c75be56e35b2 ("lkdtm/bugs: Add ARRAY_BOUNDS to selftests")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lkdtm/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/lkdtm/config b/tools/testing/selftests/lkdtm/config
index a26a3fa9e925..8bd847f0463c 100644
--- a/tools/testing/selftests/lkdtm/config
+++ b/tools/testing/selftests/lkdtm/config
@@ -6,6 +6,7 @@ CONFIG_HARDENED_USERCOPY=y
 # CONFIG_HARDENED_USERCOPY_FALLBACK is not set
 CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y
 CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
+CONFIG_UBSAN=y
 CONFIG_UBSAN_BOUNDS=y
 CONFIG_UBSAN_TRAP=y
 CONFIG_STACKPROTECTOR_STRONG=y
-- 
2.34.1



