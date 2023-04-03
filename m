Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6B96D48E4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbjDCOcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjDCOcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:32:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224BFE4E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:32:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1D32B81C76
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235B9C433D2;
        Mon,  3 Apr 2023 14:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532359;
        bh=d2kJloD1m/EvDPqToiYYJTD3x8xotyhjKibguqq2vME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMEqcEAhtU8yIBfyDhyLelbzgErzRByEarGQXH5hCjeBiHePWn4trA7aT6xd7nAgV
         1G+yb49y1/nbjsSdSRQrZow5d3NRTiN2TV3Hdtp/7bSrUFm09xIZ63k9AgPvRCo1xR
         U2yy4t6qYEkmGHwJ0a6TobS5DUNi8ObDnFngtL9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Antti Laakso <antti.laakso@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/99] tools/power turbostat: fix decoding of HWP_STATUS
Date:   Mon,  3 Apr 2023 16:08:45 +0200
Message-Id: <20230403140402.579048052@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antti Laakso <antti.laakso@intel.com>

[ Upstream commit 92c25393586ac799b9b7d9e50434f3c44a7622c4 ]

The "excursion to minimum" information is in bit2
in HWP_STATUS MSR. Fix the bitmask used for
decoding the register.

Signed-off-by: Antti Laakso <antti.laakso@intel.com>
Reviewed-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 84b8a35c91972..a3197efe52c63 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4241,7 +4241,7 @@ int print_hwp(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 
 	fprintf(outf, "cpu%d: MSR_HWP_STATUS: 0x%08llx "
 		"(%sGuaranteed_Perf_Change, %sExcursion_Min)\n",
-		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x2) ? "" : "No-");
+		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x4) ? "" : "No-");
 
 	return 0;
 }
-- 
2.39.2



