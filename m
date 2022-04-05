Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754E84F36D9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352415AbiDELIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348793AbiDEJsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B568D7C79B;
        Tue,  5 Apr 2022 02:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F3BB61675;
        Tue,  5 Apr 2022 09:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595AEC385A2;
        Tue,  5 Apr 2022 09:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151327;
        bh=02dv/ZLkwro8smZ+5sfM5x9qxyapHlnEig4S46FWkbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoXrMH7ccq4KU9SalWfFHiKjRUxDNCYI0L+EOwa0DsFpLePiHzU+UMp8LpIMXPW2z
         mMWB4UzRgd4k0CzLcDIpw5DkBZ/6XVGJDXvFeJD8t2VEF56BPHsRtXpbBvoeJnjEr7
         I4sKv7R7gN+U/dKWHn2Sl5c7v6jktP0Mv1yi+7kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/913] lib: uninline simple_strntoull() as well
Date:   Tue,  5 Apr 2022 09:23:09 +0200
Message-Id: <20220405070349.652301661@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 839b395eb9c13ae56ea5fc3ca9802734a72293f0 ]

Codegen become bloated again after simple_strntoull() introduction

	add/remove: 0/0 grow/shrink: 0/4 up/down: 0/-224 (-224)
	Function                                     old     new   delta
	simple_strtoul                                 5       2      -3
	simple_strtol                                 23      20      -3
	simple_strtoull                              119      15    -104
	simple_strtoll                               155      41    -114

Link: https://lkml.kernel.org/r/YVmlB9yY4lvbNKYt@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vsprintf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index ec07f6312445..0621bbb20e0f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -54,8 +54,7 @@
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
 
-static unsigned long long simple_strntoull(const char *startp, size_t max_chars,
-					   char **endp, unsigned int base)
+static noinline unsigned long long simple_strntoull(const char *startp, size_t max_chars, char **endp, unsigned int base)
 {
 	const char *cp;
 	unsigned long long result = 0ULL;
-- 
2.34.1



