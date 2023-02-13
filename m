Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5008A694A00
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjBMPDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjBMPDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8E61E2B2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D9561122
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B326C433D2;
        Mon, 13 Feb 2023 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300606;
        bh=DNzH7D/PL8xDaeix5yR2eBXdbo7lfTEvocYd93HBSgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQr8RKKJeNcyEsH4HMSzEgNUPLwrkLGv53lZCm3VAIYCM1MvHCxxN0/YZQ/rGmuc4
         Ys8KNHI8jT3cYZ11NoiZkJp34FGrGJPEKa04FS4ClHGw/4OtX1EDs/D9YYH+oee2t1
         q1cHXtmXaP1npG2iPtKEgabXo8G1VyUYa5jbT1q4=
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
Subject: [PATCH 5.10 079/139] mm/swapfile: add cond_resched() in get_swap_pages()
Date:   Mon, 13 Feb 2023 15:50:24 +0100
Message-Id: <20230213144750.033352330@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
@@ -1104,6 +1104,7 @@ start_over:
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
+		cond_resched();
 
 		spin_lock(&swap_avail_lock);
 nextsi:


