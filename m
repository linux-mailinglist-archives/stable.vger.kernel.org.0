Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DA3FA4A5
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbfKMBzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbfKMBzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4344022468;
        Wed, 13 Nov 2019 01:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610142;
        bh=FFuKDouo1rf8UsWPhO0vImXh4I1do/bn4P75rop+b8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrEN91JweZYH0rkigjPdjMeiRSB+7XkmD5tH/RdXijlyKEHSQBSYtIcX1Wdp83Tl/
         4fffia7TZdOV29LtwPDw+txGsYkOGhztNij/uBayYHawDHNyvsgS6kNEsosKKJSuLo
         rD/tOD8WiQJowtsRLNz3HmGvNMXiwtH9V119tsEk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Guglielmo Fanini <g.fanini@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 188/209] hwmon: (k10temp) Support all Family 15h Model 6xh and Model 7xh processors
Date:   Tue, 12 Nov 2019 20:50:04 -0500
Message-Id: <20191113015025.9685-188-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

