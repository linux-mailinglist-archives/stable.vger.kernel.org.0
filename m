Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21C3592E4E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiHOLnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiHOLnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:43:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8399524BF0
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 288866116A
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22330C433C1;
        Mon, 15 Aug 2022 11:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660563792;
        bh=kpJOdR4xwGIQR2G8hz6iPUIAmvRmL/57VSXeYeBC20U=;
        h=Subject:To:Cc:From:Date:From;
        b=vOcx2rZHIxr9sV3OYIGwVqZQ6P9NlZRFaZv8ml7bkjhByrDWydsOlJJnleu4kAjrW
         6phxq9yGNDzEOAa4LLr9Tk1v0Q7EDcLyq9ufH1IMsngRPZDV93n1eBPiouvik4hqhJ
         maPvcidkL/rHMTCHRXywBP0MLAmkqbZO1E8Mbr4o=
Subject: FAILED: patch "[PATCH] dm raid: fix address sanitizer warning in raid_resume" failed to apply to 4.9-stable tree
To:     mpatocka@redhat.com, snitzer@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:43:09 +0200
Message-ID: <16605637897249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7dad24db59d2d2803576f2e3645728866a056dab Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sun, 24 Jul 2022 14:33:52 -0400
Subject: [PATCH] dm raid: fix address sanitizer warning in raid_resume

There is a KASAN warning in raid_resume when running the lvm test
lvconvert-raid.sh. The reason for the warning is that mddev->raid_disks
is greater than rs->raid_disks, so the loop touches one entry beyond
the allocated length.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f41fd3cf5c7d..e6a9b8cb22d3 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3817,7 +3817,7 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 
 	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
 
-	for (i = 0; i < mddev->raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		/* HM FIXME: enhance journal device recovery processing */
 		if (test_bit(Journal, &r->flags))

