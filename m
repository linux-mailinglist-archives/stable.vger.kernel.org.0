Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FADD6C6F1
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391129AbfGRDKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391134AbfGRDKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:14 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A099821841;
        Thu, 18 Jul 2019 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419413;
        bh=3fZOVIMhLXlJK6IU7no/pPiVvuBM30eZB7ippg/rVpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCGo1U+yQWWxKVyS8T/eaZQQerGEz4mlHMg0Stuf4UzH7r/JEP0CUBTVtCXHKXhPQ
         7B6E0HhVYdMK+zQm1YblHqGNaQtroGXkBaBLa7+UHko799toLb1pXxKigSZxuTin7J
         L0RdYxU/jap8OmHYwbmOqb1onCdZcby61J+rrUwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 38/80] net: dsa: mv88e6xxx: fix shift of FID bits in mv88e6185_g1_vtu_loadpurge()
Date:   Thu, 18 Jul 2019 12:01:29 +0900
Message-Id: <20190718030101.598580672@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 48620e341659f6e4b978ec229f6944dabe6df709 ]

The comment is correct, but the code ends up moving the bits four
places too far, into the VTUOp field.

Fixes: 11ea809f1a74 (net: dsa: mv88e6xxx: support 256 databases)
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 8c8a0ec3d6e9..f260bd30c73a 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -416,7 +416,7 @@ int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 		 * VTU DBNum[7:4] are located in VTU Operation 11:8
 		 */
 		op |= entry->fid & 0x000f;
-		op |= (entry->fid & 0x00f0) << 8;
+		op |= (entry->fid & 0x00f0) << 4;
 	}
 
 	return mv88e6xxx_g1_vtu_op(chip, op);
-- 
2.20.1



