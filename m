Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8D969CD0E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjBTNqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjBTNqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CF81E1EE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:45:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FFF3B80D43
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95CFC433D2;
        Mon, 20 Feb 2023 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900731;
        bh=UOOkRQP3xdihmk2mxo/A8RZ5+6uk72dVJDxpNLg40sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+76jolzkNDsUrR11MobBXsnoPar+hLdv+5+qbj0xf9HbHaJwGuGoKe24nN9td6S5
         zhYfmN0nWR+wSLXepbqcuNUCO/PQjR+4OyqdT7YiRRUbPZZevbR3K7QscPL4+bEWQo
         1LsvIJ2hoAwTUjuhV7QtfL2HCtqk9h791p+SyHBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 039/156] efi: Accept version 2 of memory attributes table
Date:   Mon, 20 Feb 2023 14:34:43 +0100
Message-Id: <20230220133604.016903583@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
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
@@ -32,7 +32,7 @@ int __init efi_memattr_init(void)
 		return -ENOMEM;
 	}
 
-	if (tbl->version > 1) {
+	if (tbl->version > 2) {
 		pr_warn("Unexpected EFI Memory Attributes table version %d\n",
 			tbl->version);
 		goto unmap;


