Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735883E7F4A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhHJRjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233287AbhHJRhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1202E61051;
        Tue, 10 Aug 2021 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616975;
        bh=aUQN+ps0+WrA92b8jdBM+CXbpGx5aOvw2PA2MQT661k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yX0LmLJ6PSTFrOUT4KqF9eGMmo/cdkfQNKwWafcf3MD0BW6+ZX1pE47eDUHwQ0lz
         oxwvp9h7ZHuk0pEMt40OLynu/eLVHKbKSygSdLyXMc+A8WLxdxjcBPBiQ/XUMnX64Z
         TI8AbmjSGrVRQdqq6kkAXgXuUYU9RJr3hFdlaFsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 75/85] spi: meson-spicc: fix memory leak in meson_spicc_remove
Date:   Tue, 10 Aug 2021 19:30:48 +0200
Message-Id: <20210810172950.772393521@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 8311ee2164c5cd1b63a601ea366f540eae89f10e upstream.

In meson_spicc_probe, the error handling code needs to clean up master
by calling spi_master_put, but the remove function does not have this
function call. This will lead to memory leak of spicc->master.

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Fixes: 454fa271bc4e("spi: Add Meson SPICC driver")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Link: https://lore.kernel.org/r/20210720100116.1438974-1-mudongliangabcd@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-meson-spicc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -597,6 +597,8 @@ static int meson_spicc_remove(struct pla
 
 	clk_disable_unprepare(spicc->core);
 
+	spi_master_put(spicc->master);
+
 	return 0;
 }
 


