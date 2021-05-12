Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AB737C6BC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhELPxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235611AbhELPte (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B9F661584;
        Wed, 12 May 2021 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833135;
        bh=vR4uCZFVrYols5TeDN297eVtLmebC0YzuyiQeuQ5jSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt+ttQqCoFJzzsQiacP+pIAndmlRHYUgvmeaU4ZWZ9Kg7ByQ/fN9DJNv2pL0v79sr
         ms1+jSpP1JZ1K0BOpgzaIL4vlqM5NdO9aqD5qiIiTYgONwpDJ08cvgIvqTXzs2Si79
         HSoH7jtvlCnn3ELvWz7pBbr3KvSSnuOwS+sOyW4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 007/601] tty: moxa: fix TIOCSSERIAL jiffies conversions
Date:   Wed, 12 May 2021 16:41:24 +0200
Message-Id: <20210512144828.065186912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 6e70b73ca5240c0059a1fbf8ccd4276d6cf71956 upstream.

The port close_delay parameter set by TIOCSSERIAL is specified in
jiffies, while the value returned by TIOCGSERIAL is specified in
centiseconds.

Add the missing conversions so that TIOCGSERIAL works as expected also
when HZ is not 100.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-11-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/moxa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -2040,7 +2040,7 @@ static int moxa_get_serial_info(struct t
 	ss->line = info->port.tty->index,
 	ss->flags = info->port.flags,
 	ss->baud_base = 921600,
-	ss->close_delay = info->port.close_delay;
+	ss->close_delay = jiffies_to_msecs(info->port.close_delay) / 10;
 	mutex_unlock(&info->port.mutex);
 	return 0;
 }
@@ -2069,7 +2069,7 @@ static int moxa_set_serial_info(struct t
 			return -EPERM;
 		}
 	}
-	info->port.close_delay = ss->close_delay * HZ / 100;
+	info->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
 
 	MoxaSetFifo(info, ss->type == PORT_16550A);
 


