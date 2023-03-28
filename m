Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22DD6CC34B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjC1Owv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbjC1Owc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05538D514
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E5B1B81D72
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032E1C433EF;
        Tue, 28 Mar 2023 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015146;
        bh=EQQ0+9tjZqU6nDVpS/pF1WKirGnP8BA+IkCOA/qUuO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPSxnCNrpvCHoLRG5cfvWyIoDzcpsTi35S3nu1ZaXckOiQ+SpGZaO6YqFROTiW/pd
         3I0EfuToyEu6LW5BVQ8o8GUYB93C9ymvZ4MypWWvpnwDhxQb5zwvphEOAINU/Xfx0r
         efCNgEmJlxKME/HQCDE7oP/eqQE4zCe2dEOniAog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.2 183/240] efi/libstub: zboot: Mark zboot EFI application as NX compatible
Date:   Tue, 28 Mar 2023 16:42:26 +0200
Message-Id: <20230328142627.260590436@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit c7d9e628b8ff4d52a365a441bdacb3209ee83c81 upstream.

Now that the zboot loader will invoke the EFI memory attributes protocol
to remap the decompressed code and rodata as read-only/executable, we
can set the PE/COFF header flag that indicates to the firmware that the
application does not rely on writable memory being executable at the
same time.

Cc: <stable@vger.kernel.org> # v6.2+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/zboot-header.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/zboot-header.S
+++ b/drivers/firmware/efi/libstub/zboot-header.S
@@ -63,7 +63,7 @@ __efistub_efi_zboot_header:
 	.long		.Lefi_header_end - .Ldoshdr
 	.long		0
 	.short		IMAGE_SUBSYSTEM_EFI_APPLICATION
-	.short		0
+	.short		IMAGE_DLL_CHARACTERISTICS_NX_COMPAT
 #ifdef CONFIG_64BIT
 	.quad		0, 0, 0, 0
 #else


