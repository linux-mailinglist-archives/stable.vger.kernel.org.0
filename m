Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055996C56AD
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjCVUIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjCVUH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:07:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC5764A92;
        Wed, 22 Mar 2023 13:01:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEB43B81DEF;
        Wed, 22 Mar 2023 20:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D2AC433D2;
        Wed, 22 Mar 2023 20:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515287;
        bh=p1R/Ad0he83YE2u1+oXwn0yoaMGKewX0nYOTQhn+ZNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFi92h63xtqyXKRR9SNuHSYx1Fgr4DVxwSXAfGSNTfF/7m8bUB2QOXMzoh48JRvkQ
         yojcdYAEw6Vtw8CoWnEdvsienDhFqDrA5RIzyOmNtzNNyjkQLyY0K0Gb8QIbhBBXT8
         ktCcy+8WnSav+8zqgCLGYk06V/cgxasHFBgzAPR74yHxNJHCx/mHq8HBjXLe4PPlvw
         XCEt1pnq5F+nclTDlNt4i01OVg9A6oU2Hl7cuVLaV9vd46CGQZx+iP5ZnPZ9AhU5VE
         Ti1aImscV4asQdypaI/g5TwJp2r0BB41PwLJAqBamos1Tz1PoRDui0grrihDESXN/S
         ON9UjWeHyZ0dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>, Dan Carpenter <error27@gmail.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/16] md: avoid signed overflow in slot_store()
Date:   Wed, 22 Mar 2023 16:01:07 -0400
Message-Id: <20230322200121.1997157-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200121.1997157-1-sashal@kernel.org>
References: <20230322200121.1997157-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 3bc57292278a0b6ac4656cad94c14f2453344b57 ]

slot_store() uses kstrtouint() to get a slot number, but stores the
result in an "int" variable (by casting a pointer).
This can result in a negative slot number if the unsigned int value is
very large.

A negative number means that the slot is empty, but setting a negative
slot number this way will not remove the device from the array.  I don't
think this is a serious problem, but it could cause confusion and it is
best to fix it.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9e54b865f30da..bd0c9dfac9815 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3189,6 +3189,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
-- 
2.39.2

