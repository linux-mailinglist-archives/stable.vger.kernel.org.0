Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900823C55AD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhGLILg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353850AbhGLIDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D331961D13;
        Mon, 12 Jul 2021 07:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076689;
        bh=C6FoM+xYZeA5SH4Pz8i7cBlg5IgyUnJrBgKTOc1lWsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOqAmw9gkInlU5z2/sf9TZ5g95n3hUsxrBKdED+1cEs9gElbbOHkd3aHRAQZDzJSX
         PJIL7E8Ws41tSOMvnhhsXKQ7iu2xUNBXzwMrAPbzI1dLJcdsT2YXWSTNJhThNCMlqh
         JE5RnP6UeBmlm8nMXAop4CDhDeK/SOvxD9Ahk6+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 708/800] iio: dummy: Fix build error when CONFIG_IIO_TRIGGERED_BUFFER is not set
Date:   Mon, 12 Jul 2021 08:12:11 +0200
Message-Id: <20210712061042.064846171@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 94588c1bf1c8701392e1dc105c670d0d2fc7676a ]

Gcc reports build error when CONFIG_IIO_TRIGGERED_BUFFER is not set:

riscv64-linux-gnu-ld: drivers/iio/dummy/iio_simple_dummy_buffer.o: in function `iio_simple_dummy_configure_buffer':
iio_simple_dummy_buffer.c:(.text+0x2b0): undefined reference to `iio_triggered_buffer_setup_ext'
riscv64-linux-gnu-ld: drivers/iio/dummy/iio_simple_dummy_buffer.o: in function `.L0 ':
iio_simple_dummy_buffer.c:(.text+0x2fc): undefined reference to `iio_triggered_buffer_cleanup'

Fix it by select IIO_TRIGGERED_BUFFER for config IIO_SIMPLE_DUMMY_BUFFER.

Fixes: 738f6ba11800 ("iio: dummy: iio_simple_dummy_buffer: use triggered buffer core calls")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dummy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/dummy/Kconfig b/drivers/iio/dummy/Kconfig
index 5c5c2f8c55f3..1f46cb9e51b7 100644
--- a/drivers/iio/dummy/Kconfig
+++ b/drivers/iio/dummy/Kconfig
@@ -34,6 +34,7 @@ config IIO_SIMPLE_DUMMY_BUFFER
 	select IIO_BUFFER
 	select IIO_TRIGGER
 	select IIO_KFIFO_BUF
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Add buffered data capture to the simple dummy driver.
 
-- 
2.30.2



