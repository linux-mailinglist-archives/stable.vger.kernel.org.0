Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E7594076
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245673AbiHOVUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347279AbiHOVSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EB7E395C;
        Mon, 15 Aug 2022 12:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 045FF61028;
        Mon, 15 Aug 2022 19:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2EBC433D6;
        Mon, 15 Aug 2022 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591315;
        bh=waPGeb73Tsj2NRxcAjuBsLWHF18iKihkY/VAnSl59Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLwAzDxz9fXzKKnLbg7mxxtykhgorKy3wG6btzRNVAyftfALR+RB906fSBwI56mtG
         zrhOd3rI6AVKpnxpRRgMD5BDON3V3ukDz+XpKNcv/LJSga1dqt4mSuO4IwhvEtyHb7
         aOgnHR7WJEKKT1PgMKYQQm8/+fF+9edxqyzSjK3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takayuki Nagata <tnagata@redhat.com>,
        Petr Stourac <pstourac@redhat.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0506/1095] wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue
Date:   Mon, 15 Aug 2022 19:58:25 +0200
Message-Id: <20220815180450.461538557@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 14a3aacf517a9de725dd3219dbbcf741e31763c4 ]

After successfull station association, if station queues are disabled for
some reason, the related lists are not emptied. So if some new element is
added to the list in iwl_mvm_mac_wake_tx_queue, it can match with the old
one and produce a BUG like this:

[   46.535263] list_add corruption. prev->next should be next (ffff94c1c318a360), but was 0000000000000000. (prev=ffff94c1d02d3388).
[   46.535283] ------------[ cut here ]------------
[   46.535284] kernel BUG at lib/list_debug.c:26!
[   46.535290] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[   46.585304] CPU: 0 PID: 623 Comm: wpa_supplicant Not tainted 5.19.0-rc3+ #1
[   46.592380] Hardware name: Dell Inc. Inspiron 660s/0478VN       , BIOS A07 08/24/2012
[   46.600336] RIP: 0010:__list_add_valid.cold+0x3d/0x3f
[   46.605475] Code: f2 4c 89 c1 48 89 fe 48 c7 c7 c8 40 67 93 e8 20 cc fd ff 0f 0b 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 70 40 67 93 e8 09 cc fd ff <0f> 0b 48 89 fe 48 c7 c7 00 41 67 93 e8 f8 cb fd ff 0f 0b 48 89 d1
[   46.624469] RSP: 0018:ffffb20800ab76d8 EFLAGS: 00010286
[   46.629854] RAX: 0000000000000075 RBX: ffff94c1c318a0e0 RCX: 0000000000000000
[   46.637105] RDX: 0000000000000201 RSI: ffffffff9365e100 RDI: 00000000ffffffff
[   46.644356] RBP: ffff94c1c5f43370 R08: 0000000000000075 R09: 3064316334396666
[   46.651607] R10: 3364323064316334 R11: 39666666663d7665 R12: ffff94c1c5f43388
[   46.658857] R13: ffff94c1d02d3388 R14: ffff94c1c318a360 R15: ffff94c1cf2289c0
[   46.666108] FS:  00007f65634ff7c0(0000) GS:ffff94c1da200000(0000) knlGS:0000000000000000
[   46.674331] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.680170] CR2: 00007f7dfe984460 CR3: 000000010e894003 CR4: 00000000000606f0
[   46.687422] Call Trace:
[   46.689906]  <TASK>
[   46.691950]  iwl_mvm_mac_wake_tx_queue+0xec/0x15c [iwlmvm]
[   46.697601]  ieee80211_queue_skb+0x4b3/0x720 [mac80211]
[   46.702973]  ? sta_info_get+0x46/0x60 [mac80211]
[   46.707703]  ieee80211_tx+0xad/0x110 [mac80211]
[   46.712355]  __ieee80211_tx_skb_tid_band+0x71/0x90 [mac80211]
...

In order to avoid this problem, we must also remove the related lists when
station queues are disabled.

Fixes: cfbc6c4c5b91c ("iwlwifi: mvm: support mac80211 TXQs model")
Reported-by: Takayuki Nagata <tnagata@redhat.com>
Reported-by: Petr Stourac <pstourac@redhat.com>
Tested-by: Petr Stourac <pstourac@redhat.com>
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220719153542.81466-1-jtornosm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index c7f9d3870f21..8a38d1bfe9b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1862,6 +1862,7 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 			iwl_mvm_txq_from_mac80211(sta->txq[i]);
 
 		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		list_del_init(&mvmtxq->list);
 	}
 }
 
-- 
2.35.1



