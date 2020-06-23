Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18647205CDB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387961AbgFWUGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388424AbgFWUGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C024C206C3;
        Tue, 23 Jun 2020 20:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942765;
        bh=8jyORWYAsV4aRkIDoIFzlycpPl9x35H9VUEG9+YqYT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xtL+ytgiEimkVSZOiTUoGteDE5S/TJswLz7ohXuDcYve4lM89KvAdIZstB1Vs3gDm
         x3rFlGnq6oAqKip57tpbRnCika28LuXw/K5Glph/AEBhChg9H5lClI62BVWW+g5HyD
         rr4EuvmlfZC6pSs5GMrRJpJSez6XbfLXMmrse0Rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 126/477] iio: buffer-dmaengine: use %zu specifier for sprintf(align)
Date:   Tue, 23 Jun 2020 21:52:03 +0200
Message-Id: <20200623195413.564474710@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b129693af0fd1..94da3b1ca3a28 100644
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



