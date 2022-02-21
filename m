Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DBE4BDC3A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352191AbiBUKDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:03:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353294AbiBUJ5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5726046B05;
        Mon, 21 Feb 2022 01:25:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3E47B80EC9;
        Mon, 21 Feb 2022 09:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248A5C340EC;
        Mon, 21 Feb 2022 09:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435514;
        bh=E10zvqeQW5+Fg49smzsMnHYL12P0GYgW1UwTNysAPfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJQ/PoU2RpzMIV1Nz4MemJR+IbjnLsDeoMezwD6ZV3Ocwt5T60O8LrklM1ZdTwlCe
         4MTbgICtdJNZiQWsbg8VXNsLESCFOlKOgS0hDqq9lSaYJCTeSibYeQnLsHyrr08KYt
         GMe8AKTqCzEECXRsESuGdvIP+UhVs0m3C7d0tcTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cheng Jui Wang <cheng-jui.wang@mediatek.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 5.16 191/227] lockdep: Correct lock_classes index mapping
Date:   Mon, 21 Feb 2022 09:50:10 +0100
Message-Id: <20220221084941.166145669@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Cheng Jui Wang <cheng-jui.wang@mediatek.com>

commit 28df029d53a2fd80c1b8674d47895648ad26dcfb upstream.

A kernel exception was hit when trying to dump /proc/lockdep_chains after
lockdep report "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!":

Unable to handle kernel paging request at virtual address 00054005450e05c3
...
00054005450e05c3] address between user and kernel address ranges
...
pc : [0xffffffece769b3a8] string+0x50/0x10c
lr : [0xffffffece769ac88] vsnprintf+0x468/0x69c
...
 Call trace:
  string+0x50/0x10c
  vsnprintf+0x468/0x69c
  seq_printf+0x8c/0xd8
  print_name+0x64/0xf4
  lc_show+0xb8/0x128
  seq_read_iter+0x3cc/0x5fc
  proc_reg_read_iter+0xdc/0x1d4

The cause of the problem is the function lock_chain_get_class() will
shift lock_classes index by 1, but the index don't need to be shifted
anymore since commit 01bb6f0af992 ("locking/lockdep: Change the range
of class_idx in held_lock struct") already change the index to start
from 0.

The lock_classes[-1] located at chain_hlocks array. When printing
lock_classes[-1] after the chain_hlocks entries are modified, the
exception happened.

The output of lockdep_chains are incorrect due to this problem too.

Fixes: f611e8cf98ec ("lockdep: Take read/write status in consideration when generate chainkey")
Signed-off-by: Cheng Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20220210105011.21712-1-cheng-jui.wang@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/lockdep.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3462,7 +3462,7 @@ struct lock_class *lock_chain_get_class(
 	u16 chain_hlock = chain_hlocks[chain->base + i];
 	unsigned int class_idx = chain_hlock_class_idx(chain_hlock);
 
-	return lock_classes + class_idx - 1;
+	return lock_classes + class_idx;
 }
 
 /*
@@ -3530,7 +3530,7 @@ static void print_chain_keys_chain(struc
 		hlock_id = chain_hlocks[chain->base + i];
 		chain_key = print_chain_key_iteration(hlock_id, chain_key);
 
-		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id) - 1);
+		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id));
 		printk("\n");
 	}
 }


