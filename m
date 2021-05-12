Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432E037CCCC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhELQrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243576AbhELQle (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 137A061166;
        Wed, 12 May 2021 16:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835510;
        bh=jHIb7LeLnE2hgOS8iOKFwyqP9aUTIdVSm1wwR+1+nh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMTmAuQvNc8kW2jPlL+jV4mjVTqdSn0y1KGMTLS59DeY13PsI+L0tVR1eV24N5DXt
         NMjhI6/SdNfaB24ILwvHPmuo2ELC4ThF2YgOI8OMDskUb81encwgbJ2CJrlKp59C9Z
         KhiRexDWHX3OBQjkWNDvuPUaUrF6kq0qdxDrKUuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 338/677] spi: tools: make a symbolic link to the header file spi.h
Date:   Wed, 12 May 2021 16:46:24 +0200
Message-Id: <20210512144848.507335554@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit bc2e9578baed90f36abe6bb922b9598a327b0555 ]

The header file spi.h in include/uapi/linux/spi is needed for spidev.h,
so we also need make a symbolic link to it to eliminate the error message
as below:

In file included from spidev_test.c:24:
include/linux/spi/spidev.h:28:10: fatal error: linux/spi/spi.h: No such file or directory
   28 | #include <linux/spi/spi.h>
      |          ^~~~~~~~~~~~~~~~~
compilation terminated.

Fixes: f7005142dace ("spi: uapi: unify SPI modes into a single spi.h")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20210422102604.3034217-1-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/spi/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/spi/Makefile b/tools/spi/Makefile
index ada881afb489..0aa6dbd31fb8 100644
--- a/tools/spi/Makefile
+++ b/tools/spi/Makefile
@@ -25,11 +25,12 @@ include $(srctree)/tools/build/Makefile.include
 #
 # We need the following to be outside of kernel tree
 #
-$(OUTPUT)include/linux/spi/spidev.h: ../../include/uapi/linux/spi/spidev.h
+$(OUTPUT)include/linux/spi: ../../include/uapi/linux/spi
 	mkdir -p $(OUTPUT)include/linux/spi 2>&1 || true
 	ln -sf $(CURDIR)/../../include/uapi/linux/spi/spidev.h $@
+	ln -sf $(CURDIR)/../../include/uapi/linux/spi/spi.h $@
 
-prepare: $(OUTPUT)include/linux/spi/spidev.h
+prepare: $(OUTPUT)include/linux/spi
 
 #
 # spidev_test
-- 
2.30.2



