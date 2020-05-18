Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAAF1D86F6
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgERRmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgERRmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:42:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E4B720853;
        Mon, 18 May 2020 17:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823736;
        bh=nqk65ExJOdZgrlp+sPs18FmX7l3Sc++Un1T815Rqp1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp8YDdwtBbiX/nsVGfOKQA6OT3bHt6T7Kg0iqZQBV0FiDJkD3Q7SxXb9uM/SwxxDo
         w8kfCdvDZxcR6R3Lewmsez7cz2c3pCwZbjmxlSs5dWFDXOqj+/hqOtSHe7k4mvEaI6
         q9dn4At74Q86gQGZJ+Ktllr428b5uPyLN0phGXf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        syzbot+d29e9263e13ce0b9f4fd@syzkaller.appspotmail.com
Subject: [PATCH 4.9 16/90] USB: serial: garmin_gps: add sanity checking for data length
Date:   Mon, 18 May 2020 19:35:54 +0200
Message-Id: <20200518173454.516123435@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit e9b3c610a05c1cdf8e959a6d89c38807ff758ee6 upstream.

We must not process packets shorter than a packet ID

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-and-tested-by: syzbot+d29e9263e13ce0b9f4fd@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/garmin_gps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1161,8 +1161,8 @@ static void garmin_read_process(struct g
 		   send it directly to the tty port */
 		if (garmin_data_p->flags & FLAGS_QUEUING) {
 			pkt_add(garmin_data_p, data, data_length);
-		} else if (bulk_data ||
-			   getLayerId(data) == GARMIN_LAYERID_APPL) {
+		} else if (bulk_data || (data_length >= sizeof(u32) &&
+				getLayerId(data) == GARMIN_LAYERID_APPL)) {
 
 			spin_lock_irqsave(&garmin_data_p->lock, flags);
 			garmin_data_p->flags |= APP_RESP_SEEN;


