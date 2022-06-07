Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6095F541AC0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356512AbiFGViD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380120AbiFGVhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:37:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90E1EA883;
        Tue,  7 Jun 2022 12:05:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19979B822C0;
        Tue,  7 Jun 2022 19:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66417C385A2;
        Tue,  7 Jun 2022 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628700;
        bh=rsPwkGNK9GIoywZVByF5Yv2MTWSczBPHM5FyQ9egQNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfyQefQ6BY7u4HpMGtOqxlwT7gMSznw2okX6UHx7WAgAHhbFQzbi5cRiv2bC0zP4Z
         Bdt3aK2hUyPCfzuv5bJrHWRDb2BP+eStuy126AVYGIyFI8DWENeOI+przM4oo/PW5C
         ooUyDLiz65hdsagdRmtojAhot3hx7j+rRQcl/pIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Auld <pauld@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 425/879] kselftest/cgroup: fix test_stress.sh to use OUTPUT dir
Date:   Tue,  7 Jun 2022 18:59:03 +0200
Message-Id: <20220607165015.201990234@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Phil Auld <pauld@redhat.com>

[ Upstream commit 54de76c0123915e7533ce352de30a1f2d80fe81f ]

Running cgroup kselftest with O= fails to run the with_stress test due
to hardcoded ./test_core. Find test_core binary using the OUTPUT directory.

Fixes: 1a99fcc035fb ("selftests: cgroup: Run test_core under interfering stress")
Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_stress.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_stress.sh b/tools/testing/selftests/cgroup/test_stress.sh
index 15d9d5896394..109c044f715f 100755
--- a/tools/testing/selftests/cgroup/test_stress.sh
+++ b/tools/testing/selftests/cgroup/test_stress.sh
@@ -1,4 +1,4 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-./with_stress.sh -s subsys -s fork ./test_core
+./with_stress.sh -s subsys -s fork ${OUTPUT}/test_core
-- 
2.35.1



