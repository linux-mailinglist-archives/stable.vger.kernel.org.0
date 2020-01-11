Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A84313805F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbgAKK2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbgAKK2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:28:47 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 684022087F;
        Sat, 11 Jan 2020 10:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738526;
        bh=Zhh8mlWbxSNHdATn4ItCyFo0X+Liip+CoikS38de9UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6OwVutYjIja0+xWLIYyTgOUfAjc1GCQlW5DnxX1LG2cE94l/vr3mrwnpK/gVYMJU
         IsVKCvOMAbmYDgMo9Jmzi7Ljd4caa67xQf6ox6irpczuBRFhXbBn0afruYCtXAGcSe
         UqQ8nnpBLZFGZgn0Umz5iAtdT0J9qe5AQJ0yNP8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/165] staging: axis-fifo: add unspecified HAS_IOMEM dependency
Date:   Sat, 11 Jan 2020 10:50:13 +0100
Message-Id: <20200111094929.103632802@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit d3aa8de6b5d0853c43c616586b4e232aa1fa7de9 ]

Currently CONFIG_XIL_AXIS_FIFO=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

ld: drivers/staging/axis-fifo/axis-fifo.o: in function `axis_fifo_probe':
drivers/staging/axis-fifo/axis-fifo.c:809: undefined reference to `devm_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Reported-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Link: https://lore.kernel.org/r/20191211192742.95699-7-brendanhiggins@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/axis-fifo/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/axis-fifo/Kconfig b/drivers/staging/axis-fifo/Kconfig
index 3fffe4d6f327..f180a8e9f58a 100644
--- a/drivers/staging/axis-fifo/Kconfig
+++ b/drivers/staging/axis-fifo/Kconfig
@@ -4,7 +4,7 @@
 #
 config XIL_AXIS_FIFO
 	tristate "Xilinx AXI-Stream FIFO IP core driver"
-	depends on OF
+	depends on OF && HAS_IOMEM
 	help
 	  This adds support for the Xilinx AXI-Stream FIFO IP core driver.
 	  The AXI Streaming FIFO allows memory mapped access to a AXI Streaming
-- 
2.20.1



