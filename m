Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6CA60A1AE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJXLcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiJXLcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8859B55C42;
        Mon, 24 Oct 2022 04:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CD3661257;
        Mon, 24 Oct 2022 11:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDFEC433D7;
        Mon, 24 Oct 2022 11:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611118;
        bh=SsxXhBXuJAX9mARv/xwRDQb187Z+68sqr4yjhTCIe70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5n8MywCFViw8R0/7bkRg7NkfWJAUBVH8qcI0X9lsOtnCBNoPS2zFloxXhCEd51K7
         fKvP0Hplrn9dUYxZiEUZ6Bwl9Vjroa5AFjYdDVMoVE6XukEkcLRkY/T9ke0+50+mWX
         ujgx0lRHDZQyi6FYvsD8O1QCG21MFXtZGBPxq2gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.0 16/20] efi: ssdt: Dont free memory if ACPI table was loaded successfully
Date:   Mon, 24 Oct 2022 13:31:18 +0200
Message-Id: <20221024112935.061892355@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 4b017e59f01097f19b938f6dc4dc2c4720701610 upstream.

Amadeusz reports KASAN use-after-free errors introduced by commit
3881ee0b1edc ("efi: avoid efivars layer when loading SSDTs from
variables"). The problem appears to be that the memory that holds the
new ACPI table is now freed unconditionally, instead of only when the
ACPI core reported a failure to load the table.

So let's fix this, by omitting the kfree() on success.

Cc: <stable@vger.kernel.org> # v6.0
Link: https://lore.kernel.org/all/a101a10a-4fbb-5fae-2e3c-76cf96ed8fbd@linux.intel.com/
Fixes: 3881ee0b1edc ("efi: avoid efivars layer when loading SSDTs from variables")
Reported-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -269,6 +269,8 @@ static __init int efivar_ssdt_load(void)
 			acpi_status ret = acpi_load_table(data, NULL);
 			if (ret)
 				pr_err("failed to load table: %u\n", ret);
+			else
+				continue;
 		} else {
 			pr_err("failed to get var data: 0x%lx\n", status);
 		}


