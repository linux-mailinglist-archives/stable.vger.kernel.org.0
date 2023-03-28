Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642196CC297
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbjC1Oqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbjC1Oq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E352CDC0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 161D161827
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25278C433D2;
        Tue, 28 Mar 2023 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014760;
        bh=Enun6d4xQjyUVhxu99y03YhiyEY1HIyer8NPEq/2RIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPH1/MFNEMOPwe4L1i27lxXnBkwnhv8/uHRkb9sOu7nK89v+cAkffWnxHAYwm5u/t
         3fCZ5P82WeF74/wbYs3Q8PNm+1p1TZdyWCyErvcrtMfbVHvAAqm46thxy+YjovCHT6
         0EeRbvVA3VSR0OlMdsmiLH88ESHRMe1UQdMfhu6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 043/240] efi/libstub: smbios: Use length member instead of record struct size
Date:   Tue, 28 Mar 2023 16:40:06 +0200
Message-Id: <20230328142621.515220613@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 34343eb06afc04af9178a9883d9354dc12beede0 ]

The type 1 SMBIOS record happens to always be the same size, but there
are other record types which have been augmented over time, and so we
should really use the length field in the header to decide where the
string table starts.

Fixes: 550b33cfd4452968 ("arm64: efi: Force the use of ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/smbios.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/smbios.c b/drivers/firmware/efi/libstub/smbios.c
index 460418b7f5f5e..aadb422b9637d 100644
--- a/drivers/firmware/efi/libstub/smbios.c
+++ b/drivers/firmware/efi/libstub/smbios.c
@@ -36,7 +36,7 @@ const u8 *__efi_get_smbios_string(u8 type, int offset, int recsize)
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-	strtable = (u8 *)record + recsize;
+	strtable = (u8 *)record + record->length;
 	for (int i = 1; i < ((u8 *)record)[offset]; i++) {
 		int len = strlen(strtable);
 
-- 
2.39.2



