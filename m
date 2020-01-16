Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00BB13FCF0
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390566AbgAPXUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390565AbgAPXUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32052072B;
        Thu, 16 Jan 2020 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216807;
        bh=yiFbhYZs4OakPil0W1cRjf0MHa+WDnry7VTabF4Vsrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13xuKyqR4JSLz5EUokm/4Ke6SmbMmWvd2vVooiwopuNPGRrAMN20Y3wFR9ZXUzJtW
         r0QnCpkgUuZDBSxO7Zoy4O4rLp56c5SsE21D9j187Msxs3w2EKZ7x3gyW9o5VWhoVR
         7B5CZ/JgE3NmwjllLqxI2eWg8z7/d1KIbrfw7gQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Osipenko <digetx@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.4 027/203] PM / devfreq: tegra: Add COMMON_CLK dependency
Date:   Fri, 17 Jan 2020 00:15:44 +0100
Message-Id: <20200116231746.779254239@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 5fdb0684b5b0f41402161f068d3d84bf6ed1c3f4 upstream.

Compile-testing this driver fails if CONFIG_COMMON_CLK is not set:

drivers/devfreq/tegra30-devfreq.o: In function `tegra_devfreq_target':
tegra30-devfreq.c:(.text+0x164): undefined reference to `clk_set_min_rate'

Fixes: 35f8dbc72721 ("PM / devfreq: tegra: Enable COMPILE_TEST for the driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/devfreq/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -99,6 +99,7 @@ config ARM_TEGRA_DEVFREQ
 		ARCH_TEGRA_210_SOC || \
 		COMPILE_TEST
 	select PM_OPP
+	depends on COMMON_CLK
 	help
 	  This adds the DEVFREQ driver for the Tegra family of SoCs.
 	  It reads ACTMON counters of memory controllers and adjusts the


