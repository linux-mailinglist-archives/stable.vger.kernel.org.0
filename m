Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35426D4713
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjDCOQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbjDCOQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:16:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E7F22E90
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E48E961CCE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2477C433EF;
        Mon,  3 Apr 2023 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531410;
        bh=NxzOtRQu6KigYzzhwtqdp249Roma4xVFBm/yW7xDUEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iz4Jyic+G5NbhCEt8qPfSQjTuWHZL6LgITnXikXzdQQ4fvVVERosVBaHEVVaWTOPO
         Cd0lJyW634lHSVibbLc+WY9xOkPgmJFCF/g/4RFGg6YNJulLZf9tc3VFKPcsk20R7s
         qtjU64L6kcBJ42L3a7NZxeP1U5LlAHiR6Y2SkyMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        NeilBrown <neilb@suse.de>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/84] md: avoid signed overflow in slot_store()
Date:   Mon,  3 Apr 2023 16:08:53 +0200
Message-Id: <20230403140355.203256694@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 89d4dcc5253e5..f8c111b369928 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2991,6 +2991,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
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



