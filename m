Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1C5106E55
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbfKVLFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:05:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731665AbfKVLFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:05:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF4F20855;
        Fri, 22 Nov 2019 11:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420711;
        bh=FFuKDouo1rf8UsWPhO0vImXh4I1do/bn4P75rop+b8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2d0OhUfUg1byiJvzhcuLqHfbEMtJHTaw+Uhjq9sW0B5sScAiByOu+QF94k2WTZB+
         xgtAHdzev7jmM1Tkm7VM0EfvDOu8JQqcX8qnEPtkdpJZUI5897hw5iY+/P/jznFMvT
         C+3ISLEsTmNwDqrD3IahHLyk7m4rsWRCTtGiKdJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guglielmo Fanini <g.fanini@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 199/220] hwmon: (k10temp) Support all Family 15h Model 6xh and Model 7xh processors
Date:   Fri, 22 Nov 2019 11:29:24 +0100
Message-Id: <20191122100928.255795670@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 53dfa0088edd2e2793afa21488532b12eb2dae48 ]

BIOS developer guides refer to Family 15h Models 60h-6fh and Family 15h
Models 70h-7fh. So far the driver only checked for Models 60h and 70h.
However, there are now processors with other model numbers in the same
families. Example is A10-9620P family 15h model 65h. Follow the developer
guides and mask the lower 4 bit of the model number to determine the
registers to use for reading temperatures and temperature limits.

Reported-by: Guglielmo Fanini <g.fanini@gmail.com>
Cc: Guglielmo Fanini <g.fanini@gmail.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/k10temp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index bb15d7816a294..2cef0c37ff6fe 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -325,8 +325,9 @@ static int k10temp_probe(struct pci_dev *pdev,
 
 	data->pdev = pdev;
 
-	if (boot_cpu_data.x86 == 0x15 && (boot_cpu_data.x86_model == 0x60 ||
-					  boot_cpu_data.x86_model == 0x70)) {
+	if (boot_cpu_data.x86 == 0x15 &&
+	    ((boot_cpu_data.x86_model & 0xf0) == 0x60 ||
+	     (boot_cpu_data.x86_model & 0xf0) == 0x70)) {
 		data->read_htcreg = read_htcreg_nb_f15;
 		data->read_tempreg = read_tempreg_nb_f15;
 	} else if (boot_cpu_data.x86 == 0x17) {
-- 
2.20.1



