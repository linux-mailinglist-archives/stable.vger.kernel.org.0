Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836EE60A51C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiJXMUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiJXMTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:19:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20CD82D34;
        Mon, 24 Oct 2022 04:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70DAEB811C2;
        Mon, 24 Oct 2022 11:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74A0C433D6;
        Mon, 24 Oct 2022 11:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612473;
        bh=iEJsBoW3YU23uXGXgTyOnGGgbdob3FhR9ZJsI+4No/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbHUs+SLPQjbxrXeJsqvXcWIDWoywz+g6Ij/ftyvqNQrguYBsZ7grt+Fo77oWEvHQ
         OwjFBAmEX+CWK9hwFG+roXwga3jbhbDAQZqW5DIQ8rNaTkqqb4KbwKfLqECBBeASAp
         D6tNB7sikGW6+PQTvJWopRcLKH1pX3q3IXYypR0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, sunghwan jung <onenowy@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 201/210] Revert "usb: storage: Add quirk for Samsung Fit flash"
Date:   Mon, 24 Oct 2022 13:31:58 +0200
Message-Id: <20221024113003.504733937@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8c186ab5b5f7..8b38dd7d89b7 100644
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



