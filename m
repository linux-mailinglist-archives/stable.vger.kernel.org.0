Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C7F566AF7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbiGEMDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiGEMCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA0C1091;
        Tue,  5 Jul 2022 05:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC53DB817CC;
        Tue,  5 Jul 2022 12:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3143BC341C7;
        Tue,  5 Jul 2022 12:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022568;
        bh=zKBhc+JcZSs1Vi0bBzDnLQe1tRnaW45vFC1cLNXiYTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFh5I+bmMHUqmDbA+aIipQh/neahbf0ICchV9Ubt+FIlizELJkVmNHW4TUKHd1BCR
         Q3oo+FhdR+vH+PEQxQkY6gg+BJsDRnvIDmz8/mrlFA5EqR3tgLs9ckCKHM4sLzlLnf
         mjrTBFcTv6GZnhRmiQPW5mLjROeH4o9uFVz/BB7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 03/33] dm raid: fix KASAN warning in raid5_add_disks
Date:   Tue,  5 Jul 2022 13:57:55 +0200
Message-Id: <20220705115606.811852146@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 617b365872a247480e9dcd50a32c8d1806b21861 upstream.

There's a KASAN warning in raid5_add_disk when running the LVM testsuite.
The warning happens in the test
lvconvert-raid-reshape-linear_to_raid6-single-type.sh. We fix the warning
by verifying that rdev->saved_raid_disk is within limits.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7716,6 +7716,7 @@ static int raid5_add_disk(struct mddev *
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
 	    rdev->saved_raid_disk >= first &&
+	    rdev->saved_raid_disk <= last &&
 	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
 		first = rdev->saved_raid_disk;
 


