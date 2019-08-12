Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785F38A89E
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 22:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfHLUsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 16:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbfHLUsf (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 12 Aug 2019 16:48:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E2920684;
        Mon, 12 Aug 2019 20:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565642914;
        bh=qMyCUMZwqN96QlCNlGV9zv2JsVJILR/22zOP3q0zy7w=;
        h=Subject:To:From:Date:From;
        b=G8shCffwFXsN59z5YjnUjzq+EZpjppU1+iHDK3cQU0iw6Rx3G8aeiwSwYFcvKk9Zh
         m/n6jFXyiQq5x+VFeDbJJTZs7oMjPTGa658DyjpvpI4qpXt431v+KPL7HXdkyGXT57
         CBsmGxooxOTWc3wZrMDhSwYoUwuq49S9dZvtvVkw=
Subject: patch "iio: frequency: adf4371: Fix output frequency setting" added to staging-linus
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, stefan.popa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 12 Aug 2019 22:48:31 +0200
Message-ID: <156564291112814@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: frequency: adf4371: Fix output frequency setting

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 82a5008a341d301da3ab529ca888c64f529bd075 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Mon, 5 Aug 2019 15:37:16 +0200
Subject: iio: frequency: adf4371: Fix output frequency setting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The fract1 word was not being properly programmed on the device leading
to wrong output frequencies.

Fixes: 7f699bd14913 (iio: frequency: adf4371: Add support for ADF4371 PLL)
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Stefan Popa <stefan.popa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/frequency/adf4371.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/frequency/adf4371.c b/drivers/iio/frequency/adf4371.c
index e48f15cc9ab5..ff82863cbf42 100644
--- a/drivers/iio/frequency/adf4371.c
+++ b/drivers/iio/frequency/adf4371.c
@@ -276,11 +276,11 @@ static int adf4371_set_freq(struct adf4371_state *st, unsigned long long freq,
 	st->buf[0] = st->integer >> 8;
 	st->buf[1] = 0x40; /* REG12 default */
 	st->buf[2] = 0x00;
-	st->buf[3] = st->fract2 & 0xFF;
-	st->buf[4] = st->fract2 >> 7;
-	st->buf[5] = st->fract2 >> 15;
+	st->buf[3] = st->fract1 & 0xFF;
+	st->buf[4] = st->fract1 >> 8;
+	st->buf[5] = st->fract1 >> 16;
 	st->buf[6] = ADF4371_FRAC2WORD_L(st->fract2 & 0x7F) |
-		     ADF4371_FRAC1WORD(st->fract1 >> 23);
+		     ADF4371_FRAC1WORD(st->fract1 >> 24);
 	st->buf[7] = ADF4371_FRAC2WORD_H(st->fract2 >> 7);
 	st->buf[8] = st->mod2 & 0xFF;
 	st->buf[9] = ADF4371_MOD2WORD(st->mod2 >> 8);
-- 
2.22.0


