Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5C26DDE3
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfGSEJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732471AbfGSEJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:09:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E25C2189D;
        Fri, 19 Jul 2019 04:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509349;
        bh=iZ67JdgCIuYaVGiGuIHDqG7PjRoM2Dbn3bbUpNl2z/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUJfk4JA6hNAdkyyaFGBwTx/X8DW4MqIt9mh0CwVFJ61xj+c4YPkV4gbrwXI2a7CX
         8oQ9bNxJ/vvpdTAlxkjomW63EDLkxtYMXSpag+aRLpNeEFGrPMZksQspmDsp+SBJ/M
         WAnn7VeUkSkNspSsTe2CNtHo9CHgUz4ft9sGRmD4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bastien Nocera <hadess@hadess.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 047/101] iio: iio-utils: Fix possible incorrect mask calculation
Date:   Fri, 19 Jul 2019 00:06:38 -0400
Message-Id: <20190719040732.17285-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 208a68c8393d6041a90862992222f3d7943d44d6 ]

On some machines, iio-sensor-proxy was returning all 0's for IIO sensor
values. It turns out that the bits_used for this sensor is 32, which makes
the mask calculation:

*mask = (1 << 32) - 1;

If the compiler interprets the 1 literals as 32-bit ints, it generates
undefined behavior depending on compiler version and optimization level.
On my system, it optimizes out the shift, so the mask value becomes

*mask = (1) - 1;

With a mask value of 0, iio-sensor-proxy will always return 0 for every axis.

Avoid incorrect 0 values caused by compiler optimization.

See original fix by Brett Dutro <brett.dutro@gmail.com> in
iio-sensor-proxy:
https://github.com/hadess/iio-sensor-proxy/commit/9615ceac7c134d838660e209726cd86aa2064fd3

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index 7a6d61c6c012..55272fef3b50 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -159,9 +159,9 @@ int iioutils_get_type(unsigned *is_signed, unsigned *bytes, unsigned *bits_used,
 			*be = (endianchar == 'b');
 			*bytes = padint / 8;
 			if (*bits_used == 64)
-				*mask = ~0;
+				*mask = ~(0ULL);
 			else
-				*mask = (1ULL << *bits_used) - 1;
+				*mask = (1ULL << *bits_used) - 1ULL;
 
 			*is_signed = (signchar == 's');
 			if (fclose(sysfsfp)) {
-- 
2.20.1

