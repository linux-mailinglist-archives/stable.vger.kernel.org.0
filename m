Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6E74F3612
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243441AbiDEK6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346729AbiDEJpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ACADB493;
        Tue,  5 Apr 2022 02:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D29E5616D0;
        Tue,  5 Apr 2022 09:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF03DC385A2;
        Tue,  5 Apr 2022 09:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151089;
        bh=NvH7Cwwc01Bg0PNrrgFX0NR/Yp4IwfHNtTfRuL0jc18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWik0zca3HpVD5sRDXCrElz4O0rVyuHsWNIdd3D6E2XVNUe2HZnnJy2kiw16a4j2k
         t1CMWynNueX4FjnDSI8Cad/0/B9BtMr6M6zEKJLUcHRWBpBMTnL4QSuKrMI2emI+Dg
         syrhxHL6MIRV7zUJOsR+ur5HK87pP/q59CVU1Oxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/913] perf/x86/intel/pt: Fix address filter config for 32-bit kernel
Date:   Tue,  5 Apr 2022 09:21:54 +0200
Message-Id: <20220405070347.409913141@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit e5524bf1047eb3b3f3f33b5f59897ba67b3ade87 ]

Change from shifting 'unsigned long' to 'u64' to prevent the config bits
being lost on a 32-bit kernel.

Fixes: eadf48cab4b6b0 ("perf/x86/intel/pt: Add support for address range filtering in PT")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220131072453.2839535-5-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 2d33bba9a144..215aed65e978 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -472,7 +472,7 @@ static u64 pt_config_filters(struct perf_event *event)
 			pt->filters.filter[range].msr_b = filter->msr_b;
 		}
 
-		rtit_ctl |= filter->config << pt_address_ranges[range].reg_off;
+		rtit_ctl |= (u64)filter->config << pt_address_ranges[range].reg_off;
 	}
 
 	return rtit_ctl;
-- 
2.34.1



