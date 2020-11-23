Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E02C0782
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732558AbgKWMkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:40:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732553AbgKWMkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8507320732;
        Mon, 23 Nov 2020 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135247;
        bh=ymHBzHjZBKjhUiOdIHUAkAUL3+rX6EiiTK+jwWixTVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNDXzjxcMSbeeIt2LT+frfgD1yhaikN3RDMa2KrcsUNBtzVWrOXJym2anRSFlQqSm
         CE0RZqzGW6fXum521FFdZtMdRjW8v5MezL8eqh5TEs/jxUJniTMrZzvpj1ExODG5kv
         ENknouFe7Og78508KXsoPlajVSSYYtNl+is4LGy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 128/158] iio: light: fix kconfig dependency bug for VCNL4035
Date:   Mon, 23 Nov 2020 13:22:36 +0100
Message-Id: <20201123121826.109321732@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

commit 44a146a44f656fc03d368c1b9248d29a128cd053 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -485,6 +485,7 @@ config VCNL4000
 
 config VCNL4035
 	tristate "VCNL4035 combined ALS and proximity sensor"
+	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	select REGMAP_I2C
 	depends on I2C


