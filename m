Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A159D500F0E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244156AbiDNNYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244157AbiDNNXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2C8931AB;
        Thu, 14 Apr 2022 06:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE51BB8296D;
        Thu, 14 Apr 2022 13:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B093C385A9;
        Thu, 14 Apr 2022 13:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942300;
        bh=YzYdoFAUovGp9XFvdhbLvA+Gm3dS1OLtdWvF81MRMas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZTTVaMuL32XFNYh0V4ePeDmLSzKC606/mnELSIjt14kbqwJZU6efifySN3iYw37N
         paFy/ho8RFDmc/ngYKeHzrXseDdsIqxCgBDN0ErqlVUMBhyAm1FVkyQabAILYIQdSl
         sruSu9/gvP9AHJ4IKZxrmczw3iLBtMVYvKZjTDEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/338] perf/x86/intel/pt: Fix address filter config for 32-bit kernel
Date:   Thu, 14 Apr 2022 15:09:49 +0200
Message-Id: <20220414110841.347842591@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 849f0ba53a9b..49b3ea1c1ea1 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -460,7 +460,7 @@ static u64 pt_config_filters(struct perf_event *event)
 			pt->filters.filter[range].msr_b = filter->msr_b;
 		}
 
-		rtit_ctl |= filter->config << pt_address_ranges[range].reg_off;
+		rtit_ctl |= (u64)filter->config << pt_address_ranges[range].reg_off;
 	}
 
 	return rtit_ctl;
-- 
2.34.1



