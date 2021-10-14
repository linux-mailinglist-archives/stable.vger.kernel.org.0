Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7141942DC6B
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhJNO6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232137AbhJNO6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3F060F4A;
        Thu, 14 Oct 2021 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223376;
        bh=SZL4ZzgKXw2YKtFogconlp3OFvkFA0CuUW/1A2Jq5OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yefBGz0LA2ZWGkuHtMPdLiqlbzF4t+7AUPPvWwRtoY5Or7Lc1buQlOQ25Coe8xcRA
         tAGNhMa3p5SkSyC57eUKST9VTX5mJiA3axJH4lispDWSEM+2f8VzLeKolcWTR592IZ
         MrTyF559+oe+qNObjI4aG07b3vejI3X2Frs/IAHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 03/25] USB: cdc-acm: fix break reporting
Date:   Thu, 14 Oct 2021 16:53:34 +0200
Message-Id: <20211014145207.690301083@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 58fc1daa4d2e9789b9ffc880907c961ea7c062cc upstream.

A recent change that started reporting break events forgot to push the
event to the line discipline, which meant that a detected break would
not be reported until further characters had been receive (the port
could even have been closed and reopened in between).

Fixes: 08dff274edda ("cdc-acm: fix BREAK rx code path adding necessary calls")
Cc: stable@vger.kernel.org
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210929090937.7410-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -349,6 +349,9 @@ static void acm_ctrl_irq(struct urb *urb
 			acm->iocount.overrun++;
 		spin_unlock(&acm->read_lock);
 
+		if (newctrl & ACM_CTRL_BRK)
+			tty_flip_buffer_push(&acm->port);
+
 		if (difference)
 			wake_up_all(&acm->wioctl);
 


