Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527275FD299
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJMBcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiJMBcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:32:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC9234704;
        Wed, 12 Oct 2022 18:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56FA0615BE;
        Thu, 13 Oct 2022 00:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF972C43142;
        Thu, 13 Oct 2022 00:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620897;
        bh=X/cIJmrKiiqRqx/BcVynhDgyBSUjjuc0ViUWGM72QBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftspPhV9WjFaBvQTQgl+aYBa7S+OWtNIcQ33C5axRwvPRpSS/OxJFb4Pep3uUhnXR
         uiSGv+wf8eliDhHUSFMEYpCT79ol1YoWOa3n94QJCfdozIhLuzyTh6UsqnZD9TtPoH
         YXJGdNxvUlQReJv6eUV7cOaE9R1drsiFUGUSqwVLluiBsX5yIzqtOWcmvKJmWfo2hM
         ZvaTA2rrg1gCQA6A/kkA5BsXQXdyGjQwThd8/vfCQ3AQqH25KHdjMTz8lEXlLqp8Ku
         D9nLNaGt4Pu4Kihu/LZ6zKXmH5xmBLh5PCQpBmMVJgYC8M6zZ1aou3uCwaPU1/FUZ2
         vQSaJwwocYHRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     sunghwan jung <onenowy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: [PATCH AUTOSEL 4.9 08/10] Revert "usb: storage: Add quirk for Samsung Fit flash"
Date:   Wed, 12 Oct 2022 20:27:55 -0400
Message-Id: <20221013002802.1896096-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002802.1896096-1-sashal@kernel.org>
References: <20221013002802.1896096-1-sashal@kernel.org>
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
index 5a6ca1460711..8c51bb66f16f 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1294,12 +1294,6 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
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

