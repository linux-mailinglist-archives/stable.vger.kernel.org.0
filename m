Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A504BE5F6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiBUJtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352469AbiBUJra (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EF631360;
        Mon, 21 Feb 2022 01:19:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E11EDCE0E7C;
        Mon, 21 Feb 2022 09:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF281C340E9;
        Mon, 21 Feb 2022 09:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435193;
        bh=Y4lticyda0JJhfUxP3JKpsyz7hPDielaAkyHNjgAZRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUqKAh7oty5j9lmovpmmm+YcATbFtg7FySFB149nCw6vHARNlXWttqZI0zVeoPbBv
         G9yZxOiiQnUKLQP5bWFQehhxD6QL4osazrYoJYgyWRE8ShCmIXy2Uvve9GK8q5U3v5
         OssUMpWpZdZJ4Kboktqa/kW5SvgJ66i62Wz2Z1Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 046/227] selftests: skip mincore.check_file_mmap when fs lacks needed support
Date:   Mon, 21 Feb 2022 09:47:45 +0100
Message-Id: <20220221084936.409997218@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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



