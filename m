Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947FC36AD70
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhDZHgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhDZHgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6854161360;
        Mon, 26 Apr 2021 07:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422423;
        bh=cSKMPvzKiZHkjkJf3FKCkhDji03VdrGi0SEVc4Tvhz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=St7Hv9mYk+bwznhtUlj4PdnZx3rxj+PXkkNZ/vt14h4MZRFI8Xn932JbceBL+3+Fr
         uy2I4NvCDJ3j02tDboNrxk0p/ByT494H9AZ6Ugz6SCp6PULfcex3DeePoR0/51fqVh
         8NA2GtIszJRQAqat1KhJHbJ3r+2GbfTJ72Yh+Kn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Colin Ian King <colin.king@canonical.com>,
        Tom Seewald <tseewald@gmail.com>
Subject: [PATCH 4.9 23/37] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
Date:   Mon, 26 Apr 2021 09:29:24 +0200
Message-Id: <20210426072818.037894368@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.

Currently udc->ud.tcp_rx is being assigned twice, the second assignment
is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.

Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Addresses-Coverity: ("Unused value")
Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct devic
 
 		udc->ud.tcp_socket = socket;
 		udc->ud.tcp_rx = tcp_rx;
-		udc->ud.tcp_rx = tcp_tx;
+		udc->ud.tcp_tx = tcp_tx;
 		udc->ud.status = SDEV_ST_USED;
 
 		spin_unlock_irq(&udc->ud.lock);


