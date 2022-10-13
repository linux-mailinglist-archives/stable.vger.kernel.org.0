Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA05FD07A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiJMA12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiJMA0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:26:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5019B54;
        Wed, 12 Oct 2022 17:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EDCEB81CEA;
        Thu, 13 Oct 2022 00:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473D1C433B5;
        Thu, 13 Oct 2022 00:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620570;
        bh=6vbKmmz0ryFxKZLGyy2yrARzgTOezGzvxGBhsplRrh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkQzj/4xVc498tH3B0PNBa3dmDMBN6GlXRLZS3zIAul5tbHuSJe4n8rys1lQj++91
         +BJEHYrdEMPtJieMitjlF3youFSsUG+1bdEXeivi57Q/QAdVo0hJ5Bf3Vjv4zDEtc1
         DSYVxIseVsADj9EAo6kiw+7rZXJxzMEjmYNP9hpyn0MFZjEaQDhxWoNpcUp67p3sRq
         Z60x0ZkqR1L7jW5+kgemgISINuu38LthYZrPy/ghVHlKd2hKOkGuEP1nAyuakLSs7E
         ZqKGJ0LFvIt2DvoRwfAp8Oqsyni5RI6XrxVGQZHGjOXJJanGashwOI2KD7sHgnDtwv
         b1suka2kMqbGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     sunghwan jung <onenowy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: [PATCH AUTOSEL 5.15 33/47] Revert "usb: storage: Add quirk for Samsung Fit flash"
Date:   Wed, 12 Oct 2022 20:21:08 -0400
Message-Id: <20221013002124.1894077-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: sunghwan jung <onenowy@gmail.com>

[ Upstream commit ad5dbfc123e6ffbbde194e2a4603323e09f741ee ]

This reverts commit 86d92f5465958752481269348d474414dccb1552,
which fix the timeout issue for "Samsung Fit Flash".

But the commit affects not only "Samsung Fit Flash" but also other usb
storages that use the same controller and causes severe performance
regression.

 # hdparm -t /dev/sda (without the quirk)
 Timing buffered disk reads: 622 MB in  3.01 seconds = 206.66 MB/sec

 # hdparm -t /dev/sda (with the quirk)
 Timing buffered disk reads: 220 MB in  3.00 seconds =  73.32 MB/sec

The commit author mentioned that "Issue was reproduced after device has
bad block", so this quirk should be applied when we have the timeout
issue with a device that has bad blocks.

We revert the commit so that we apply this quirk by adding kernel
paramters using a bootloader or other ways when we really need it,
without the performance regression with devices that don't have the
issue.

Signed-off-by: sunghwan jung <onenowy@gmail.com>
Link: https://lore.kernel.org/r/20220913114913.3073-1-onenowy@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/unusual_devs.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 4993227ab293..20dcbccb290b 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1275,12 +1275,6 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
 		USB_SC_RBC, USB_PR_BULK, NULL,
 		0 ),
 
-UNUSUAL_DEV(0x090c, 0x1000, 0x1100, 0x1100,
-		"Samsung",
-		"Flash Drive FIT",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_MAX_SECTORS_64),
-
 /* aeb */
 UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		"Feiya",
-- 
2.35.1

