Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917964CFA4A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239215AbiCGKPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiCGKKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFC2366B1;
        Mon,  7 Mar 2022 01:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF363B80F9F;
        Mon,  7 Mar 2022 09:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB679C340F3;
        Mon,  7 Mar 2022 09:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646805;
        bh=R8uY/zTXdHSzjpLIxZlJhb0hQIo+MzsaqToLbh99yeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK1+nI3jQqDb4Cn/gf54A/zCsaLZzujSVc6sR4lQGfsUIHUe6L7ITGID1W71UzqDY
         PkDebHMXN/FoKOelS0nvJbudqpm4ye5u6Js7UvS8Q3pEReWqwZre0Xwqjfq1jNMNmG
         VWPei4cJgcTEHrej27mSnfCm+0qH8sEhRN0u3/0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.16 098/186] efivars: Respect "block" flag in efivar_entry_set_safe()
Date:   Mon,  7 Mar 2022 10:18:56 +0100
Message-Id: <20220307091656.822308175@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 258dd902022cb10c83671176688074879517fd21 upstream.

When the "block" flag is false, the old code would sometimes still call
check_var_size(), which wrongly tells ->query_variable_store() that it can
block.

As far as I can tell, this can't really materialize as a bug at the moment,
because ->query_variable_store only does something on X86 with generic EFI,
and in that configuration we always take the efivar_entry_set_nonblocking()
path.

Fixes: ca0e30dcaa53 ("efi: Add nonblocking option to efi_query_variable_store()")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20220218180559.1432559-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/vars.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -742,6 +742,7 @@ int efivar_entry_set_safe(efi_char16_t *
 {
 	const struct efivar_operations *ops;
 	efi_status_t status;
+	unsigned long varsize;
 
 	if (!__efivars)
 		return -EINVAL;
@@ -764,15 +765,17 @@ int efivar_entry_set_safe(efi_char16_t *
 		return efivar_entry_set_nonblocking(name, vendor, attributes,
 						    size, data);
 
+	varsize = size + ucs2_strsize(name, 1024);
 	if (!block) {
 		if (down_trylock(&efivars_lock))
 			return -EBUSY;
+		status = check_var_size_nonblocking(attributes, varsize);
 	} else {
 		if (down_interruptible(&efivars_lock))
 			return -EINTR;
+		status = check_var_size(attributes, varsize);
 	}
 
-	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
 		up(&efivars_lock);
 		return -ENOSPC;


