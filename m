Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004D96582F0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbiL1Qn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiL1QnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E648319C0C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD2661576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647DDC433EF;
        Wed, 28 Dec 2022 16:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245430;
        bh=eIyGQwYvZ3wNwvA2OOytTQrxnuJbIjeA7zqaBWARaxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrxEC8Kg9Bp7n0z/Cdrd+oLg96myJLGG9nF7MZ+8KeFItW4GbKqcWfXkI/iXP85Kk
         1K6cKC43hCB/Ic9fGyLW3ji584WNv8CkKBzGD+TR9zPpbIl+VMMutQUX25xs5c7Kbd
         rpBRff+NK9Ixw18Xe/gtWimmV/cyJmuX4kngO47U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0860/1146] selftests/powerpc: Fix resource leaks
Date:   Wed, 28 Dec 2022 15:39:59 +0100
Message-Id: <20221228144353.514439221@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8f4ab7da904ab7027ccd43ddb4f0094e932a5877 ]

In check_all_cpu_dscr_defaults, opendir() opens the directory stream.
Add missing closedir() in the error path to release it.

In check_cpu_dscr_default, open() creates an open file descriptor.
Add missing close() in the error path to release it.

Fixes: ebd5858c904b ("selftests/powerpc: Add test for all DSCR sysfs interfaces")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221205084429.570654-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
index fbbdffdb2e5d..f20d1c166d1e 100644
--- a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
+++ b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
@@ -24,6 +24,7 @@ static int check_cpu_dscr_default(char *file, unsigned long val)
 	rc = read(fd, buf, sizeof(buf));
 	if (rc == -1) {
 		perror("read() failed");
+		close(fd);
 		return 1;
 	}
 	close(fd);
@@ -65,8 +66,10 @@ static int check_all_cpu_dscr_defaults(unsigned long val)
 		if (access(file, F_OK))
 			continue;
 
-		if (check_cpu_dscr_default(file, val))
+		if (check_cpu_dscr_default(file, val)) {
+			closedir(sysfs);
 			return 1;
+		}
 	}
 	closedir(sysfs);
 	return 0;
-- 
2.35.1



