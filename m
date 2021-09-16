Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569F140E277
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbhIPQjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242640AbhIPQhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:37:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7DD16140A;
        Thu, 16 Sep 2021 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809315;
        bh=jf5hnD9Aa0dFqkGvSaS6zFiCsVobv+I5FvZzl0JpVDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UC1+2oJn+mHe1KRY9qan6OgprgpDgVa6LamIjiALTa22HaeezT6joKeE+Nn6In0j/
         AMYEr9Vryj8tpzrK4met9f4zXIrSwYhixhim+swwIcM6OmfyOBuyJ9b9utgOR8bcux
         MwTibpk+bWNggTa7d1gv7QPa6GLsSRsUXB+YccpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>,
        Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 077/380] scsi: BusLogic: Use %X for u32 sized integer rather than %lX
Date:   Thu, 16 Sep 2021 17:57:14 +0200
Message-Id: <20210916155806.629421393@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 2127cd21fb78c6e22d92944253afd967b0ff774d ]

An earlier fix changed the print format specifier for adapter->bios_addr to
use %lX. However, the integer is a u32 so the fix was wrong. Fix this by
using the correct %X format specifier.

Link: https://lore.kernel.org/r/20210730095031.26981-1-colin.king@canonical.com
Fixes: 43622697117c ("scsi: BusLogic: use %lX for unsigned long rather than %X")
Acked-by: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Addresses-Coverity: ("Invalid type in argument")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index adddcd589941..bd615db5c58c 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1711,7 +1711,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
 		blogic_info("  DMA Channel: None, ", adapter);
 		if (adapter->bios_addr > 0)
-			blogic_info("BIOS Address: 0x%lX, ", adapter,
+			blogic_info("BIOS Address: 0x%X, ", adapter,
 					adapter->bios_addr);
 		else
 			blogic_info("BIOS Address: None, ", adapter);
-- 
2.30.2



