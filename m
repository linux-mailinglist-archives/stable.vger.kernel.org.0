Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E116B2F4F5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfE3EnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbfE3DMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:13 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 849A6244A0;
        Thu, 30 May 2019 03:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185932;
        bh=6ZasBnQkNWDrauYS3P0AR+Bx7T/GvEgr4cuwvTY9LWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0M1KdQ5xh1mChOa96AwYK4QiiNqUozf9HNku9MRSw5FwYfxybqZS5C2Wo4d4wvjo
         5OLkWTLSGf04i+0mljyozbaw8pXMs2eXcb/n8+GZK3JQvvRVE8Al1sJcfX+MHONDwL
         GYqti1iOY8wo8t/rV+YtNKeQ+MoC903JA1f5gBR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 328/405] spi: export tracepoint symbols to modules
Date:   Wed, 29 May 2019 20:05:26 -0700
Message-Id: <20190530030557.335473736@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ca1438dcb34c7fcad63b6ce14ea63a870b92a69b ]

The newly added tracepoints in the spi-mxs driver cause a link
error when the driver is a loadable module:

ERROR: "__tracepoint_spi_transfer_stop" [drivers/spi/spi-mxs.ko] undefined!
ERROR: "__tracepoint_spi_transfer_start" [drivers/spi/spi-mxs.ko] undefined!

I'm not quite sure where to put the export statements, but
directly after the inclusion of the header seems as good as
any other place.

Fixes: f3fdea3af405 ("spi: mxs: add tracing to custom .transfer_one_message callback")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e3f2e15b75ad4..6cb72287eac82 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -36,6 +36,8 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/spi.h>
+EXPORT_TRACEPOINT_SYMBOL(spi_transfer_start);
+EXPORT_TRACEPOINT_SYMBOL(spi_transfer_stop);
 
 #include "internals.h"
 
-- 
2.20.1



