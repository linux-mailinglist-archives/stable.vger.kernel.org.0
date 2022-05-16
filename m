Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0D2528EBB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346271AbiEPTuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346283AbiEPTtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B422433BA;
        Mon, 16 May 2022 12:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45B2861512;
        Mon, 16 May 2022 19:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A61EC34115;
        Mon, 16 May 2022 19:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730297;
        bh=L5m26iIlOdgBK58M1rRzRjKkQm9Am+GRNIiFSrxU1KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPzcTFlr0Ax5CqpYUwwLrTATOK3Hy7b+JWdQqX7pYKFpiYaCV+BRvqiQW4JjBnApF
         dA42LRzYKmIEqExU4vDOz3h4XOk8er5rdNEXpKi0ziyJUKrHgjrVMixlw0x0WDG9Gs
         G/Xm/DIiO19XtS9w/ouvbYn4hF1AZ5bLZ7q0Dxrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.10 02/66] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Date:   Mon, 16 May 2022 21:36:02 +0200
Message-Id: <20220516193619.473226461@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
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
index fcad5cdcabfa..3c931b1b2a0b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -367,7 +367,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans *trans)
 	struct iwl_dbg_tlv_timer_node *node, *tmp;
 
 	list_for_each_entry_safe(node, tmp, timer_list, list) {
-		del_timer(&node->timer);
+		del_timer_sync(&node->timer);
 		list_del(&node->list);
 		kfree(node);
 	}
-- 
2.35.1



