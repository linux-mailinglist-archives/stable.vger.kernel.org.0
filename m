Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F7505576
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242783AbiDRNOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241138AbiDRNLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:11:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C03E3983D;
        Mon, 18 Apr 2022 05:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09FEAB80E4B;
        Mon, 18 Apr 2022 12:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A51EC385A1;
        Mon, 18 Apr 2022 12:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286233;
        bh=HQCpx33vyRLby1m3u6tUxCLiMO0pt5p7L09eWaKirC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDshMKBbxNWVEhS+q+kiVGmWdEyfl7gYCH8qLRl1fu9cfg7XtCGz2IE0qeIKGz52C
         snGoN5qpJsvu4c3ThZEI9y+2c10UQXMOA9tPYJ/m9RevborTLbDO+4RqBT+1dGySis
         7uoHYr+BD7mCL5u8rOIhj7psmAMxLENhczQrBJ9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/284] perf/core: Fix address filter parser for multiple filters
Date:   Mon, 18 Apr 2022 14:10:50 +0200
Message-Id: <20220418121212.651325774@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d680ff24e9e14444c63945b43a37ede7cd6958f9 ]

Reset appropriate variables in the parser loop between parsing separate
filters, so that they do not interfere with parsing the next filter.

Fixes: 375637bc524952 ("perf/core: Introduce address range filtering")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220131072453.2839535-4-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 54da9e12381f..0f49ab48cb14 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8641,8 +8641,11 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 			}
 
 			/* ready to consume more filters */
+			kfree(filename);
+			filename = NULL;
 			state = IF_STATE_ACTION;
 			filter = NULL;
+			kernel = 0;
 		}
 	}
 
-- 
2.34.1



