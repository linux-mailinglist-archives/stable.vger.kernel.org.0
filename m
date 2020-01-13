Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B0C138FCB
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 12:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgAMLJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 06:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbgAMLJA (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 13 Jan 2020 06:09:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60AF207E0;
        Mon, 13 Jan 2020 11:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578913740;
        bh=wcu0Z5fZ+dRewycFBkPbYL31RrXUOBv9jnLiyZyujeU=;
        h=Subject:To:From:Date:From;
        b=xg+eNMaAzjQYwAB8F+R5LjwjxYOetidY/jwroOTTvyqYsBPW/V7OUxA5RnNEWAKee
         /919VMBJnAzxVw3pPHXdZ+vlIxEE/HawAE+ldUUHUvH5Von5HmtvilCqPOZDVS6IWE
         1Nct3qXp5VU2rWh3pBaqgxpjKvfU0lV0PWhp0QDs=
Subject: patch "iio: chemical: pms7003: fix unmet triggered buffer dependency" added to staging-linus
To:     tduszyns@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, gregkh@linuxfoundation.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jan 2020 12:08:52 +0100
Message-ID: <1578913732105201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: chemical: pms7003: fix unmet triggered buffer dependency

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 217afe63ccf445fc220e5ef480683607b05c0aa5 Mon Sep 17 00:00:00 2001
From: Tomasz Duszynski <tduszyns@gmail.com>
Date: Fri, 13 Dec 2019 22:38:08 +0100
Subject: iio: chemical: pms7003: fix unmet triggered buffer dependency

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
 drivers/iio/chemical/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/chemical/Kconfig b/drivers/iio/chemical/Kconfig
index fa4586037bb8..0b91de4df8f4 100644
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
-- 
2.24.1


