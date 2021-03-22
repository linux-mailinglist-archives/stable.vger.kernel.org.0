Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3417C344379
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhCVMvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231890AbhCVMtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0478D619F2;
        Mon, 22 Mar 2021 12:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417090;
        bh=rMiXf3y4d/N4zzkko3dcRdSWVLqsaXK6sKnkpf+KjZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLdEVD7I+Q0ckXCjUerUIevdNCuRGKElAJL5AwWzBAYn4s3Nl4yWs1Ia9S2so+vpa
         hW1RfasFzrqryapn1Rw2gsK/ag98UTUTOdmXDVY6krLpTwdstnoHzofazxzJGYEZM6
         3ZD32S/18CF7tTIqPnaqYchXlwsxmCFa0NHjjE7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 4.19 23/43] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
Date:   Mon, 22 Mar 2021 13:28:37 +0100
Message-Id: <20210322121920.676112916@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -175,7 +175,7 @@ static ssize_t usbip_sockfd_store(struct
 
 		udc->ud.tcp_socket = socket;
 		udc->ud.tcp_rx = tcp_rx;
-		udc->ud.tcp_rx = tcp_tx;
+		udc->ud.tcp_tx = tcp_tx;
 		udc->ud.status = SDEV_ST_USED;
 
 		spin_unlock_irq(&udc->ud.lock);


