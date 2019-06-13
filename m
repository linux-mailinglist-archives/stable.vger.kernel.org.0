Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5843F4F
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbfFMP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731527AbfFMIvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C723F206BA;
        Thu, 13 Jun 2019 08:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415877;
        bh=OwZ0qLFkEiHNIobShGBggg/4oh/hdfHyky43omuQniU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxUlaMUgNedUocdk7KfXx80JUdR64wWUjgV1weOhkzFXpLmC3hyKHEjrLMXvUFo39
         txjSg+wXkYoPoSZF7PLyxBW0RprvmnqT/kQzfS/QbBQk813HwugR3K/IRm5n79SsG8
         EoINzAtcEriwXpE59VAMmy6XzZ9o8xBxgKwWdBZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Aditya Pakki <pakki001@umn.edu>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 129/155] video: hgafb: fix potential NULL pointer dereference
Date:   Thu, 13 Jun 2019 10:34:01 +0200
Message-Id: <20190613075700.013319542@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ec7f6aad57ad29e4e66cc2e18e1e1599ddb02542 ]

When ioremap fails, hga_vram should not be dereferenced. The fix
check the failure to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>
[b.zolnierkie: minor patch summary fixup]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hgafb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index 463028543173..59e1cae57948 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -285,6 +285,8 @@ static int hga_card_detect(void)
 	hga_vram_len  = 0x08000;
 
 	hga_vram = ioremap(0xb0000, hga_vram_len);
+	if (!hga_vram)
+		goto error;
 
 	if (request_region(0x3b0, 12, "hgafb"))
 		release_io_ports = 1;
-- 
2.20.1



