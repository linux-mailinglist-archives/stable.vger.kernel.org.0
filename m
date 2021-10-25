Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BA043A326
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbhJYT4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239261AbhJYTy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:54:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46CCB6109D;
        Mon, 25 Oct 2021 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191116;
        bh=L0u7HUqTqwVdoFGzgMF58jxJxOxxElco4x0A0WROda8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SbKbdeFfwnJjrtxbUfryBzEiaNWkzKwlopfAq4J7HYfJjwc9vTmEkTD2aeD3VLnH
         Z6lnCPEP3cmHSeB244XQ38DufAXFEtNc2TfhBeMGD+bIV/0i2BIBUEca33k4reMCr7
         v6lHwM3ebkkBbAlrsX6hScy+zNHr53co31qZEKIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 128/169] iio/test-format: build kunit tests without structleak plugin
Date:   Mon, 25 Oct 2021 21:15:09 +0200
Message-Id: <20211025191033.937320016@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



