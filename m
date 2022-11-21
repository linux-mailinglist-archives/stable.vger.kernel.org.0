Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09B66321AB
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiKUMNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKUMNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:13:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6551115
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:13:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A354160ECD
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69996C433D6;
        Mon, 21 Nov 2022 12:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669032813;
        bh=r+5jppuPJHj/WJK3fte41zmjnVvChsLbRHtBeOrZOiQ=;
        h=Subject:To:Cc:From:Date:From;
        b=ouQzSY5GatSoiu75XBiW0lcfBaOCFLHWQj6+xp7rDeCTT0udyifjBjHS1KiB0wW7S
         ILKNnruP6XCZsOJmiDgXRy8W/qpJ6g2JDVzp69KlyY1SrDSCM4SHu29a1JpZ6fsJm2
         qAnQZVdvstfSmAt1NmUMhsmdTPFWc+xb0fwW2tts=
Subject: FAILED: patch "[PATCH] x86/sgx: Add overflow check in sgx_validate_offset_length()" failed to apply to 5.15-stable tree
To:     borysp@invisiblethingslab.com, bp@suse.de, jarkko@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 13:13:29 +0100
Message-ID: <1669032809147157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f0861f49bd94 ("x86/sgx: Add overflow check in sgx_validate_offset_length()")
dda03e2c331b ("x86/sgx: Create utility to validate user provided offset and length")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0861f49bd946ff94fce4f82509c45e167f63690 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Borys=20Pop=C5=82awski?= <borysp@invisiblethingslab.com>
Date: Wed, 5 Oct 2022 00:59:03 +0200
Subject: [PATCH] x86/sgx: Add overflow check in sgx_validate_offset_length()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sgx_validate_offset_length() function verifies "offset" and "length"
arguments provided by userspace, but was missing an overflow check on
their addition. Add it.

Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
Signed-off-by: Borys Popławski <borysp@invisiblethingslab.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.11+
Link: https://lore.kernel.org/r/0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisiblethingslab.com

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ebe79d60619f..da8b8ea6b063 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -356,6 +356,9 @@ static int sgx_validate_offset_length(struct sgx_encl *encl,
 	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
 		return -EINVAL;
 
+	if (offset + length < offset)
+		return -EINVAL;
+
 	if (offset + length - PAGE_SIZE >= encl->size)
 		return -EINVAL;
 

