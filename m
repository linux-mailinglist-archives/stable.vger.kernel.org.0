Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A562311DC2
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfEBPcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728349AbfEBPcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410F2204FD;
        Thu,  2 May 2019 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811172;
        bh=TDcYA3yCdFSvEvqNP5VLT/qJ0q6rfiqsgb0e7fcpklQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kq3Gsowdh9HytIR1j78YXzegwlHUFm/KyJvojbVPlVzTt/+v++5onaExkGaYjSgN/
         9EDTF5LcI1XiV7k8UC5y3E3lFwTIEhspPwHjIhKEr9+wV5rBEaZpTYN4cggk/kE23u
         0A3aMpjTWbeQmzM5szYITLl7SpmsiJuhLjdJa4wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 101/101] leds: trigger: netdev: use memcpy in device_name_store
Date:   Thu,  2 May 2019 17:21:43 +0200
Message-Id: <20190502143346.769794023@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 909346433064b8d840dc82af26161926b8d37558 ]

If userspace doesn't end the input with a newline (which can easily
happen if the write happens from a C program that does write(fd,
iface, strlen(iface))), we may end up including garbage from a
previous, longer value in the device_name. For example

# cat device_name

# printf 'eth12' > device_name
# cat device_name
eth12
# printf 'eth3' > device_name
# cat device_name
eth32

I highly doubt anybody is relying on this behaviour, so switch to
simply copying the bytes (we've already checked that size is <
IFNAMSIZ) and unconditionally zero-terminate it; of course, we also
still have to strip a trailing newline.

This is also preparation for future patches.

Fixes: 06f502f57d0d ("leds: trigger: Introduce a NETDEV trigger")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 167a94c02d05..136f86a1627d 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -122,7 +122,8 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev = NULL;
 	}
 
-	strncpy(trigger_data->device_name, buf, size);
+	memcpy(trigger_data->device_name, buf, size);
+	trigger_data->device_name[size] = 0;
 	if (size > 0 && trigger_data->device_name[size - 1] == '\n')
 		trigger_data->device_name[size - 1] = 0;
 
-- 
2.19.1



