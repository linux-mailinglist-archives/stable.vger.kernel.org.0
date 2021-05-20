Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07DE38A589
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhETKR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236475AbhETKPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 678B661996;
        Thu, 20 May 2021 09:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503936;
        bh=IR59B1/Wcfn5Ssfa6oOZhUSeq5lF1vIKGuJmgzsVMPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUmti35Dt+3gpKgPQLWEw9BdsV4OgpChhAB7b5aQNxu+mQVoBnwLp7gpgo53oo2p5
         zk31UXGS/Yh3lBBd1O2UtbR3cdj6PAE+mDD7yV1cmwd17DuP3p7a6dm60Xadvrh1U6
         7i7RtZliFPjR3pt6PXBGz7fQPMzxBksEFlQT33j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 006/323] net: usb: ax88179_178a: initialize local variables before use
Date:   Thu, 20 May 2021 11:18:18 +0200
Message-Id: <20210520092120.341992403@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
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


