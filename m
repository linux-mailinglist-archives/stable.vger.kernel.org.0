Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE576190F25
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCXNSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgCXNSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D04206F6;
        Tue, 24 Mar 2020 13:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055880;
        bh=mjm9lXsDUkQcojDLhC25W/kDX2lM5gjy9tCWyqwiQg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAq43nNCE6XCUb+zPECAFnN5X+UrRfduAIve3Q8qRdszD3V6oVvahM14ZUYNcCDQC
         EoVncnYVSmdYuw1X0/Jc+yfxbWcVXH1EB4EbVuYy/r7nzf9RxIkRrFvLCy6q2piBun
         JCWnEYt3gyYrFm/B/dqBlh2D7kKdsTYOdIMTXTE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 056/102] iio: chemical: sps30: fix missing triggered buffer dependency
Date:   Tue, 24 Mar 2020 14:10:48 +0100
Message-Id: <20200324130812.405543780@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
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


