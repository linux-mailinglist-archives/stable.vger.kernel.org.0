Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B5938A816
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbhETKqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhETKoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AA5661C9F;
        Thu, 20 May 2021 09:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504628;
        bh=IR59B1/Wcfn5Ssfa6oOZhUSeq5lF1vIKGuJmgzsVMPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5+HukCUfLuvCTgeS6iioubJv25J62XHdd6qe8iRtbHYz68B21N6uSkYj4G9ls10U
         nuKLggQ+lyGq2+XUf7nyhwQXClABx4i519Zf2Qai/cEQDKdjOzn8JvUehClwMAhftg
         hM94FdT3lXF8vHvadaHHfBgLkI73ukozACJEruoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 001/240] net: usb: ax88179_178a: initialize local variables before use
Date:   Thu, 20 May 2021 11:19:53 +0200
Message-Id: <20210520092108.638457281@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

commit bd78980be1a68d14524c51c4b4170782fada622b upstream.

Use memset to initialize local array in drivers/net/usb/ax88179_178a.c, and
also set a local u16 and u32 variable to 0. Fixes a KMSAN found uninit-value bug
reported by syzbot at:
https://syzkaller.appspot.com/bug?id=00371c73c72f72487c1d0bfe0cc9d00de339d5aa

Reported-by: syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -307,12 +307,12 @@ static int ax88179_read_cmd(struct usbne
 	int ret;
 
 	if (2 == size) {
-		u16 buf;
+		u16 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
-		u32 buf;
+		u32 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;


