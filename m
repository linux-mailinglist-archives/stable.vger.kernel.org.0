Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DD24F27C4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiDEIIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbiDEH5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5704E39D;
        Tue,  5 Apr 2022 00:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB24616DF;
        Tue,  5 Apr 2022 07:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD09C340EE;
        Tue,  5 Apr 2022 07:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145069;
        bh=pX0CfYZCeQp8gvJICNjx0ctHFHPgELNEM/GZ3dqwyq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4n7HMdiUouUOtJU8BvcMXqplpN0rN4HeZvhLpDpGwCVkpwJsD0WXerKAVctcXwqG
         O503rai5N+MLbmn+H0thnM/RmRsrQrGFyin9U4l2qXbOTz6lxjT02kTE0bnyFfkDwi
         sYTvle/EG7GC9eYk7zsW1ooQzmRrF44I9cx2HPRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0274/1126] perf/core: Fix address filter parser for multiple filters
Date:   Tue,  5 Apr 2022 09:17:01 +0200
Message-Id: <20220405070415.652707892@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 6859229497b1..69cf71d97312 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10574,8 +10574,11 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
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



