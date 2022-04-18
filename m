Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE905057CD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244128AbiDRN47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243897AbiDRNzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:55:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53201FA;
        Mon, 18 Apr 2022 06:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A8DE60EF6;
        Mon, 18 Apr 2022 13:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8ACC385A7;
        Mon, 18 Apr 2022 13:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287084;
        bh=aJDnQahAdolgCm31aFSMor8WM5Dq3BlzHYzAoX8UhME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXYK3ZCbzE5lhVeS3dDRmqCNLX9rT26EncnpKw06M2wMgnL4OiBms3xgHhB3S0Rp7
         iQVsUjx8on+K4vX+7eG5c2znZtURpwmjMdom2kZ7s5khRzg/WzysWclcaRtB8c3irt
         s3VIYjKbmMR0AMJVcf0p7zUzZqh1Fm4P1QmkCDtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/218] perf/core: Fix address filter parser for multiple filters
Date:   Mon, 18 Apr 2022 14:11:59 +0200
Message-Id: <20220418121201.130751827@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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
index e56a74fd5c81..396abd52962b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8306,8 +8306,11 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
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



