Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5726452185
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344127AbhKPBFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245504AbhKOTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05A6061A6C;
        Mon, 15 Nov 2021 18:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001355;
        bh=ef/+wVgDWs67FWbRlDLGI6kGjrVJokxKBAR4wBXjiqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shHCGPyMM0ZnCW5gUocbZuSY13PKvKFYqRZ2HF23EXyCsBrsqlwsYb0hAut7XZyt/
         k03q5TtEgwRGMNFzCdf2sMdauffu5JMkQbRYnosMeUZ2Ho4Hk3/ZlbCojg7eWhEoTu
         HWghGj1wWyHsoAOpeGSns5I2PZsP5eHMBmDP6N2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.15 158/917] mfd: simple-mfd-i2c: Select MFD_CORE to fix build error
Date:   Mon, 15 Nov 2021 17:54:13 +0100
Message-Id: <20211115165434.111506106@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

commit 5dc6dafe62099ade0e7232ce9db4013b7673d860 upstream.

MFD_SIMPLE_MFD_I2C should select the MFD_CORE to a prevent build error:

aarch64-linux-ld: drivers/mfd/simple-mfd-i2c.o: in function `simple_mfd_i2c_probe':
drivers/mfd/simple-mfd-i2c.c:55: undefined reference to `devm_mfd_add_devices'

Cc: <stable@vger.kernel.org>
Fixes: c753ea31781aa ("mfd: simple-mfd-i2c: Add support for registering devices via MFD cells")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211102100420.112215-1-robert.marko@sartura.hr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1194,6 +1194,7 @@ config MFD_SI476X_CORE
 config MFD_SIMPLE_MFD_I2C
 	tristate
 	depends on I2C
+	select MFD_CORE
 	select REGMAP_I2C
 	help
 	  This driver creates a single register map with the intention for it


