Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7F4540608
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346916AbiFGRdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348128AbiFGRbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F753115A57;
        Tue,  7 Jun 2022 10:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0EE1B82285;
        Tue,  7 Jun 2022 17:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344BAC385A5;
        Tue,  7 Jun 2022 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622969;
        bh=rsPwkGNK9GIoywZVByF5Yv2MTWSczBPHM5FyQ9egQNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0t9hWOjbRuLpiyxG10C+ZC5mlKTG2ZHlODYjx4iIX8Mlow0ELXw4NeekETcRJVrK4
         wtmblQ6GqaQOwmqO0Uu1VfbFu6/E3MS16xWAxXlsRXRJ5Lc+qCVzY06+MEAaK/d3GC
         VLYXyLGUlY7FNqa3D3QCd7AIAFHFs5bxDA9H5/LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Auld <pauld@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/452] kselftest/cgroup: fix test_stress.sh to use OUTPUT dir
Date:   Tue,  7 Jun 2022 19:01:04 +0200
Message-Id: <20220607164914.732314490@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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



