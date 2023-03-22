Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9E6C562C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCVUDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjCVUCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:02:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1636F1FCF;
        Wed, 22 Mar 2023 12:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D34622C4;
        Wed, 22 Mar 2023 19:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E486C433AF;
        Wed, 22 Mar 2023 19:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515163;
        bh=UMk1yWcwvsggJJjnaJ9yTLb2WQw1KXCFuCFy3Q+rgHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbbCOGDuwpY+38+XllKayiicuORjsZ55bksFA9XW60j1VKVM8WBq7HnNhBLAKXrJO
         JaJPSv/2hnl9B/Z4xyHIour7dmnoA9+GnqbZdA1rSbazQBauj+Ez5iIhF/54xyGLtK
         XUWHZYIXOHfoKb5Ay4xB7dew1CI+pfhU3IjK8ftg7ouIyr2KOpFGLTzx+CmbODfniL
         o4rrAMhNNgsUWqf9Q0NX5Ed13l15UNitE2oW6ebi3aMXHFe/TEMTyeoHCXkj+LlL7V
         TQ+Rl21N/goZhh9GZS1pQEye+HJbaG7vyMdYcCgFYFFIAuKH6sHGnipxyNR+UaI3Wb
         Fg0TNhH9vfbxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prarit Bhargava <prarit@redhat.com>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, lenb@kernel.org
Subject: [PATCH AUTOSEL 6.2 43/45] tools/power turbostat: Fix /dev/cpu_dma_latency warnings
Date:   Wed, 22 Mar 2023 15:56:37 -0400
Message-Id: <20230322195639.1995821-43-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit 40aafc7d58d3544f152a863a0e9863014b6d5d8c ]

When running as non-root the following error is seen in turbostat:

turbostat: fopen /dev/cpu_dma_latency
: Permission denied

turbostat and the man page have information on how to avoid other
permission errors, so these can be fixed the same way.

Provide better /dev/cpu_dma_latency warnings that provide instructions on
how to avoid the error, and update the man page.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 | 2 ++
 tools/power/x86/turbostat/turbostat.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index c7b26a3603afe..3e1a4c4be001a 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -344,6 +344,8 @@ Alternatively, non-root users can be enabled to run turbostat this way:
 
 # chmod +r /dev/cpu/*/msr
 
+# chmod +r /dev/cpu_dma_latency
+
 .B "turbostat "
 reads hardware counters, but doesn't write them.
 So it will not interfere with the OS or other programs, including
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index aba460410dbd1..c24054e3ef7ad 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5482,7 +5482,7 @@ void print_dev_latency(void)
 
 	retval = read(fd, (void *)&value, sizeof(int));
 	if (retval != sizeof(int)) {
-		warn("read %s\n", path);
+		warn("read failed %s\n", path);
 		close(fd);
 		return;
 	}
-- 
2.39.2

