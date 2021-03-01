Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F086132902F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbhCAUDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242466AbhCATxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC8AE650BB;
        Mon,  1 Mar 2021 17:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621210;
        bh=Ha7b+R+8cQI6qNWKr8Qtr3BXk0f/t+MY+HrXhaotwVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0sfaM7XfgAqOM2tpZZ6g/MzyWTshZLNPW9Ygf/Y96JhWNUSWMJL+w6fVLlXnyCUK
         bY3rbK1FyfRG0ZaMKCcKRmLBGfXadKQ+nRJ2teztWii8LyGHKgPaEIqfjhVKp654IJ
         NhngRQBo3Ls8PMXGreme1gNUOMLiHlRLI7Sy9p7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Nicolas Pitre <npitre@baylibre.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 403/775] i3c/master/mipi-i3c-hci: Specify HAS_IOMEM dependency
Date:   Mon,  1 Mar 2021 17:09:31 +0100
Message-Id: <20210301161221.503020506@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 9d909f1b1e91b4aa7d016ed14b7b76dbf2675414 ]

The MIPI i3c HCI driver makes use of IOMEM functions like
devm_platform_ioremap_resource(), which are only available if
CONFIG_HAS_IOMEM is defined.

This causes the driver to be enabled under make ARCH=um allyesconfig,
even though it won't build.

By adding a dependency on HAS_IOMEM, the driver will not be enabled on
architectures which don't support it.

Fixes: 9ad9a52cce28 ("i3c/master: introduce the mipi-i3c-hci driver")
Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Nicolas Pitre <npitre@baylibre.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210127040636.1535722-1-davidgow@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/Kconfig b/drivers/i3c/master/Kconfig
index e68f15f4b4d0c..afff0e2320f74 100644
--- a/drivers/i3c/master/Kconfig
+++ b/drivers/i3c/master/Kconfig
@@ -25,6 +25,7 @@ config DW_I3C_MASTER
 config MIPI_I3C_HCI
 	tristate "MIPI I3C Host Controller Interface driver (EXPERIMENTAL)"
 	depends on I3C
+	depends on HAS_IOMEM
 	help
 	  Support for hardware following the MIPI Aliance's I3C Host Controller
 	  Interface specification.
-- 
2.27.0



