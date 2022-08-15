Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F30593BCD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbiHOTyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345475AbiHOTxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CF43205A;
        Mon, 15 Aug 2022 11:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A97B6B810A0;
        Mon, 15 Aug 2022 18:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1650CC433D6;
        Mon, 15 Aug 2022 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589500;
        bh=TxKAbx4QRMRivSlFf4ukwAugW2WTjATdCUdXwMbEo6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lv3/okeiv1yeL6R35tpxVFk4JHyeasWAm2ag1NRnrhVasJu1K63ZvRElrtN+VpNKP
         kNTH3T5earBbb4Jx0TTkfLXOHCLRRAp/WHR1uPvgutyIXz4dZuVUvheUthhyhgcNfn
         JtsZxvfj7xu/acwsH+tWKdukNqZNvl3yq7IXM9eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 738/779] dm raid: fix address sanitizer warning in raid_resume
Date:   Mon, 15 Aug 2022 20:06:22 +0200
Message-Id: <20220815180408.984998844@linuxfoundation.org>
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

[ Upstream commit 7dad24db59d2d2803576f2e3645728866a056dab ]

There is a KASAN warning in raid_resume when running the lvm test
lvconvert-raid.sh. The reason for the warning is that mddev->raid_disks
is greater than rs->raid_disks, so the loop touches one entry beyond
the allocated length.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5f7e40c48e47..eba277bb8a1f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3824,7 +3824,7 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 
 	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
 
-	for (i = 0; i < mddev->raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		/* HM FIXME: enhance journal device recovery processing */
 		if (test_bit(Journal, &r->flags))
-- 
2.35.1



