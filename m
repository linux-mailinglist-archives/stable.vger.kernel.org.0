Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB1B68D7F5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjBGNE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjBGNEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:04:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3221026F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 159FA613E2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1032CC433D2;
        Tue,  7 Feb 2023 13:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775076;
        bh=N0Edf6x1f9TIiVhbmnpnJAYmENyxyBYo5ixaFPZ5WKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIg0JfIeca5qYVLfQNcHVQyZIWUmrV2lTw/H0ndKicirseb5OTwD41Cg5eVVodbaI
         EqqmYc/7OMpHc9p093MG3q9BzLqH3Ll/74F1iDL/LxNOiEB5bYHd4fMe6BYyzJ7uR7
         V/TfgL86ef3cGSffBdiylwaF4SUnla16iRnz0hms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 130/208] efi: Accept version 2 of memory attributes table
Date:   Tue,  7 Feb 2023 13:56:24 +0100
Message-Id: <20230207125640.315663523@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 636ab417a7aec4ee993916e688eb5c5977570836 upstream.

UEFI v2.10 introduces version 2 of the memory attributes table, which
turns the reserved field into a flags field, but is compatible with
version 1 in all other respects. So let's not complain about version 2
if we encounter it.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/memattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -33,7 +33,7 @@ int __init efi_memattr_init(void)
 		return -ENOMEM;
 	}
 
-	if (tbl->version > 1) {
+	if (tbl->version > 2) {
 		pr_warn("Unexpected EFI Memory Attributes table version %d\n",
 			tbl->version);
 		goto unmap;


