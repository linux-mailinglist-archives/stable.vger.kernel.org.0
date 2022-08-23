Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E55059D5EB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243645AbiHWIcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344685AbiHWIbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:31:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEF766128;
        Tue, 23 Aug 2022 01:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F7E461321;
        Tue, 23 Aug 2022 08:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47543C433C1;
        Tue, 23 Aug 2022 08:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242514;
        bh=CWO5cFi5S/7DCwalQ4rsgZB2IdcrAI+RfNDTo4EngAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BIw3SK5GAXj+jXrVSwOggdpypn9s/J1tNCZssupVYwL2tEo7moYWnKTZxYOTWEyx
         duILYV6C/rIiVXKHaoMj+IilcymbLmDZCwhA4rVLdOEtWmDDN/lbtTnGkCIysucjwQ
         uy2z3c7/UH05Tx3YClMe1V2rxAExaRiSNJFH30sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.9 056/101] dm raid: fix address sanitizer warning in raid_status
Date:   Tue, 23 Aug 2022 10:03:29 +0200
Message-Id: <20220823080036.696134505@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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

commit 1fbeea217d8f297fe0e0956a1516d14ba97d0396 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3173,7 +3173,7 @@ static void raid_status(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf = rs_is_raid456(rs) ? mddev->private : NULL;
 	int i, max_nr_stripes = conf ? conf->max_nr_stripes : 0;
 	bool array_in_sync;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */


