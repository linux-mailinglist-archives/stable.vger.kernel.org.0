Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C1C5AB112
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbiIBNDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238419AbiIBNCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:02:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB2ED34E9;
        Fri,  2 Sep 2022 05:41:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33705B829FB;
        Fri,  2 Sep 2022 12:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBA1C433C1;
        Fri,  2 Sep 2022 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122392;
        bh=6hLifgpSQoFJmNrN2OD//Blc0nqMW0j+eEoAYhRhqtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9e4QTCMzTBaojJq7t5i/aQgMbq7COHAMxJssIU40uGZb6NaUZLRZxvNpnnr4CWVY
         SU5QJWCnXZMAZ4EJQDpQRiZ2a0aqfincZNHM1WLXRvAA4OnK8XPjt11hdTmPRkmSlD
         tJrbAfyl3HMPIBuXcanRq0qOUFSvJnk8hYSKwj2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 32/37] xfs: always succeed at setting the reserve pool size
Date:   Fri,  2 Sep 2022 14:19:54 +0200
Message-Id: <20220902121400.180514184@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit 0baa2657dc4d79202148be79a3dc36c35f425060 upstream.

Nowadays, xfs_mod_fdblocks will always choose to fill the reserve pool
with freed blocks before adding to fdblocks.  Therefore, we can change
the behavior of xfs_reserve_blocks slightly -- setting the target size
of the pool should always succeed, since a deficiency will eventually
be made up as blocks get freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsops.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -380,11 +380,14 @@ xfs_reserve_blocks(
 	 * The code below estimates how many blocks it can request from
 	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
 	 * race since fdblocks updates are not always coordinated via
-	 * m_sb_lock.
+	 * m_sb_lock.  Set the reserve size even if there's not enough free
+	 * space to fill it because mod_fdblocks will refill an undersized
+	 * reserve when it can.
 	 */
 	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
 	delta = request - mp->m_resblks;
+	mp->m_resblks = request;
 	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
@@ -401,10 +404,8 @@ xfs_reserve_blocks(
 		 * Update the reserve counters if blocks have been successfully
 		 * allocated.
 		 */
-		if (!error) {
-			mp->m_resblks += fdblks_delta;
+		if (!error)
 			mp->m_resblks_avail += fdblks_delta;
-		}
 	}
 out:
 	if (outval) {


