Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D17548F87
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348254AbiFMK4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348769AbiFMKyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7752ED6C;
        Mon, 13 Jun 2022 03:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C90F60ED7;
        Mon, 13 Jun 2022 10:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71057C3411E;
        Mon, 13 Jun 2022 10:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116069;
        bh=MH+jVAq6gHql77W/E2asVonBTzuDrvB/pKfbqPiaEQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWf9LHGrShST8q1nrLZqczSzi+JILhEOIQ26rDRCTjgGPB1OsXDLGTbShoGsJWJuE
         tFw4HBotT41FzgBeLnTlow7Rv3IvZGaC9//iRhpdN+ukB8coyeu52nMGQx+livQ757
         5Ig7EsC+jhbEDWdfNLGvhSjB1f4uVU2osUp4Xm5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 4.14 117/218] md: fix an incorrect NULL check in does_sb_need_changing
Date:   Mon, 13 Jun 2022 12:09:35 +0200
Message-Id: <20220613094924.117838903@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
@@ -2427,14 +2427,16 @@ static void sync_sbs(struct mddev *mddev
 
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


