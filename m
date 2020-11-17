Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493692B5C45
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbgKQJwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgKQJwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:52:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E16EA222EC;
        Tue, 17 Nov 2020 09:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605606773;
        bh=hsD9/HaM/L+tCNFFCmhHV6uigQcl57HbKqp2z/62Sgk=;
        h=Subject:To:From:Date:From;
        b=L5vT7mv13WplVc4IAwTrWUR0XOaKjpaJ1ObJ4VFnpIpsMvLASHnfbiCBwNs+0bOz9
         Eh76XB8X/pTt0xqrpnjEtNTFJtZGok8cqWvSNAOXLnNCYedWcJ7MKGmjY5ggvVOplF
         8cS76qgR4k3OHP8wdsfG61g7HCfETOwXSQ7jxXC8=
Subject: patch "iio: light: fix kconfig dependency bug for VCNL4035" added to staging-linus
To:     fazilyildiran@gmail.com, Jonathan.Cameron@huawei.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 10:53:26 +0100
Message-ID: <1605606806180163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: fix kconfig dependency bug for VCNL4035

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 44a146a44f656fc03d368c1b9248d29a128cd053 Mon Sep 17 00:00:00 2001
From: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Date: Tue, 3 Nov 2020 01:35:24 +0300
Subject: iio: light: fix kconfig dependency bug for VCNL4035

When VCNL4035 is enabled and IIO_BUFFER is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for IIO_TRIGGERED_BUFFER
  Depends on [n]: IIO [=y] && IIO_BUFFER [=n]
  Selected by [y]:
  - VCNL4035 [=y] && IIO [=y] && I2C [=y]

The reason is that VCNL4035 selects IIO_TRIGGERED_BUFFER without depending
on or selecting IIO_BUFFER while IIO_TRIGGERED_BUFFER depends on
IIO_BUFFER. This can also fail building the kernel.

Honor the kconfig dependency to remove unmet direct dependency warnings
and avoid any potential build failures.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209883
Link: https://lore.kernel.org/r/20201102223523.572461-1-fazilyildiran@gmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index cade6dc0305b..33ad4dd0b5c7 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -544,6 +544,7 @@ config VCNL4000
 
 config VCNL4035
 	tristate "VCNL4035 combined ALS and proximity sensor"
+	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	select REGMAP_I2C
 	depends on I2C
-- 
2.29.2


