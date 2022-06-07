Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF9B5413A3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352875AbiFGUDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358028AbiFGUCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:02:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942F71C204B;
        Tue,  7 Jun 2022 11:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 744C8B82368;
        Tue,  7 Jun 2022 18:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C1FC385A5;
        Tue,  7 Jun 2022 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626290;
        bh=4crKvbaRKfRDh58CHafqCLlcae/1alFJ2GNdRhB1c08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3uA4uLg6WKAXEGKZTU52+p94jOBozQe2UZW/v+qryH6azvRwdRytR95aOOEv5ldy
         onRR56Ro4LsQ816cBrioYuN7nxHZDY0m6Xog7XINg/85l6tW6Fzhvp95SIKG9PGO3K
         G2BWsXQ3Kjzaps6Mua+gfdoVr50bXo5aXXeSYUP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 324/772] kunit: fix debugfs code to use enum kunit_status, not bool
Date:   Tue,  7 Jun 2022 18:58:36 +0200
Message-Id: <20220607164958.568925875@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit 38289a26e1b8a37755f3e07056ca416c1ee2a2e8 ]

Commit 6d2426b2f258 ("kunit: Support skipped tests") switched to using
`enum kunit_status` to track the result of running a test/suite since we
now have more than just pass/fail.

This callsite wasn't updated, silently converting to enum to a bool and
then back.

Fixes: 6d2426b2f258 ("kunit: Support skipped tests")
Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/debugfs.c b/lib/kunit/debugfs.c
index b71db0abc12b..1048ef1b8d6e 100644
--- a/lib/kunit/debugfs.c
+++ b/lib/kunit/debugfs.c
@@ -52,7 +52,7 @@ static void debugfs_print_result(struct seq_file *seq,
 static int debugfs_print_results(struct seq_file *seq, void *v)
 {
 	struct kunit_suite *suite = (struct kunit_suite *)seq->private;
-	bool success = kunit_suite_has_succeeded(suite);
+	enum kunit_status success = kunit_suite_has_succeeded(suite);
 	struct kunit_case *test_case;
 
 	if (!suite || !suite->log)
-- 
2.35.1



