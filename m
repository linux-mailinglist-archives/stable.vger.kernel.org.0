Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E54603D38
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiJSJAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiJSI6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:58:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153659F74F;
        Wed, 19 Oct 2022 01:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA1CB61802;
        Wed, 19 Oct 2022 08:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A2DC433C1;
        Wed, 19 Oct 2022 08:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169128;
        bh=nFCeWBlb71nzHFatGST1sfWN1nDJByc2HnNY5OXQHfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07tpGFe20hPORzdq9D+fBgsK5aaEVYefOAz6m6nVwAPurmYp0rupY4sykNimn4OLG
         elB4nC9oX+hH6nMbbrC8Qyco6Vu/qr9uNriVmjSHU5dP3NbXRW5XMOPzJMNJmCpMuS
         nVgQEpu0SksbTBcJDnPSq8b8OC+MK6DCXZeCajao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.0 168/862] efi: libstub: drop pointless get_memory_map() call
Date:   Wed, 19 Oct 2022 10:24:15 +0200
Message-Id: <20221019083257.389965292@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit d80ca810f096ff66f451e7a3ed2f0cd9ef1ff519 upstream.

Currently, the non-x86 stub code calls get_memory_map() redundantly,
given that the data it returns is never used anywhere. So drop the call.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 24d7c494ce46 ("efi/arm-stub: Round up FDT allocation to mapping size")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/fdt.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -280,14 +280,6 @@ efi_status_t allocate_new_fdt_and_exit_b
 		goto fail;
 	}
 
-	/*
-	 * Now that we have done our final memory allocation (and free)
-	 * we can get the memory map key needed for exit_boot_services().
-	 */
-	status = efi_get_memory_map(&map);
-	if (status != EFI_SUCCESS)
-		goto fail_free_new_fdt;
-
 	status = update_fdt((void *)fdt_addr, fdt_size,
 			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
 			    initrd_addr, initrd_size);


