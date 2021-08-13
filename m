Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1F43EB849
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbhHMPMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241848AbhHMPLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D1966109E;
        Fri, 13 Aug 2021 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867484;
        bh=i2zCazZeP+sT2YQiWWWFNaOJ/n/UKH3EC44jbWO8rzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGb8o3d80qqgsZmnMgi2N3/rC6mEmu9me0G1iM3yJu0FicloHYix1AIG21KlKXlGA
         B4ul1j0AQOquO44lPTxsvHXgjakSNx1xmgH0UvXVazCNuXSn4IDBnq880UeoxyoW1W
         JA0i4LA//waxEp1LVshQD3ag16rUN2ah8wiOv1/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 31/42] spi: meson-spicc: fix memory leak in meson_spicc_remove
Date:   Fri, 13 Aug 2021 17:06:57 +0200
Message-Id: <20210813150526.149061469@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
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
@@ -599,6 +599,8 @@ static int meson_spicc_remove(struct pla
 
 	clk_disable_unprepare(spicc->core);
 
+	spi_master_put(spicc->master);
+
 	return 0;
 }
 


