Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097ACEEF57
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389092AbfKDWUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbfKDV7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:17 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9DC6217F5;
        Mon,  4 Nov 2019 21:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904757;
        bh=A1CC+d9DZVVwc+jQwceLaceB74uPRg43Vtk7GxRaMSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pW0aWSAHE9ytKbDO9u7TYDFbwvL2uKYYY+84SBFtar2ZZERWNWCN4RCN69l+9AI1Z
         GZZc40hnyhGKDs7hD3XtFEZtzBpec0iMMkCPYxK6z/Wyg5B1Enh8dIUVPXpItac83X
         J2QjqrEOfHf6zfcPuRgpI+e7tOoP+miSwDniXSGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Bouwmann <bouwmann@tau-tec.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/149] iio: fix center temperature of bmc150-accel-core
Date:   Mon,  4 Nov 2019 22:44:12 +0100
Message-Id: <20191104212140.681522108@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pascal Bouwmann <bouwmann@tau-tec.de>

[ Upstream commit 6c59a962e081df6d8fe43325bbfabec57e0d4751 ]

The center temperature of the supported devices stored in the constant
BMC150_ACCEL_TEMP_CENTER_VAL is not 24 degrees but 23 degrees.

It seems that some datasheets were inconsistent on this value leading
to the error.  For most usecases will only make minor difference so
not queued for stable.

Signed-off-by: Pascal Bouwmann <bouwmann@tau-tec.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bmc150-accel-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index 383c802eb5b86..cb8c98a440109 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -125,7 +125,7 @@
 #define BMC150_ACCEL_SLEEP_1_SEC		0x0F
 
 #define BMC150_ACCEL_REG_TEMP			0x08
-#define BMC150_ACCEL_TEMP_CENTER_VAL		24
+#define BMC150_ACCEL_TEMP_CENTER_VAL		23
 
 #define BMC150_ACCEL_AXIS_TO_REG(axis)	(BMC150_ACCEL_REG_XOUT_L + (axis * 2))
 #define BMC150_AUTO_SUSPEND_DELAY_MS		2000
-- 
2.20.1



