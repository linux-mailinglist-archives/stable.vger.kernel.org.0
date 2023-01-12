Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0FC6676AF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbjALOem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbjALOdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:33:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BED5AC74
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:25:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37791B81E67
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E32C433D2;
        Thu, 12 Jan 2023 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533522;
        bh=P17KHlf5AiGQkmqq6Su1v8X/klSOlQAX0tFDGqz+PUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15czGNFDYpRRkf/qG3KWrizjX8TOAtf3P6uB+/dnGEi6qugjRpf9+ic4qGYcBxgWP
         tZedLjPcSo2sH9J7T56/ftprIovGyS2eYM8k9PSVSGM+eupoKL3Q5XZKOeP1i1kpSB
         KCqMe0FK88xYgrioL6mcnnkuBW6T6P0tqpcZ96xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/783] selftests: devlink: fix the fd redirect in dummy_reporter_test
Date:   Thu, 12 Jan 2023 14:53:11 +0100
Message-Id: <20230112135546.237360318@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2fc60e2ff972d3dca836bff0b08cbe503c4ca1ce ]

$number + > bash means redirect FD $number, e.g. commonly
used 2> redirects stderr (fd 2). The test uses 8192> to
write the number 8192 to a file, this results in:

  ./devlink.sh: line 499: 8192: Bad file descriptor

Oddly the test also papers over this issue by checking
for failure (expecting an error rather than success)
so it passes, anyway.

Fixes: ff18176ad806 ("selftests: Add a test of large binary to devlink health test")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c254365..16d2de18591d 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -495,8 +495,8 @@ dummy_reporter_test()
 
 	check_reporter_info dummy healthy 3 3 10 true
 
-	echo 8192> $DEBUGFS_DIR/health/binary_len
-	check_fail $? "Failed set dummy reporter binary len to 8192"
+	echo 8192 > $DEBUGFS_DIR/health/binary_len
+	check_err $? "Failed set dummy reporter binary len to 8192"
 
 	local dump=$(devlink health dump show $DL_HANDLE reporter dummy -j)
 	check_err $? "Failed show dump of dummy reporter"
-- 
2.35.1



