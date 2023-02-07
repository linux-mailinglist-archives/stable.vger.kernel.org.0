Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2E568D83A
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjBGNHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjBGNHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2E83A5B8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B8A61408
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF37C433D2;
        Tue,  7 Feb 2023 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775195;
        bh=Fe4pM66UR2F/uBjXDzUQ3X9eZwkv0k/CIZWbTMy8RHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJeo1YQB/ELCfH+p8Y8FK6bfO2ORzkIIn72p+As03ldiy37qrw5HuZoBB8DHNx8k+
         yraP2jUdQ7toUKSshXtZ1joLhNME7MJREYThAqPlghq2ZSapoI2zVQzG8t1kekMdGU
         9lZTOF6UX8f66atj58uvz9qg1qWs9ewli3fnLjmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Longlong Xia <xialonglong1@huawei.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Chen Wandun <chenwandun@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 168/208] mm/swapfile: add cond_resched() in get_swap_pages()
Date:   Tue,  7 Feb 2023 13:57:02 +0100
Message-Id: <20230207125642.021209048@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longlong Xia <xialonglong1@huawei.com>

commit 7717fc1a12f88701573f9ed897cc4f6699c661e3 upstream.

The softlockup still occurs in get_swap_pages() under memory pressure.  64
CPU cores, 64GB memory, and 28 zram devices, the disksize of each zram
device is 50MB with same priority as si.  Use the stress-ng tool to
increase memory pressure, causing the system to oom frequently.

The plist_for_each_entry_safe() loops in get_swap_pages() could reach tens
of thousands of times to find available space (extreme case:
cond_resched() is not called in scan_swap_map_slots()).  Let's add
cond_resched() into get_swap_pages() when failed to find available space
to avoid softlockup.

Link: https://lkml.kernel.org/r/20230128094757.1060525-1-xialonglong1@huawei.com
Signed-off-by: Longlong Xia <xialonglong1@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1101,6 +1101,7 @@ start_over:
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
+		cond_resched();
 
 		spin_lock(&swap_avail_lock);
 nextsi:


