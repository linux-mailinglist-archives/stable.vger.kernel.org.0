Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28521529054
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiEPUIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349954AbiEPUAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489FF45517;
        Mon, 16 May 2022 12:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3600FB81617;
        Mon, 16 May 2022 19:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FFFC385AA;
        Mon, 16 May 2022 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730832;
        bh=cUzcoaeHTlTCzNsg517wxzSG6ZQ2TVLim9ksCWTVrj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBDRPEr7+gCdGqduPf5vD8dHhPaw+BVhe7pZQRRCprysobcSJXUXAYBQc3f5vbISp
         eUN+nJ+aKE6j7K0rdEkuvWtzSpQ+SkPrIQdZsdxTB3o03UZkQPqiSGsVqCISHq3Gbp
         7HV2lkMBzNAKhjOxCIkNyB6H+FqXwsu6JGYQ2drY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.17 002/114] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Date:   Mon, 16 May 2022 21:35:36 +0200
Message-Id: <20220516193625.563527053@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 7635a1ad8d92dcc8247b53f949e37795154b5b6f ]

In Chrome OS, a large number of crashes is observed due to corrupted timer
lists. Steven Rostedt pointed out that this usually happens when a timer
is freed while still active, and that the problem is often triggered
by code calling del_timer() instead of del_timer_sync() just before
freeing.

Steven also identified the iwlwifi driver as one of the possible culprits
since it does exactly that.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API support")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Gregory Greenman <gregory.greenman@intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # Linux v5.17.3-rc1 and Debian LLVM-14
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220411154210.1870008-1-linux@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 42f6f8bb83be..901600ca6f0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -362,7 +362,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans *trans)
 	struct iwl_dbg_tlv_timer_node *node, *tmp;
 
 	list_for_each_entry_safe(node, tmp, timer_list, list) {
-		del_timer(&node->timer);
+		del_timer_sync(&node->timer);
 		list_del(&node->list);
 		kfree(node);
 	}
-- 
2.35.1



