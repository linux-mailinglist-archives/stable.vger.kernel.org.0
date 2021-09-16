Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B1E40DF42
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhIPQIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234850AbhIPQH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A5B861268;
        Thu, 16 Sep 2021 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808367;
        bh=QV/0Ednd9+WnkJtTfYQvY7pchYoSJHgnRzMOvgk9Wag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7qEE7AgKcq6BiiJUa3LNz9Nhj/G4ME4UE9D60siOF1yXsB4ZKiIZ96EjbRg1U2/3
         HagIp7lfUhk7/Pcjy8qEDIh1Aj0illkt+4+NyfeU+wvBdHYfBrHvtPKHm41ue/8TEy
         WujarxmROxkX4hcO021SgTL6/DBMPza+dgyAF4RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>,
        Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/306] scsi: BusLogic: Use %X for u32 sized integer rather than %lX
Date:   Thu, 16 Sep 2021 17:56:48 +0200
Message-Id: <20210916155756.093520871@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 7231de2767a9..86d9d804dea7 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1845,7 +1845,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 		else
 			blogic_info("None, ", adapter);
 		if (adapter->bios_addr > 0)
-			blogic_info("BIOS Address: 0x%lX, ", adapter,
+			blogic_info("BIOS Address: 0x%X, ", adapter,
 					adapter->bios_addr);
 		else
 			blogic_info("BIOS Address: None, ", adapter);
-- 
2.30.2



