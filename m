Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9632455CF39
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243422AbiF1CTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243391AbiF1CTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:19:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6065237EA;
        Mon, 27 Jun 2022 19:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 831BCB818E4;
        Tue, 28 Jun 2022 02:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AFDC341CF;
        Tue, 28 Jun 2022 02:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382747;
        bh=ClquhrNOT4VD6E7tPI7YKsNFbFxfSRjNr71ch5jvgDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6EhzRkLJhZ81Wc9WJa7qPK0+7GYBTCNSU+Y5OAABiDPdErGwtiuAV5PwhLiPDBn7
         ESleJ0/8pkT11ezTuKB+R7xofefR3c/l+UYqwoevBeRsxWRP37fEZXe4o9aelnlaox
         U0EWRXnUDs2fz2Qk43BATKPO642g+t6o8nupnFyRKT5TQyuvv/lpTOINWCw7lKCVyo
         rFy4O38Lrm5rK+bVQ9uYKu/7QQzztHPB+s+TGTX3YNdAIw1u3bRvDE6Rrz6WPnnueU
         8/90WC03Kc9VpxV5kIGnYLv8pD7hrp1u1dqIxWvKu7PgWZJnmUlG7rftbK/hIebiv9
         06aBxruP3JK3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 13/53] selftests: vm: Fix resource leak when return error
Date:   Mon, 27 Jun 2022 22:17:59 -0400
Message-Id: <20220628021839.594423-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
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
index fd85f15869d1..aa834b04daa8 100644
--- a/tools/testing/selftests/vm/ksm_tests.c
+++ b/tools/testing/selftests/vm/ksm_tests.c
@@ -54,6 +54,7 @@ static int ksm_write_sysfs(const char *file_path, unsigned long val)
 	}
 	if (fprintf(f, "%lu", val) < 0) {
 		perror("fprintf");
+		fclose(f);
 		return 1;
 	}
 	fclose(f);
@@ -72,6 +73,7 @@ static int ksm_read_sysfs(const char *file_path, unsigned long *val)
 	}
 	if (fscanf(f, "%lu", val) != 1) {
 		perror("fscanf");
+		fclose(f);
 		return 1;
 	}
 	fclose(f);
-- 
2.35.1

