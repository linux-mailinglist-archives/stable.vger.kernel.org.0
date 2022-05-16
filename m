Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E92E528F52
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbiEPTyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347725AbiEPTwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EDC41FAA;
        Mon, 16 May 2022 12:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0677660A6A;
        Mon, 16 May 2022 19:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EFFC385AA;
        Mon, 16 May 2022 19:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730470;
        bh=7LQLF750A6OWLQ2+tAwZUqWvU+022dEv0p9CNMvLXF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR42jwmTcE9OukT1qlJHLC+07kREjjnqyj1qkJb1/gJL/KULiXxqSrqCbNHK2C2zn
         R5LOzM+cYkbifx9muhtV4Ngx24ndvJ9D7R3f5EuXG2sBWFuirZwl2ivCHOcx1hI6c5
         hIi8pqNXrsyJ7icpAXLyAChioXvaisrntdt7BZ0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.15 002/102] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Date:   Mon, 16 May 2022 21:35:36 +0200
Message-Id: <20220516193624.062202071@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 125479b5c0d6..fc4197bf2478 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -322,7 +322,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans *trans)
 	struct iwl_dbg_tlv_timer_node *node, *tmp;
 
 	list_for_each_entry_safe(node, tmp, timer_list, list) {
-		del_timer(&node->timer);
+		del_timer_sync(&node->timer);
 		list_del(&node->list);
 		kfree(node);
 	}
-- 
2.35.1



