Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79901126CF8
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfLSTHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbfLSSmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A343824680;
        Thu, 19 Dec 2019 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780975;
        bh=H7OrN3fircRbyHT0svbhUX+q3gK2QHvXaCLjgmGLcBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWp4LHv3gBzrKXzDFkV8k9izmc9KcK85zAWCoMXfICc7KLD4JpdcBTGF/GoUCtXo9
         jceXpcmh8BI4g0EB8M9AO0LZ703OmtIMnkZ/XKU7msWfupD/W31SW8YOKmQwBWA4W5
         AQFB+RkKYAjXBgTzWLRfOw1Uf9IpTlBE9RzL1MzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shreeya Patel <shreeya.patel23498@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 030/199] Staging: iio: adt7316: Fix i2c data reading, set the data field
Date:   Thu, 19 Dec 2019 19:31:52 +0100
Message-Id: <20191219183216.539676397@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
index 0ccf192b9a032..5950225e45d15 100644
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



