Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F366213E8
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiKHNzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiKHNzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:55:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430EF191
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:55:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0E98B816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19348C433C1;
        Tue,  8 Nov 2022 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915710;
        bh=udMOj4RmnI/70++N5+1bOmwL6qZMN1Lgadg5rZz7nUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+ZIsbGXmdVgSfhXp7OSCMEIQDT8N80dJllDT+hspyga3ye6Ak7wIha7jWbnEI+s0
         DLi7fIwKDeWo5rhPXbYqtvR6o7ebwaGLZzMbJs+x4gW7xOrcBo6fS/TOAy6pCPit/H
         O77cLHdP/kFVYEzQEL0tfBOXXVyWe4BhRTJO0pvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Garrett <mjg59@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/118] efi/tpm: Pass correct address to memblock_reserve
Date:   Tue,  8 Nov 2022 14:39:07 +0100
Message-Id: <20221108133343.746077793@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit f4cd18c5b2000df0c382f6530eeca9141ea41faf ]

memblock_reserve() expects a physical address, but the address being
passed for the TPM final events log is what was returned from
early_memremap(). This results in something like the following:

[    0.000000] memblock_reserve: [0xffffffffff2c0000-0xffffffffff2c00e4] efi_tpm_eventlog_init+0x324/0x370

Pass the address from efi like what is done for the TPM events log.

Fixes: c46f3405692d ("tpm: Reserve the TPM final events table")
Cc: Matthew Garrett <mjg59@google.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Bartosz Szczepanek <bsz@semihalf.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 8f665678e9e3..e8d69bd548f3 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -97,7 +97,7 @@ int __init efi_tpm_eventlog_init(void)
 		goto out_calc;
 	}
 
-	memblock_reserve((unsigned long)final_tbl,
+	memblock_reserve(efi.tpm_final_log,
 			 tbl_size + sizeof(*final_tbl));
 	efi_tpm_final_log_size = tbl_size;
 
-- 
2.35.1



