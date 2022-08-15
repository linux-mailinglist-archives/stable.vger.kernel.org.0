Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A394593CB5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbiHOTyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345468AbiHOTx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD4E45982;
        Mon, 15 Aug 2022 11:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A218AB81057;
        Mon, 15 Aug 2022 18:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C7DC433D6;
        Mon, 15 Aug 2022 18:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589497;
        bh=r2kVNVinlWkjZTWdJsscXrmKGXmHoK6A7xEXISd9w5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhQKH3n9dCOhbKx1wGmVbAn/xje7V/hIHJtZqtzNTc72nYnEPGnGQy6sZoxOFWshq
         2fYGum1m5eflWYYlDxufRXMHVk6AJYrROJhtPKr39gijLHkumNbEXaX0+QJZFq8zz9
         9vYktU85aKmFuu34XC8DNbXhRHCEEyHU9hM8tkRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 737/779] dm raid: fix address sanitizer warning in raid_status
Date:   Mon, 15 Aug 2022 20:06:21 +0200
Message-Id: <20220815180408.946194050@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 1fbeea217d8f297fe0e0956a1516d14ba97d0396 ]

There is this warning when using a kernel with the address sanitizer
and running this testsuite:
https://gitlab.com/cki-project/kernel-tests/-/tree/main/storage/swraid/scsi_raid

==================================================================
BUG: KASAN: slab-out-of-bounds in raid_status+0x1747/0x2820 [dm_raid]
Read of size 4 at addr ffff888079d2c7e8 by task lvcreate/13319
CPU: 0 PID: 13319 Comm: lvcreate Not tainted 5.18.0-0.rc3.<snip> #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Call Trace:
 <TASK>
 dump_stack_lvl+0x6a/0x9c
 print_address_description.constprop.0+0x1f/0x1e0
 print_report.cold+0x55/0x244
 kasan_report+0xc9/0x100
 raid_status+0x1747/0x2820 [dm_raid]
 dm_ima_measure_on_table_load+0x4b8/0xca0 [dm_mod]
 table_load+0x35c/0x630 [dm_mod]
 ctl_ioctl+0x411/0x630 [dm_mod]
 dm_ctl_ioctl+0xa/0x10 [dm_mod]
 __x64_sys_ioctl+0x12a/0x1a0
 do_syscall_64+0x5b/0x80

The warning is caused by reading conf->max_nr_stripes in raid_status. The
code in raid_status reads mddev->private, casts it to struct r5conf and
reads the entry max_nr_stripes.

However, if we have different raid type than 4/5/6, mddev->private
doesn't point to struct r5conf; it may point to struct r0conf, struct
r1conf, struct r10conf or struct mpconf. If we cast a pointer to one
of these structs to struct r5conf, we will be reading invalid memory
and KASAN warns about it.

Fix this bug by reading struct r5conf only if raid type is 4, 5 or 6.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b0566aabc186..5f7e40c48e47 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3514,7 +3514,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 {
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf = rs_is_raid456(rs) ? mddev->private : NULL;
 	int i, max_nr_stripes = conf ? conf->max_nr_stripes : 0;
 	unsigned long recovery;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */
-- 
2.35.1



