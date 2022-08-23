Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00C359D9FC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351929AbiHWKEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352526AbiHWKCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBE8A260B;
        Tue, 23 Aug 2022 01:49:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A08F2B81B90;
        Tue, 23 Aug 2022 08:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014EEC433C1;
        Tue, 23 Aug 2022 08:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244597;
        bh=BONo5jgRyauoo1vO9FpGyfO7DzEIhl66XISMXw96hok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0SILXfmAfUUYPHFm1Q5gl1NA98kNdK9H6Dd5F/aJBvwTB+4X2klp1xEeF6XgRD6F
         g2io4jfG1Avh1hClHfRA8D8FgBFApDpW3mFo4L5BPFfPP24WDKCYC1zfde9Za+OHBn
         DFylVDsY36IU0dMjKT885J3AgR1dS1BIZzis99dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.14 162/229] dm raid: fix address sanitizer warning in raid_resume
Date:   Tue, 23 Aug 2022 10:25:23 +0200
Message-Id: <20220823080059.462238932@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

commit 7dad24db59d2d2803576f2e3645728866a056dab upstream.

There is a KASAN warning in raid_resume when running the lvm test
lvconvert-raid.sh. The reason for the warning is that mddev->raid_disks
is greater than rs->raid_disks, so the loop touches one entry beyond
the allocated length.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3669,7 +3669,7 @@ static void attempt_restore_of_faulty_de
 
 	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
 
-	for (i = 0; i < mddev->raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		/* HM FIXME: enhance journal device recovery processing */
 		if (test_bit(Journal, &r->flags))


