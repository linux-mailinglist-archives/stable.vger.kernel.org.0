Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D4D4AFB43
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiBISn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbiBISnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:43:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DBBC050CC9;
        Wed,  9 Feb 2022 10:42:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 972D6B82215;
        Wed,  9 Feb 2022 18:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460A8C340E7;
        Wed,  9 Feb 2022 18:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432140;
        bh=GDe3jRGeoV8MhQkHc5TTNRZYGcruBsUt0qonQe0epg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTSatPKyrAR7H4cSInKMobzWoQirryrhjLGcTOwgKIH94ghJH7qawdMG130JrN5mA
         YLPdW63s2z4M3HYtOuagSP+BBS+5eyjGDGZCJ9tXgA4tMECr5jGWl4/4xK3E7O6MCC
         o2SI1vBQdbt6o4+eoL2Oiz1RsSr52gYtY2sUr+DYuC02KHbFnTsaLD7buc2BtLwi3w
         1G2VaZ29QWu85NKwwkdIUhsRMGO2iEWQ7DmLk669YNh039orxKKYlTx3F6Ea4F9mVY
         Wr+wdE9zE6drLIG0qYylKgHP1lxcMJwPnbz3ezRE53pd7ok779Ol9gVUdvECMm6tR9
         u0ON5BRB/9w5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        zhang.yunkai@zte.com.cn, akpm@linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/27] selftests: skip mincore.check_file_mmap when fs lacks needed support
Date:   Wed,  9 Feb 2022 13:40:48 -0500
Message-Id: <20220209184103.47635-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
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
index 5a1e85ff5d32a..2cf6f2f277ab8 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -208,15 +208,21 @@ TEST(check_file_mmap)
 
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
@@ -272,7 +278,9 @@ TEST(check_file_mmap)
 	}
 
 	munmap(addr, FILE_SIZE);
+out_close:
 	close(fd);
+out_free:
 	free(vec);
 }
 
-- 
2.34.1

