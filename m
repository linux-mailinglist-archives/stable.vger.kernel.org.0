Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7639111B574
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbfLKPS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731836AbfLKPSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9489F2073D;
        Wed, 11 Dec 2019 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077503;
        bh=5EaPEyrukBMg3O+QebSDf5gJFnoIyQFT0LBomUN5WwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXJAkLWXf9a1NyRlXXRtIFixfzBrUaHG/OHBMCPRfuVj+goOVFDcFJcWU6DcG3y8l
         v2t0+eqyr4bDBN2hwqOYFTcf9f9rmtVCwRfoI1bjnOri1c9jeVllG3Z/Zim+iJDg9J
         cvVcR1T//KZPrTi0f/eMtBtL1x1gzKeDYsrtPeNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shreeya Patel <shreeya.patel23498@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/243] Staging: iio: adt7316: Fix i2c data reading, set the data field
Date:   Wed, 11 Dec 2019 16:03:44 +0100
Message-Id: <20191211150343.286588810@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreeya Patel <shreeya.patel23498@gmail.com>

[ Upstream commit 688cd642ba0c393344c802647848da5f0d925d0e ]

adt7316_i2c_read function nowhere sets the data field.
It is necessary to have an appropriate value for it.
Hence, assign the value stored in 'ret' variable to data field.

This is an ancient bug, and as no one seems to have noticed,
probably no sense in applying it to stable.

Signed-off-by: Shreeya Patel <shreeya.patel23498@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/addac/adt7316-i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/iio/addac/adt7316-i2c.c b/drivers/staging/iio/addac/adt7316-i2c.c
index f66dd3ebbab1f..856bcfa60c6c4 100644
--- a/drivers/staging/iio/addac/adt7316-i2c.c
+++ b/drivers/staging/iio/addac/adt7316-i2c.c
@@ -35,6 +35,8 @@ static int adt7316_i2c_read(void *client, u8 reg, u8 *data)
 		return ret;
 	}
 
+	*data = ret;
+
 	return 0;
 }
 
-- 
2.20.1



