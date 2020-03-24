Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D26190FDD
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgCXNXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729050AbgCXNXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:23:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDA4208FE;
        Tue, 24 Mar 2020 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056226;
        bh=mjm9lXsDUkQcojDLhC25W/kDX2lM5gjy9tCWyqwiQg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaXdxcVkdA8ix+/sorOfkJhu1CYuZ+jJMxYDX+fZq+1mImoPbmxAUo1PsNvh5yhG0
         kO3+dk5oQL3WrlxYu1r+CjCOE2qgGx2fM51u9srhqXOTAG2CXkpn5SeDH6SRgQpbn7
         p6RH7TKQQpG0AF/Ac89H9ixnUWDy8ncE5B32VSiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.5 062/119] iio: chemical: sps30: fix missing triggered buffer dependency
Date:   Tue, 24 Mar 2020 14:10:47 +0100
Message-Id: <20200324130814.418252942@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Štetiar <ynezz@true.cz>

commit 016a8845f6da65b2203f102f192046fbb624e250 upstream.

SPS30 uses triggered buffer, but the dependency is not specified in the
Kconfig file.  Fix this by selecting IIO_BUFFER and IIO_TRIGGERED_BUFFER
config symbols.

Cc: stable@vger.kernel.org
Fixes: 232e0f6ddeae ("iio: chemical: add support for Sensirion SPS30 sensor")
Signed-off-by: Petr Štetiar <ynezz@true.cz>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/chemical/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/chemical/Kconfig
+++ b/drivers/iio/chemical/Kconfig
@@ -91,6 +91,8 @@ config SPS30
 	tristate "SPS30 particulate matter sensor"
 	depends on I2C
 	select CRC8
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here to build support for the Sensirion SPS30 particulate
 	  matter sensor.


