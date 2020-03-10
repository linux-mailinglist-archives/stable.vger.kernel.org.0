Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D4817F5E2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgCJLOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:14:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54553 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgCJLOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 07:14:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5874C22008;
        Tue, 10 Mar 2020 07:14:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 07:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6Lxx06
        +ndA/z+PSwKkiLriutbLVXuo1u4+FcP+u+1GU=; b=i7F1zwchtuFDQI227rVdxJ
        WB4UaPhgXrrkHAxHHOJGvvddGqz7UrZNbb9H6uNZuiD6PKNLkosr7fxwuQ/ntCYi
        gU8X3OLySuI27SlK7LG20ezyc9tuadx2BCELX3d0dze8WSdSK3eu9SKQO9Dx93Z5
        nSv3CXRbgtfzKzb0DXM28MBl6PYu4iQlDBdjJ8BirEmRhYiUTYgSI3hw4iZOWxo5
        HwIRnk4r2ATkvvX5V5YPUFcBStBf4yFkoYJCHzlmBHWefaaK8fGmBK8bjviwnY3D
        maeZgJ0vdS4MH+o/aQV8ccVuxJx7exGWkMqMk7y+JnBOJh2XCKBIA80cqtppmfxQ
        ==
X-ME-Sender: <xms:j3ZnXphu0f7ghqqvLqMS8IAsgix_pBRKOu99FM-K1bDiC_To_aAzNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:j3ZnXnbyDj7JkM2nPSibcbQGGiWG78WJenjSEW1yet7AGB-0v1ZueA>
    <xmx:j3ZnXhl--oI7qnwDcA3s2VRxwkpPpHBZmOls8-2fuLWVD_DtIcTBZw>
    <xmx:j3ZnXtykNvuCvxJ-kYLYEcYqimJZU7cBeiYE0OeJEbPOdxsTltwlHg>
    <xmx:j3ZnXvTo4TqQjdSFJ-XN0ys7DnPgw_QvpwyG2ldcp6P_5U0XsPi6OQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E8A0C3061393;
        Tue, 10 Mar 2020 07:14:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] efi: READ_ONCE rng seed size before munmap" failed to apply to 4.14-stable tree
To:     Jason@zx2c4.com, ardb@kernel.org, mingo@kernel.org,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 12:14:13 +0100
Message-ID: <158383885380151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be36f9e7517e17810ec369626a128d7948942259 Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 21 Feb 2020 09:48:49 +0100
Subject: [PATCH] efi: READ_ONCE rng seed size before munmap

This function is consistent with using size instead of seed->size
(except for one place that this patch fixes), but it reads seed->size
without using READ_ONCE, which means the compiler might still do
something unwanted. So, this commit simply adds the READ_ONCE
wrapper.

Fixes: 636259880a7e ("efi: Add support for seeding the RNG from a UEFI ...")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200217123354.21140-1-Jason@zx2c4.com
Link: https://lore.kernel.org/r/20200221084849.26878-5-ardb@kernel.org

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 621220ab3d0e..21ea99f65113 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -552,7 +552,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = seed->size;
+			size = READ_ONCE(seed->size);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -562,7 +562,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
 				pr_notice("seeding entropy pool\n");
-				add_bootloader_randomness(seed->bits, seed->size);
+				add_bootloader_randomness(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");

