Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07793658376
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiL1Qr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiL1Qrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6951AF1C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:42:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4FF6B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CF9C433D2;
        Wed, 28 Dec 2022 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245764;
        bh=hWWyl7jUQijlVAmDgfQH9uGQhvU0smuLPmuN63nxNYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRsCsVMM3lJG92y5P9Q2+vgz6vG39RK0ry2yXok2xTVh4Jg+aHRo+WQZnlh9VprdO
         kaVPrg9DWf/bZlpltNJ6F58VPjqr7BiDu1XNKCmShR13hU+WUPTW0aO9f4OdPieZAl
         ue+vNadIoGqa62iC1+gUZwy01l514ZiZ2dQXBZD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0918/1146] selftests: devlink: fix the fd redirect in dummy_reporter_test
Date:   Wed, 28 Dec 2022 15:40:57 +0100
Message-Id: <20221228144355.187505470@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 9de1d123f4f5..a08c02abde12 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -496,8 +496,8 @@ dummy_reporter_test()
 
 	check_reporter_info dummy healthy 3 3 10 true
 
-	echo 8192> $DEBUGFS_DIR/health/binary_len
-	check_fail $? "Failed set dummy reporter binary len to 8192"
+	echo 8192 > $DEBUGFS_DIR/health/binary_len
+	check_err $? "Failed set dummy reporter binary len to 8192"
 
 	local dump=$(devlink health dump show $DL_HANDLE reporter dummy -j)
 	check_err $? "Failed show dump of dummy reporter"
-- 
2.35.1



