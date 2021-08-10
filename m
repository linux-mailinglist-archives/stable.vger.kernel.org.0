Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3A33E8081
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhHJRuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234555AbhHJRrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:47:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F8AA6023E;
        Tue, 10 Aug 2021 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617258;
        bh=HPpoJHqEyQFFQr1mBXEm3NQEDkewRfD81StpTolw5KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alcGB6UVtGXCEyxHhb3t4ckKj2FdSRfJh7CaIaqZmgTRup7GRRy64JCv4Sz3itnbE
         OFhiemf9NzTZ13b9rHQP/eCLs1VF+un6imG5QA56OWh62Q6ZzNN7cubcfgwwepRSO4
         DoaFdjz2z00jNMocLeIzJexM06uV0B/tjyb/Y1V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 116/135] spi: meson-spicc: fix memory leak in meson_spicc_remove
Date:   Tue, 10 Aug 2021 19:30:50 +0200
Message-Id: <20210810172959.734172948@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
@@ -785,6 +785,8 @@ static int meson_spicc_remove(struct pla
 	clk_disable_unprepare(spicc->core);
 	clk_disable_unprepare(spicc->pclk);
 
+	spi_master_put(spicc->master);
+
 	return 0;
 }
 


