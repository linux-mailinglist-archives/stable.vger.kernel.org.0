Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CAC566A71
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 13:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiGEL7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 07:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiGEL7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 07:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF7526EA;
        Tue,  5 Jul 2022 04:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6767561786;
        Tue,  5 Jul 2022 11:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738BDC341C7;
        Tue,  5 Jul 2022 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022361;
        bh=qOI3ZxHHACL3+QQiOQ3xfjJlVfbHoZv8uvwUZcnjSYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lc8rGL4ODglQspiE4oHmTEKn8xXmsvCRfcM5/THkB0+iD5OrEPWolqkdyuvspOqSv
         aSPpgg3Q9LE0QCnlcc9LhDcPCbTi05g5J0il/jpmakpiVAqKlWTDCoTYmo9Bwh4Fyz
         XViXZz4Ozp8NaTXA/oZplNBxG0WRhEMl/JWgZXtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.9 01/29] dm raid: fix KASAN warning in raid5_add_disks
Date:   Tue,  5 Jul 2022 13:57:42 +0200
Message-Id: <20220705115605.787481910@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
References: <20220705115605.742248854@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -7322,6 +7322,7 @@ static int raid5_add_disk(struct mddev *
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
 	    rdev->saved_raid_disk >= first &&
+	    rdev->saved_raid_disk <= last &&
 	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
 		first = rdev->saved_raid_disk;
 


