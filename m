Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38B8B5CCE
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfIRGY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfIRGY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A311218AF;
        Wed, 18 Sep 2019 06:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787896;
        bh=6np+q82s1Nx0TkE0BdOMt7YqZ8YXCMzUpWHwV+6xJDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLZTUBsgYehAenyBbNkhwS6tayxPGhyQn6L4bltg2WoSIr1KQCCRwDEQyerxuTMSa
         rJoGxGvJYdUO/UGP8mBAhooeHudwNEyGFhNTuY6BOo096aOmDx2C3eR/V8jsEXGGUM
         LJP/qXIVcHcJ7ctz35XG+i/w1S1GdzAtTxGLKEFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.2 23/85] gpio: mockup: add missing single_release()
Date:   Wed, 18 Sep 2019 08:18:41 +0200
Message-Id: <20190918061234.890530260@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 59929d3a2eb6c4abafc5b61a20c98aa8728ec378 upstream.

When using single_open() for opening, single_release() should be
used instead of seq_release(), otherwise there is a memory leak.

Fixes: 2a9e27408e12 ("gpio: mockup: rework debugfs interface")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-mockup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -309,6 +309,7 @@ static const struct file_operations gpio
 	.read = gpio_mockup_debugfs_read,
 	.write = gpio_mockup_debugfs_write,
 	.llseek = no_llseek,
+	.release = single_release,
 };
 
 static void gpio_mockup_debugfs_setup(struct device *dev,


