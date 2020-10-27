Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335D129B69E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797436AbgJ0PXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797431AbgJ0PXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0CCD2064B;
        Tue, 27 Oct 2020 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812211;
        bh=BXlS800SwGQrPnsXmMwxDYcht6XMTLARhE1KxqLI9Xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdKt4AFEAIcxRC5Ii0i+G6PzerUF9hM5uR280CPadbQ0vTnvaTEQzpi0JI+wwqMi7
         YHl/c1rou2WTllgL2beto2RYNMhaXanbjJq2vzfw/Pu2N88cFxcgqzyICCxvqhU95c
         yxg/YDFkeWKNMgeA2Iiwi7kY5hil3lXuXzt4YVQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 130/757] media: i2c: fix error check on max9286_read call
Date:   Tue, 27 Oct 2020 14:46:20 +0100
Message-Id: <20201027135456.679910299@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e5b95c8febd504659b60a7601fd43c0ae8e4f3c0 ]

Currently the error return from the call to max9286_read is masked
with 0xf0 so the following check for a negative error return is
never true.  Fix this by checking for an error first, then masking
the return value for subsequent conflink_mask checking.

Addresses-Coverity: ("Logically dead code")

Fixes: 66d8c9d2422d ("media: i2c: Add MAX9286 driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index 47f280518fdb6..b364a3f604861 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -405,10 +405,11 @@ static int max9286_check_config_link(struct max9286_priv *priv,
 	 * to 5 milliseconds.
 	 */
 	for (i = 0; i < 10; i++) {
-		ret = max9286_read(priv, 0x49) & 0xf0;
+		ret = max9286_read(priv, 0x49);
 		if (ret < 0)
 			return -EIO;
 
+		ret &= 0xf0;
 		if (ret == conflink_mask)
 			break;
 
-- 
2.25.1



