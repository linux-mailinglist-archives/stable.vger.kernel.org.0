Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215F04F2FB6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347944AbiDEJ2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244988AbiDEIw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DBA3A4;
        Tue,  5 Apr 2022 01:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB00F61509;
        Tue,  5 Apr 2022 08:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8579C385A1;
        Tue,  5 Apr 2022 08:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148518;
        bh=TM2CW2otMmrdC61r+VarD9obVtQxh+xCYtRj5/TwWb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vF2pGA24MBmwcdw2nxbyeaoIOhZfUz+NBEbJz0y3avlt18CNn/nP7CQDDvxLB5Emo
         n9V89eyjzKJj6V5aR1hafFcPW4nLahwSEdpfkOPvWgPsP/uw8NJ5HJU4Fx5p57Q+gV
         U8rY4uu2LlCCtOGaSHVcGNEM9xNE/sekQwbxzi2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0347/1017] selftests/lkdtm: Add UBSAN config
Date:   Tue,  5 Apr 2022 09:21:00 +0200
Message-Id: <20220405070404.582416841@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



