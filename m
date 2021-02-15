Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E00431BE33
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhBOQCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 11:02:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhBOPtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:49:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D153664DC3;
        Mon, 15 Feb 2021 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403297;
        bh=QDBg45RFT+SOm/lag6l4rj0iybT9eBugjWUvyOd+7iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdJ5CmdDE4Yr8z2NXlaezPe8kJmQOHTbjHJqSGml3/+W/aAoQCu7JRBmgxHuPCsPs
         oKABefMKV0jteew6B2w86JyxuKnfZ50ptHbUD4FRFqdiKdxFznYArxuVpt+nYBLj60
         NBxg3moB11mjIHNBhwUnaMj63vzZT206H06ABdC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 102/104] net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()
Date:   Mon, 15 Feb 2021 16:27:55 +0100
Message-Id: <20210215152722.761368789@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

commit 2a80c15812372e554474b1dba0b1d8e467af295d upstream.

syzbot found WARNING in qrtr_tun_write_iter [1] when write_iter length
exceeds KMALLOC_MAX_SIZE causing order >= MAX_ORDER condition.

Additionally, there is no check for 0 length write.

[1]
WARNING: mm/page_alloc.c:5011
[..]
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
 call_write_iter include/linux/fs.h:1901 [inline]

Reported-by: syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Link: https://lore.kernel.org/r/20210202092059.1361381-1-snovitoll@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/tun.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -80,6 +80,12 @@ static ssize_t qrtr_tun_write_iter(struc
 	ssize_t ret;
 	void *kbuf;
 
+	if (!len)
+		return -EINVAL;
+
+	if (len > KMALLOC_MAX_SIZE)
+		return -ENOMEM;
+
 	kbuf = kzalloc(len, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;


