Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A2A150E01
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgBCQ0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgBCQ0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:26:04 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078DF2051A;
        Mon,  3 Feb 2020 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747164;
        bh=II7bm7gFnpRH7TiY1EXfjy9NpIByqTPjFSJhKZdIt90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmJimQ0LvICr47ZLMJn8J4XRhvLYrJ5zKnANBSs8FA1aobEgOQKl7gECdtGbtgFlo
         ZGZ+d8gJz4NmAazRmzk1BfIyCEe8EzrfMjPo6QG2qWKCyntZ/uh4siKZ2Y7qYHJMsN
         ccFPD2UVCyyCTNJ//G5Z0m/TxsBOuNsTDk7es1QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+6bf9606ee955b646c0e1@syzkaller.appspotmail.com
Subject: [PATCH 4.9 37/68] media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0
Date:   Mon,  3 Feb 2020 16:19:33 +0000
Message-Id: <20200203161911.059663994@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 569bc8d6a6a50acb5fcf07fb10b8d2d461fdbf93 upstream.

This fixes a syzbot failure since actlen could be uninitialized,
but it was still used.

Syzbot link:

https://syzkaller.appspot.com/bug?extid=6bf9606ee955b646c0e1

Reported-and-tested-by: syzbot+6bf9606ee955b646c0e1@syzkaller.appspotmail.com

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/dvb-usb-urb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/dvb-usb-urb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-urb.c
@@ -11,7 +11,7 @@
 int dvb_usb_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 	u16 rlen, int delay_ms)
 {
-	int actlen,ret = -ENOMEM;
+	int actlen = 0, ret = -ENOMEM;
 
 	if (!d || wbuf == NULL || wlen == 0)
 		return -EINVAL;


