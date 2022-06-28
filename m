Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92F755D737
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243662AbiF1CWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243745AbiF1CVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B024BE1;
        Mon, 27 Jun 2022 19:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE5A8B818E4;
        Tue, 28 Jun 2022 02:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD84C36AE5;
        Tue, 28 Jun 2022 02:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382882;
        bh=Gx50wDzQU5N6gDpRHLl9R6YCgbOEWXoj1h8NlNVhINM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9QsEiu9K9tLVz3w3UFKinE2Dh81NMrYgJirlMFCtS/RrEXHWGTqnw3e6MGSVjW24
         V0+Vf774T8rdTHuM8hYi3n6YZM41jcw9TVuxH+DcAQc7YVjTSZnlK9ibQ3DLHtRNZV
         XmZ3lc4XjRkd2xdLlQM8r06OCGXkpD90zUOR5w4HRDQJoYS3keFdw7hpI7K5pivAwd
         jM5Chi+rL9+NdhgYJAE/xUmP3wLHOoZOTmCYJjcCKmDSSo8KusR6sc28DQcdcO1dqs
         4PeWtJ9khHzCCqyWhizXmYXWrItQPYtc4laNweTzoR3LIOv/lkB3R3nZRz7PDHmAlV
         Yad2tUkSA6v6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/41] selftests: vm: Fix resource leak when return error
Date:   Mon, 27 Jun 2022 22:20:30 -0400
Message-Id: <20220628022100.595243-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

[ Upstream commit 3084a4ec7f9bb1ec90036cfd01b1abadc5dd4fb2 ]

When return on an error path, file handle need to be closed
to prevent resource leak

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/ksm_tests.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/vm/ksm_tests.c b/tools/testing/selftests/vm/ksm_tests.c
index b61dcdb44c5b..b31f7a17d92a 100644
--- a/tools/testing/selftests/vm/ksm_tests.c
+++ b/tools/testing/selftests/vm/ksm_tests.c
@@ -48,6 +48,7 @@ static int ksm_write_sysfs(const char *file_path, unsigned long val)
 	}
 	if (fprintf(f, "%lu", val) < 0) {
 		perror("fprintf");
+		fclose(f);
 		return 1;
 	}
 	fclose(f);
@@ -66,6 +67,7 @@ static int ksm_read_sysfs(const char *file_path, unsigned long *val)
 	}
 	if (fscanf(f, "%lu", val) != 1) {
 		perror("fscanf");
+		fclose(f);
 		return 1;
 	}
 	fclose(f);
-- 
2.35.1

