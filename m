Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260E71FDB40
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgFRBK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728677AbgFRBK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7B920FC3;
        Thu, 18 Jun 2020 01:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442656;
        bh=4c9S6FURyonScEFoga9oPeWRSMUvU8RRm/1RiPP9Ne8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+lYJfrkwUteFnjeqU/ljtlEqVOw0oHjVUm8x2xOOolHKDQly+I8lZst8efelpXNe
         oPcP67z2lYFcy8o2hejMCbFHn9Dx7xnA9gyPrKdTfN7tbNAjFZCh1pGbcaUuPKf2D7
         qaeY2FC10dYv/fyelsl+eK9dWx4Ud6CFl1p851Ak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        kbuild test robot <lkp@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 128/388] iio: buffer-dmaengine: use %zu specifier for sprintf(align)
Date:   Wed, 17 Jun 2020 21:03:45 -0400
Message-Id: <20200618010805.600873-128-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 6eb3b8acfd079104571c207d4524743b6acc6550 ]

The 'size_t' type behaves differently on 64-bit architectures, and causes
compiler a warning of the sort "format '%u' expects argument of type
'unsigned int', but argument 3 has type 'size_t {aka long unsigned int}'".

This change adds the correct specifier for the 'align' field.

Fixes: 4538c18568099 ("iio: buffer-dmaengine: Report buffer length requirements")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/buffer/industrialio-buffer-dmaengine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/buffer/industrialio-buffer-dmaengine.c b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
index b129693af0fd..94da3b1ca3a2 100644
--- a/drivers/iio/buffer/industrialio-buffer-dmaengine.c
+++ b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
@@ -134,7 +134,7 @@ static ssize_t iio_dmaengine_buffer_get_length_align(struct device *dev,
 	struct dmaengine_buffer *dmaengine_buffer =
 		iio_buffer_to_dmaengine_buffer(indio_dev->buffer);
 
-	return sprintf(buf, "%u\n", dmaengine_buffer->align);
+	return sprintf(buf, "%zu\n", dmaengine_buffer->align);
 }
 
 static IIO_DEVICE_ATTR(length_align_bytes, 0444,
-- 
2.25.1

