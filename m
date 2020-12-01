Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33922C9BE2
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389294AbgLAJNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390022AbgLAJM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3EA220809;
        Tue,  1 Dec 2020 09:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813963;
        bh=a+sG0RYOjYM8JqKT8I3axdNLLN6AmqISkuuujrt1Weo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLn5hyDlCKDFDxV66/CsZVYVV3Jb0aV9zHQGKxKlJhuUXq6pYF3+03mPOmOpOsjEl
         tPEzLaMSIHbC3wOyK8ZpV+6XAEfopssQD4fGBPJ6dI/3mgSF3TDyd4otKfAphhtXJ0
         ZMUGjYxw9lOblQFVvstgSdrrmqIPL6qtW7lSbfpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 120/152] efi/efivars: Set generic ops before loading SSDT
Date:   Tue,  1 Dec 2020 09:53:55 +0100
Message-Id: <20201201084727.513958611@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 50bdcf047503e30126327d0be4f0ad7337106d68 ]

Efivars allows for overriding of SSDT tables, however starting with
commit

  bf67fad19e493b ("efi: Use more granular check for availability for variable services")

this use case is broken. When loading SSDT generic ops should be set
first, however mentioned commit reversed order of operations. Fix this
by restoring original order of operations.

Fixes: bf67fad19e493b ("efi: Use more granular check for availability for variable services")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20201123172817.124146-1-amadeuszx.slawinski@linux.intel.com
Tested-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3aa07c3b51369..8ead4379e6e85 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -387,10 +387,10 @@ static int __init efisubsys_init(void)
 
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
 				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
-		efivar_ssdt_load();
 		error = generic_ops_register();
 		if (error)
 			goto err_put;
+		efivar_ssdt_load();
 		platform_device_register_simple("efivars", 0, NULL, 0);
 	}
 
-- 
2.27.0



