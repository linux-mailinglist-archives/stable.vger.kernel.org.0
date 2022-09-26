Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBAF5EA3F0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiIZLgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiIZLe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861256E8B6;
        Mon, 26 Sep 2022 03:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9699E60A52;
        Mon, 26 Sep 2022 10:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70195C433C1;
        Mon, 26 Sep 2022 10:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189020;
        bh=jrvdF3Rauso5cJYEO2kOLy1/uCOL4ml8bo9/7BiKQnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKsVhY6Qj9uEnc3wgqAkeQbVYuK/5f0WETvkuF/njyHLh/Cn68js+PBq1EEdKMLIk
         TZszqdBzqxEu47sPTXtWAFVnpx7pymTr2YbYBqD0JngcqUMqLpvQ2TAhigZpFY+EQ1
         A/UE9jXJtbYQK2hwGHAB/ZHGS/HsDpM6c67jlkck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.19 048/207] efi: x86: Wipe setup_data on pure EFI boot
Date:   Mon, 26 Sep 2022 12:10:37 +0200
Message-Id: <20220926100808.760413331@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 63bf28ceb3ebbe76048c3fb2987996ca1ae64f83 upstream.

When booting the x86 kernel via EFI using the LoadImage/StartImage boot
services [as opposed to the deprecated EFI handover protocol], the setup
header is taken from the image directly, and given that EFI's LoadImage
has no Linux/x86 specific knowledge regarding struct bootparams or
struct setup_header, any absolute addresses in the setup header must
originate from the file and not from a prior loading stage.

Since we cannot generally predict where LoadImage() decides to load an
image (*), such absolute addresses must be treated as suspect: even if a
prior boot stage intended to make them point somewhere inside the
[signed] image, there is no way to validate that, and if they point at
an arbitrary location in memory, the setup_data nodes will not be
covered by any signatures or TPM measurements either, and could be made
to contain an arbitrary sequence of SETUP_xxx nodes, which could
interfere quite badly with the early x86 boot sequence.

(*) Note that, while LoadImage() does take a buffer/size tuple in
addition to a device path, which can be used to provide the image
contents directly, it will re-allocate such images, as the memory
footprint of an image is generally larger than the PE/COFF file
representation.

Cc: <stable@vger.kernel.org> # v5.10+
Link: https://lore.kernel.org/all/20220904165321.1140894-1-Jason@zx2c4.com/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -517,6 +517,13 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 	hdr->ramdisk_image = 0;
 	hdr->ramdisk_size = 0;
 
+	/*
+	 * Disregard any setup data that was provided by the bootloader:
+	 * setup_data could be pointing anywhere, and we have no way of
+	 * authenticating or validating the payload.
+	 */
+	hdr->setup_data = 0;
+
 	efi_stub_entry(handle, sys_table_arg, boot_params);
 	/* not reached */
 


