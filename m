Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444A614550B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAVNSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbgAVNSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:18:21 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F9282467E;
        Wed, 22 Jan 2020 13:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699101;
        bh=5ATbnEXS5jdYGJx+U4E3UUO3331ZkleiTgJsuFchegU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOfmzV7OOs+rDAY8CZeQoKrDyQCraUfAwdEK8yghMq9IXqOFLqaWzEVjhR/mGEYxj
         7GPJYbPybOYEiWjBOMmZeCXNLx7Ql6rUNWhswoBa7ygp2bhkH8MB5y9Gx8JihvvRPb
         XJUjrImFzvb2MOY/N0/5+tFRsBIGWOI7maQvLt/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Duszynski <tduszyns@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 041/222] iio: chemical: pms7003: fix unmet triggered buffer dependency
Date:   Wed, 22 Jan 2020 10:27:07 +0100
Message-Id: <20200122092836.481202605@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Duszynski <tduszyns@gmail.com>

commit 217afe63ccf445fc220e5ef480683607b05c0aa5 upstream.

IIO triggered buffer depends on IIO buffer which is missing from Kconfig
file. This should go unnoticed most of the time because there's a
chance something else has already enabled buffers. In some rare cases
though one might experience kbuild warnings about unmet direct
dependencies and build failures due to missing symbols.

Fix this by selecting IIO_BUFFER explicitly.

Signed-off-by: Tomasz Duszynski <tduszyns@gmail.com>
Fixes: a1d642266c14 ("iio: chemical: add support for Plantower PMS7003 sensor")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/chemical/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/chemical/Kconfig
+++ b/drivers/iio/chemical/Kconfig
@@ -65,6 +65,7 @@ config IAQCORE
 config PMS7003
 	tristate "Plantower PMS7003 particulate matter sensor"
 	depends on SERIAL_DEV_BUS
+	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here to build support for the Plantower PMS7003 particulate


