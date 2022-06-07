Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4AC54140B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359650AbiFGUMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359113AbiFGUJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6A41406C5;
        Tue,  7 Jun 2022 11:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9474BCE244F;
        Tue,  7 Jun 2022 18:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBB2C385A2;
        Tue,  7 Jun 2022 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626399;
        bh=rsPwkGNK9GIoywZVByF5Yv2MTWSczBPHM5FyQ9egQNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asKruAHzxg1wsVn6KnPf3VbQ46SRHCPckoGjvAsbWXpZ/g9CoI2XzND2XvpbW+jZ3
         +9WB7Pab1/3nfc1Sdjr5j/NAvW9gESYEBVcTKs57dJdYz6yTFvIBSgIz0RYGIlLK85
         zOXt1vV2vgLhxkU75tLyebDmlIiNFDp4OY6HsftU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Auld <pauld@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 364/772] kselftest/cgroup: fix test_stress.sh to use OUTPUT dir
Date:   Tue,  7 Jun 2022 18:59:16 +0200
Message-Id: <20220607164959.739992646@linuxfoundation.org>
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



