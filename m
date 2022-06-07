Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446A8541DF2
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380589AbiFGWXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381670AbiFGWVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D6926C0D5;
        Tue,  7 Jun 2022 12:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E291B82182;
        Tue,  7 Jun 2022 19:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D43C34115;
        Tue,  7 Jun 2022 19:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629739;
        bh=AZp9GM2aIQXcY2X/5Buvw7LgLptr9W3PQ57LG/PVk8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KX1kOkY7DDLTzK4JaNBVoLx0lvjKHaByH4Ld0tzAAED8pq0vPMU1YzVrN67wwacbB
         LFOurdvUVJmF/E2a7NZqt03xJU4jrS/yzduT+gTKAP6ar5ZOaSLsuwINamHUc0GtEW
         lA7z3cpy/NtK1wBbFNJzCOHY0v+i4NcoDmKl7MC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.18 798/879] md: fix an incorrect NULL check in does_sb_need_changing
Date:   Tue,  7 Jun 2022 19:05:16 +0200
Message-Id: <20220607165026.024032950@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit fc8738343eefc4ea8afb6122826dea48eacde514 upstream.

The bug is here:
	if (!rdev)

The list iterator value 'rdev' will *always* be set and non-NULL
by rdev_for_each(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element found.
Otherwise it will bypass the NULL check and lead to invalid memory
access passing the check.

To fix the bug, use a new variable 'iter' as the list iterator,
while using the original variable 'rdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 2aa82191ac36 ("md-cluster: Perform a lazy update")
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Acked-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2627,14 +2627,16 @@ static void sync_sbs(struct mddev *mddev
 
 static bool does_sb_need_changing(struct mddev *mddev)
 {
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL, *iter;
 	struct mdp_superblock_1 *sb;
 	int role;
 
 	/* Find a good rdev */
-	rdev_for_each(rdev, mddev)
-		if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
+	rdev_for_each(iter, mddev)
+		if ((iter->raid_disk >= 0) && !test_bit(Faulty, &iter->flags)) {
+			rdev = iter;
 			break;
+		}
 
 	/* No good device found. */
 	if (!rdev)


