Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0CB6B3FA5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCJMuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJMuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:50:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5FBF6008;
        Fri, 10 Mar 2023 04:50:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF044B82292;
        Fri, 10 Mar 2023 12:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13AEC433D2;
        Fri, 10 Mar 2023 12:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678452633;
        bh=hDGDslrgVDkeI/7kh/l0dfJL9zfNgMwf25WV/aUlCEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqHbESWlv8NCnaQn1/2xo0zNaR7grocnU72jEiJio05AaZsxV/WycllqtOtp4ZiIc
         1e8MoK/BlZcn6xZDFWAtKigrIiPCyf07N8MKFYBLzz1LsedfHqYByli6+O5BRk3TxA
         MoRMdqQ93OD0Occt5EF37Zt+JtlBgEAdAcct4x2LqYHyXkE2p0sNHXYtNl6MyjKOLf
         BvYNMPyHv57HIWPnaCYBb8GWkFTbC1fpkB9Pt45zU3+RZsy5qre4nfsbutMiS/vviy
         UkDz6+SFVzZxucxkqnYRJG+oP50BdVG5J0ZyDd3brQmzLcGk1zXMaCrPoEGrs3XqmJ
         BTRMfqCAYZqEQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Jones <pjones@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 1/3] efi/libstub: zboot: Mark zboot EFI application as NX compatible
Date:   Fri, 10 Mar 2023 13:50:24 +0100
Message-Id: <20230310125026.3390928-2-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310125026.3390928-1-ardb@kernel.org>
References: <20230310125026.3390928-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1016; i=ardb@kernel.org; h=from:subject; bh=hDGDslrgVDkeI/7kh/l0dfJL9zfNgMwf25WV/aUlCEY=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIYVbfUKM2CMZhpk9/QJsU/4XXShonliQIRY7zYm/jnXvj A03LDs7SlkYxDgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwERELzIy9NVn7J9yROTS5tJZ n47f35D9w/Sq0JJ1z1Wbc44K/P/BoM/wVzTjY9pJ/in1F1VvrJ9ptVVTgL1tx79X98rrL/y8mL6 FjRUA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that the zboot loader will invoke the EFI memory attributes protocol
to remap the decompressed code and rodata as read-only/executable, we
can set the PE/COFF header flag that indicates to the firmware that the
application does not rely on writable memory being executable at the
same time.

Cc: <stable@vger.kernel.org> # v6.2+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/zboot-header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/zboot-header.S b/drivers/firmware/efi/libstub/zboot-header.S
index ec4525d40e0cf6d6..445cb646eaaaf1c6 100644
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
-- 
2.39.2

