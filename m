Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059584356DF
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhJUAXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231509AbhJUAXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 713E5611CC;
        Thu, 21 Oct 2021 00:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775648;
        bh=L0u7HUqTqwVdoFGzgMF58jxJxOxxElco4x0A0WROda8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNRbrF2zRCPhOX3gMOdAgvpvHuwZ5lvzWZnxxk0+O0GxKgFtsCNco/GM97h+8SPCS
         5+FonVh1POKgQ3DAeB0Xb7wDWM2HEfk7+SN4XoIz1hOlZKyoI6PoImsK6sg1j3ic5C
         0jy+89YY66KCKsACLmU9S61cNmEXdJOvcbRMPkEb7rUqOaCYxUTmssEqoo9N3+G1lU
         ucyZ2JnHGeZna7ZZuNAtphKduZrU6PQVIbd4KktJ4IAaswpCvlZgYE/mz+YKq/SZGH
         GBRGkIvxux4rZIbsbvOqh//6oCm6fq8In2PqtjKIiQMmaoRXWSUa4Q5WpCKNhZU1zr
         a38u77Pqwz5EA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        lars@metafoo.de, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 04/26] iio/test-format: build kunit tests without structleak plugin
Date:   Wed, 20 Oct 2021 20:20:01 -0400
Message-Id: <20211021002023.1128949-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 2326f3cdba1d105b68cc1295e78f17ae8faa5a76 ]

The structleak plugin causes the stack frame size to grow immensely when
used with KUnit:

../drivers/iio/test/iio-test-format.c: In function ‘iio_test_iio_format_value_fixedpoint’:
../drivers/iio/test/iio-test-format.c:98:1: warning: the frame size of 2336 bytes is larger than 2048 bytes [-Wframe-larger-than=]

Turn it off in this file.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/test/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/test/Makefile b/drivers/iio/test/Makefile
index f1099b495301..467519a2027e 100644
--- a/drivers/iio/test/Makefile
+++ b/drivers/iio/test/Makefile
@@ -5,3 +5,4 @@
 
 # Keep in alphabetical order
 obj-$(CONFIG_IIO_TEST_FORMAT) += iio-test-format.o
+CFLAGS_iio-test-format.o += $(DISABLE_STRUCTLEAK_PLUGIN)
-- 
2.33.0

