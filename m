Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6BA4BE96F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348668AbiBUJXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349554AbiBUJVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25FE3669D;
        Mon, 21 Feb 2022 01:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 705E4CE0E88;
        Mon, 21 Feb 2022 09:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3D0C340E9;
        Mon, 21 Feb 2022 09:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434503;
        bh=shZDmquoMNV8wulGH1i1U7v5/XEgHVECCYKOWyjzupw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbDadnZorqoT4qmNKACmGhY8tvSsGlXjdrRqnBzsoetDkerBJ3lzK6zMAqFJeeQBv
         tCs13fngoyl7/Wtrqarew6g6Hu1ehkvGRkBnUEahnfIjJNmPFeGBgPCT1xkrEhe+ym
         8eMU4fH74IgHrYeUvE4KGi0g4iNcvdNOIF/0vpLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/196] selftests: openat2: Print also errno in failure messages
Date:   Mon, 21 Feb 2022 09:47:42 +0100
Message-Id: <20220221084931.930791798@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit e051cdf655fa016692008a446a060eff06222bb5 ]

In E_func() macro, on error, print also errno in order to aid debugging.

Cc: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/helpers.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/selftests/openat2/helpers.h
index a6ea27344db2d..ad5d0ba5b6ce9 100644
--- a/tools/testing/selftests/openat2/helpers.h
+++ b/tools/testing/selftests/openat2/helpers.h
@@ -62,11 +62,12 @@ bool needs_openat2(const struct open_how *how);
 					(similar to chroot(2)). */
 #endif /* RESOLVE_IN_ROOT */
 
-#define E_func(func, ...)						\
-	do {								\
-		if (func(__VA_ARGS__) < 0)				\
-			ksft_exit_fail_msg("%s:%d %s failed\n", \
-					   __FILE__, __LINE__, #func);\
+#define E_func(func, ...)						      \
+	do {								      \
+		errno = 0;						      \
+		if (func(__VA_ARGS__) < 0)				      \
+			ksft_exit_fail_msg("%s:%d %s failed - errno:%d\n",    \
+					   __FILE__, __LINE__, #func, errno); \
 	} while (0)
 
 #define E_asprintf(...)		E_func(asprintf,	__VA_ARGS__)
-- 
2.34.1



