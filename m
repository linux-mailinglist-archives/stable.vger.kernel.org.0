Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A338514847A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389781AbgAXLJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:09:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733090AbgAXLJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:09:51 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821D220663;
        Fri, 24 Jan 2020 11:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864191;
        bh=FP24LIk+CmFXKN0TcLClW14rFaaJcJ7idY9+i+nQ6sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEuzXWwpCGel8mkYg87eU6usMNER4ezrCog4UDcsWg1poewojKg+aGzL03gm1hwFM
         BBkwEyLff7bWOwmIWEY9832VOF+zqfREIJO9H7roJWyB51hngVK424uVzkWxGEi8sX
         JqLKHqg/P5ro69LUBjOj6o+DpK22dEZ+LiKlxX88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Sheng <wesley.sheng@microchip.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/639] ntb_hw_switchtec: NT req id mapping table register entry number should be 512
Date:   Fri, 24 Jan 2020 10:25:59 +0100
Message-Id: <20200124093110.787659312@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Sheng <wesley.sheng@microchip.com>

[ Upstream commit d123fab71f63aae129aebe052664fda73131921a ]

The number of available NT req id mapping table entries per NTB control
register is 512. The driver mistakenly limits the number to 256.

Fix the array size of NT req id mapping table.

Fixes: c082b04c9d40 ("NTB: switchtec: Add NTB hardware register definitions")
Signed-off-by: Wesley Sheng <wesley.sheng@microchip.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/switchtec.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/switchtec.h b/include/linux/switchtec.h
index ab400af6f0ce3..623719c917061 100644
--- a/include/linux/switchtec.h
+++ b/include/linux/switchtec.h
@@ -244,8 +244,8 @@ struct ntb_ctrl_regs {
 		u64 xlate_addr;
 	} bar_entry[6];
 	u32 reserved2[216];
-	u32 req_id_table[256];
-	u32 reserved3[512];
+	u32 req_id_table[512];
+	u32 reserved3[256];
 	u64 lut_entry[512];
 } __packed;
 
-- 
2.20.1



