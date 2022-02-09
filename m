Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3064AFAB8
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbiBISjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240085AbiBISjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:39:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970B2C03BFC0;
        Wed,  9 Feb 2022 10:38:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F155AB82381;
        Wed,  9 Feb 2022 18:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B36C340E7;
        Wed,  9 Feb 2022 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431929;
        bh=shZDmquoMNV8wulGH1i1U7v5/XEgHVECCYKOWyjzupw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEi+9IY5Q9swgENm4WC+8jRcl0zf35SElQf8/pYIA8ZR0hFKEAb1tJFAPL8yyY0tE
         QyIvIQ9wuQ3MqH6QcBJu/23afY05DpfSRAWNn3Hes4igtBGvM5Rgfp+KkFuOt6dIDz
         tTJrxQ9v9hDW6oJwzT8QijKsYrbf3Xvr9/USYWZZPVdOBq/5qCtCIRt7fjmOkIvXJS
         zr7FeD+DJBv/nobLOnsU628PBuk+ZwRChU7W6I9CbVB8BTNjQnUR6hAB2ZFNqPuV6q
         WgYsbq+LFtlXN/w+BOHvjeUXvdqO75CdHrlUXN3VtZCvwLKWGpJpxnxrZIyauuCb4z
         9kOqsT2zx0lfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/36] selftests: openat2: Print also errno in failure messages
Date:   Wed,  9 Feb 2022 13:37:34 -0500
Message-Id: <20220209183759.47134-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
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

