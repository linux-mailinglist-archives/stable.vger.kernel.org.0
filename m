Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2816C56CC
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjCVUJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjCVUJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:09:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B1C7616B;
        Wed, 22 Mar 2023 13:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EBF3B81DF6;
        Wed, 22 Mar 2023 20:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA03C4339B;
        Wed, 22 Mar 2023 20:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515360;
        bh=reSjqyV7Vx7mxYNpwY6x0nOsVnPeCj6ePppeHMPHC5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR6Q26DDKg/KoNc1rEfZrPEDs+5whBK4eAWPpaLaFPt20n5mUjEQSl7j9atNfshJX
         qvz3i8bpCrm9WXZBvXM0E0vg0HvibabQhTIQG39P3GsDkix31PqDJGPDTtBXyCfafL
         2ojPvhV1wwE57syn1dPGrt9KizY96hQPQ+jj+/WV4V97O0FJ0GeRczPxZFOReX1Kn1
         WloelIfSi/dgTr2a858KaMZflFmWs3SdnakvNgrEzlhLeAgHb93hD/pRW+XKFzAuTM
         CVqTjPuodDCf7nVUcPhoEMuYzLcsGaPvTjglW+lWgwl16/CFkYlKVf1dE8fjm7IXWk
         3evXPn5sHbJoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prarit Bhargava <prarit@redhat.com>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, lenb@kernel.org
Subject: [PATCH AUTOSEL 5.10 11/12] tools/power turbostat: Fix /dev/cpu_dma_latency warnings
Date:   Wed, 22 Mar 2023 16:02:05 -0400
Message-Id: <20230322200207.1997367-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200207.1997367-1-sashal@kernel.org>
References: <20230322200207.1997367-1-sashal@kernel.org>
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
index f6b7e85b121ce..71e3f3a68b9df 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -294,6 +294,8 @@ Alternatively, non-root users can be enabled to run turbostat this way:
 
 # chmod +r /dev/cpu/*/msr
 
+# chmod +r /dev/cpu_dma_latency
+
 .B "turbostat "
 reads hardware counters, but doesn't write them.
 So it will not interfere with the OS or other programs, including
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ef65f7eed1ec9..d33c9d427e573 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5004,7 +5004,7 @@ void print_dev_latency(void)
 
 	retval = read(fd, (void *)&value, sizeof(int));
 	if (retval != sizeof(int)) {
-		warn("read %s\n", path);
+		warn("read failed %s\n", path);
 		close(fd);
 		return;
 	}
-- 
2.39.2

