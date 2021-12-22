Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14E647D389
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245680AbhLVOU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:20:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48764 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245661AbhLVOUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 09:20:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60A50B81CEC;
        Wed, 22 Dec 2021 14:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A9BC36AE5;
        Wed, 22 Dec 2021 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640182852;
        bh=VXHRu9vWDw42BMg8qFKp2aB9xZz+LqjogCH7p0sOnis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa2qHQLKPsWrUk+25xYzuA5ksPtac5H+NAxt7nwDXD/YZfnlNpagDu/7WKC6k68NZ
         dZWHIocO171QGQfmL5W15zwMSJyRrU7DGKCFrMKAMo+tuIvBXl55mQeOBQCd0jVKTs
         tGQqRt5LIhmuJr4U6dqQmmPHuvWmAiqh+amlvOhkVDqQ01F95TvG1hQXTW2Y80oo7W
         dr3WjtoBXTVWzAPPs11OrxJ2E+8cT3nLp9mI52hSsQvpJNvP271CqbPIKTdTHbc9CK
         B3bY7qrsdmN4MdRQHc/ktzD5RgVLs/48oMPkdITAgrP3A+2fdS5xKzbqqLCNUlYlsI
         YVU0mO2pz0/Pw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1n02U0-0007uj-Mt; Wed, 22 Dec 2021 15:20:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Lad@xi.lan
Subject: [PATCH 1/4] media: davinci: vpif: fix unbalanced runtime PM get
Date:   Wed, 22 Dec 2021 15:20:22 +0100
Message-Id: <20211222142025.30364-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211222142025.30364-1-johan@kernel.org>
References: <20211222142025.30364-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to balance the runtime PM usage counter on driver unbind.

Fixes: 407ccc65bfd2 ("[media] davinci: vpif: add pm_runtime support")
Cc: stable@vger.kernel.org      # 3.9
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/platform/davinci/vpif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 5a89d885d0e3..9752a5ec36f7 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -495,6 +495,7 @@ static int vpif_probe(struct platform_device *pdev)
 
 static int vpif_remove(struct platform_device *pdev)
 {
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
-- 
2.32.0

