Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10A9186B97
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 13:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbgCPM53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 08:57:29 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46397 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730974AbgCPM53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 08:57:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id E6D57808;
        Mon, 16 Mar 2020 08:57:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 08:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sszqm3
        CiCNI/eD1P5uszQtOjXM0umOFW7hI1Yiv8l+o=; b=TNWTOFWuElmfKVwoea4orX
        dorPjYa/oddU0/dX9l00LLSeRaiBzu5QtCVnsOGsbmVhstLWwYv5JjNattQCzGWJ
        LqVmHWWgjRkxQbooPcdW9TsyzqgiiKKM66evT6olqpy3UkKZsyXge7kGfg1jrL2y
        RWr0syAJc9EtUt7wJjfue2YH48N7hrJOlgx5AQenc95UPgjvrX+lCM6/ri9Wspb9
        6Zb8Nf1Z3rYOQJmqmigMq6+HhZ9+6HOIDlpJgjYeasecCEuGXC3P6/nEiwP0F/VB
        aPyG+K9C8dYFwdsls49xgQUtA4BT7CaH8FmswFMq2aQ1n8hvxfPbtwdTBLiYEWDg
        ==
X-ME-Sender: <xms:uHdvXtw4SlnBm62viRWgaB9446Ivbhw7BiUwedqd_x4jUeRvMi55_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:uHdvXpATDuPYtBu1euNaFCTW00Aa-aJve4GIp5JT0iJuw49GXWNoWg>
    <xmx:uHdvXqGFv9pwtrBM46J3ynTwzYtDE8gPYfQBUiC4TdzyOmL1p4uexQ>
    <xmx:uHdvXliK7POehEC9w405tPWYqhjwezYqZUBTtvf1zoocpfInqkJgIw>
    <xmx:uHdvXrccpfZPpvAyfGknmCH15d09hJi6_l0jXF32hSdHTnDn1LGssg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 167AC328005D;
        Mon, 16 Mar 2020 08:57:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] efi: Add a sanity check to efivar_store_raw()" failed to apply to 4.19-stable tree
To:     vdronov@redhat.com, ardb@kernel.org, mingo@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 13:57:26 +0100
Message-ID: <15843634466260@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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
 

