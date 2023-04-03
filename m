Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF206D4A43
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjDCOpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjDCOpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C31A17AF4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 982ECB81D44
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB45C433D2;
        Mon,  3 Apr 2023 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533108;
        bh=jiBHGv/Qc37ebIMDLVhnDSbtaYWP9xZ76vBBWTmM94I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSm79IEM3iZVVHuZVZq+gEtH7wP67vPLo9UEeU2eqW4GQIwS11kRvD3UbYP0ghCr1
         y98vo4N25LOB6vPd55ykf+Lt3INKMWxwI6StQFJzZV6a+11/xm6+3q5zsTwe/hmSpy
         DPplKZ0KuRTVbpn8csVRFLzP8RRs1WGPGPnzhfNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Antti Laakso <antti.laakso@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 058/187] tools/power turbostat: fix decoding of HWP_STATUS
Date:   Mon,  3 Apr 2023 16:08:23 +0200
Message-Id: <20230403140417.867335171@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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
index c24054e3ef7ad..c61c6c704fbe6 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4426,7 +4426,7 @@ int print_hwp(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 
 	fprintf(outf, "cpu%d: MSR_HWP_STATUS: 0x%08llx "
 		"(%sGuaranteed_Perf_Change, %sExcursion_Min)\n",
-		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x2) ? "" : "No-");
+		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x4) ? "" : "No-");
 
 	return 0;
 }
-- 
2.39.2



