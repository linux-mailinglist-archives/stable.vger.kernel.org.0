Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9050A564EE3
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 09:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiGDHlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 03:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiGDHlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 03:41:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EECD95AD
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 00:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE26610A7
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 07:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CC3C3411E;
        Mon,  4 Jul 2022 07:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656920480;
        bh=eROokVARsn6x7zLsmNNZwDGsfv/slJ2+aIlt2JLZUP0=;
        h=Subject:To:Cc:From:Date:From;
        b=E/Rwhahzt5OfGjQgIK6FGomM9T5tMeYKY50iHCHF3N637rVb5kQy6aVpfpI6lCOxQ
         6tjc1mVsLyNhcEO5j6mhGv2U3rmZmQeD9vnnhBijhISNQx2dIu9RBmk6B9vAcBOvpI
         O9qMcL8Bzegg7ShlHsUFx/s4s1phASsScqrM+nTo=
Subject: FAILED: patch "[PATCH] dm raid: fix KASAN warning in raid5_remove_disk" failed to apply to 5.15-stable tree
To:     mpatocka@redhat.com, snitzer@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 09:41:02 +0200
Message-ID: <165692046217019@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ebc2cec0b7dd8dad0812449110803bd875ac816 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 29 Jun 2022 13:40:01 -0400
Subject: [PATCH] dm raid: fix KASAN warning in raid5_remove_disk

There's a KASAN warning in raid5_remove_disk when running the LVM
testsuite. We fix this warning by verifying that the "number" variable is
within limits.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5d09256d7f81..ba289411f26f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7933,7 +7933,7 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev __rcu **rdevp;
-	struct disk_info *p = conf->disks + number;
+	struct disk_info *p;
 	struct md_rdev *tmp;
 
 	print_raid5_conf(conf);
@@ -7952,6 +7952,9 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		log_exit(conf);
 		return 0;
 	}
+	if (unlikely(number >= conf->pool_size))
+		return 0;
+	p = conf->disks + number;
 	if (rdev == rcu_access_pointer(p->rdev))
 		rdevp = &p->rdev;
 	else if (rdev == rcu_access_pointer(p->replacement))

