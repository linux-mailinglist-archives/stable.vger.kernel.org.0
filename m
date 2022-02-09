Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A641B4AFAC7
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240135AbiBISkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240037AbiBISjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:39:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2552C03E949;
        Wed,  9 Feb 2022 10:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CAEEB82381;
        Wed,  9 Feb 2022 18:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D16C36AE2;
        Wed,  9 Feb 2022 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431949;
        bh=Y4lticyda0JJhfUxP3JKpsyz7hPDielaAkyHNjgAZRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyNUcRIHWtGwSkt84yz26bWEqr7GCDnr1gkDK34gF9B6lHBC2gz0P7P99cvPG/hzN
         Y5GTRUcLdz2HQmzW4oCRgCKrsGbDTZYtOxgfSeSwFSYFvmiFmKnymo00Kw12IgzD9J
         T81IUB0brq/ENk3pE4VdFBlAXpwqi/tmAQf7QEwzwo7PJyRHRx8oS2qc1G60jVo4AB
         scpwPauUz/S77f6G1T67ueDhOEgg/8W4kogIUtf0CrWlWHaPg3SUafjoXeFvjU46IK
         b1yFSxPpHtX2376mnqquodUiLgpGhA8xeinPJri54umUbhr3Fa2VBsdKzHmEQekwQm
         0pnQaEOhYwCiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        zhang.yunkai@zte.com.cn, akpm@linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/36] selftests: skip mincore.check_file_mmap when fs lacks needed support
Date:   Wed,  9 Feb 2022 13:37:37 -0500
Message-Id: <20220209183759.47134-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit dae1d8ac31896988e7313384c0370176a75e9b45 ]

Report mincore.check_file_mmap as SKIP instead of FAIL if the underlying
filesystem lacks support of O_TMPFILE or fallocate since such failures
are not really related to mincore functionality.

Cc: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/mincore/mincore_selftest.c      | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mincore/mincore_selftest.c b/tools/testing/selftests/mincore/mincore_selftest.c
index e54106643337b..4c88238fc8f05 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -207,15 +207,21 @@ TEST(check_file_mmap)
 
 	errno = 0;
 	fd = open(".", O_TMPFILE | O_RDWR, 0600);
-	ASSERT_NE(-1, fd) {
-		TH_LOG("Can't create temporary file: %s",
-			strerror(errno));
+	if (fd < 0) {
+		ASSERT_EQ(errno, EOPNOTSUPP) {
+			TH_LOG("Can't create temporary file: %s",
+			       strerror(errno));
+		}
+		SKIP(goto out_free, "O_TMPFILE not supported by filesystem.");
 	}
 	errno = 0;
 	retval = fallocate(fd, 0, 0, FILE_SIZE);
-	ASSERT_EQ(0, retval) {
-		TH_LOG("Error allocating space for the temporary file: %s",
-			strerror(errno));
+	if (retval) {
+		ASSERT_EQ(errno, EOPNOTSUPP) {
+			TH_LOG("Error allocating space for the temporary file: %s",
+			       strerror(errno));
+		}
+		SKIP(goto out_close, "fallocate not supported by filesystem.");
 	}
 
 	/*
@@ -271,7 +277,9 @@ TEST(check_file_mmap)
 	}
 
 	munmap(addr, FILE_SIZE);
+out_close:
 	close(fd);
+out_free:
 	free(vec);
 }
 
-- 
2.34.1

