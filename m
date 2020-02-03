Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771AA150D75
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgBCQ3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729734AbgBCQ3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:29:14 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CC2620838;
        Mon,  3 Feb 2020 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747353;
        bh=KQRTBNGIx/d9uZvKRGCFrbPP4MYDMOG24kIsgdaTp+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbsZqPZFD7sePRVKDmCVj6EPDDYTN0ii/idxC2450Nw3J1q9c7bvT5elaVgUPrUoz
         Dts9mErRmO4Ue25gsXTyV+v09OGvAf5zurSvl+OmyowQWqcIIaeG5vEdTAjKRQBKRi
         YKEmOYjuXtC2v8+8vV6/yLr1Nn+rKXwz4rm57BBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+6bf9606ee955b646c0e1@syzkaller.appspotmail.com
Subject: [PATCH 4.14 48/89] media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0
Date:   Mon,  3 Feb 2020 16:19:33 +0000
Message-Id: <20200203161923.396965402@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
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
@@ -12,7 +12,7 @@
 int dvb_usb_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 	u16 rlen, int delay_ms)
 {
-	int actlen,ret = -ENOMEM;
+	int actlen = 0, ret = -ENOMEM;
 
 	if (!d || wbuf == NULL || wlen == 0)
 		return -EINVAL;


