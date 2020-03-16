Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EB2186B99
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 13:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgCPM5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 08:57:40 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57999 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730896AbgCPM5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 08:57:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 62A6D7E8;
        Mon, 16 Mar 2020 08:57:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 08:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yy04j+
        oxJsEtkyjyhD/2JsE72aahQlhihiptwaFHPhI=; b=jjJhG/4lp0poVcbuoCFpGJ
        AavWnRxHFWie0KKNBzlgc1Zpk5ELgHkGEBXT/1NgllPvki2xUYsTanXxEavEp5P4
        ix1hRWOhdWfvURONezE8sHQkeQc83dsa53OsGEENHRmzv79R1oNvfWCjUBoYEXKI
        xhjfcD4M0Ts0xjYr46kZwGqQ7aN5m+UavCG63SWIK4kZ5m8kk4s0//zUq3wdxrDT
        RM5KPeBg4lFeGvX03pJgXu6VGuyI6Hzi8gTWXjXEXsbscASHvazBcD1diZWrJpJn
        uDzEvN4/+KL7YP4s3ZS97egh8JQQd2Hhg5x1bEigL6KNJhWGRRxG+zGdUxOevsSw
        ==
X-ME-Sender: <xms:wndvXhHbaKRsIF_Axx87wie5rMffp9FWOu44aZYUHdilRA3kY25orw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wndvXpzqAxycN5UjD77grbCsRPUk6N1vfi35T0vxw5_r0U4WkHp2mw>
    <xmx:wndvXvboFaADoH3IMbkZ3N_bpwwQSOVlrBjahOV_lhyamRGfu2iQRQ>
    <xmx:wndvXgHkttRxyHY0HSGSqzOtQyh6UiJUWPTG8CTv6P2z8_eNfYO38A>
    <xmx:w3dvXsd_s4vS6MHeByE-rVlQLHPUuM8sDdYjw_dDO5JIsV_2jj2Zbg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A19FF3061856;
        Mon, 16 Mar 2020 08:57:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] efi: Add a sanity check to efivar_store_raw()" failed to apply to 4.4-stable tree
To:     vdronov@redhat.com, ardb@kernel.org, mingo@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 13:57:27 +0100
Message-ID: <15843634473416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d6c066fda90d578aacdf19771a027ed484a79825 Mon Sep 17 00:00:00 2001
From: Vladis Dronov <vdronov@redhat.com>
Date: Sun, 8 Mar 2020 09:08:55 +0100
Subject: [PATCH] efi: Add a sanity check to efivar_store_raw()

Add a sanity check to efivar_store_raw() the same way
efivar_{attr,size,data}_read() and efivar_show_raw() have it.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200305084041.24053-3-vdronov@redhat.com
Link: https://lore.kernel.org/r/20200308080859.21568-25-ardb@kernel.org

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 69f13bc4b931..aff3dfb4d7ba 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -208,6 +208,9 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	u8 *data;
 	int err;
 
+	if (!entry || !buf)
+		return -EINVAL;
+
 	if (in_compat_syscall()) {
 		struct compat_efi_variable *compat;
 

