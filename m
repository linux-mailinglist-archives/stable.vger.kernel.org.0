Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807DB2F0A7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfE3DRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbfE3DRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:38 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA0FF24590;
        Thu, 30 May 2019 03:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186257;
        bh=2wpiB4zzn6wBHIQlOWQviFupKUmKgjTIpgGgSQWBWKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7VBSeLC2X3zccMD14rXdIPipFxOIiF0O4RIvl8V5bEoMkAU8RPdyJs3bZoHeIfhA
         cMki4eVZuDHghg4bvaR7BEWZBT89svY/rkXHdnl/y1fhnr8FuxMSo7AcZj8qi1KZ4m
         afkJFlUEgCAEV1oEG2E4wplS7Vw3tHiI9lAvCLI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/276] iio: common: ssp_sensors: Initialize calculated_time in ssp_common_process_data
Date:   Wed, 29 May 2019 20:05:46 -0700
Message-Id: <20190530030536.960912531@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6f9ca1d3eb74b81f811a87002de2d51640d135b1 ]

When building with -Wsometimes-uninitialized, Clang warns:

drivers/iio/common/ssp_sensors/ssp_iio.c:95:6: warning: variable
'calculated_time' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

While it isn't wrong, this will never be a problem because
iio_push_to_buffers_with_timestamp only uses calculated_time
on the same condition that it is assigned (when scan_timestamp
is not zero). While iio_push_to_buffers_with_timestamp is marked
as inline, Clang does inlining in the optimization stage, which
happens after the semantic analysis phase (plus inline is merely
a hint to the compiler).

Fix this by just zero initializing calculated_time.

Link: https://github.com/ClangBuiltLinux/linux/issues/394
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/common/ssp_sensors/ssp_iio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/common/ssp_sensors/ssp_iio.c b/drivers/iio/common/ssp_sensors/ssp_iio.c
index 645f2e3975db4..e38f704d88b7e 100644
--- a/drivers/iio/common/ssp_sensors/ssp_iio.c
+++ b/drivers/iio/common/ssp_sensors/ssp_iio.c
@@ -81,7 +81,7 @@ int ssp_common_process_data(struct iio_dev *indio_dev, void *buf,
 			    unsigned int len, int64_t timestamp)
 {
 	__le32 time;
-	int64_t calculated_time;
+	int64_t calculated_time = 0;
 	struct ssp_sensor_data *spd = iio_priv(indio_dev);
 
 	if (indio_dev->scan_bytes == 0)
-- 
2.20.1



