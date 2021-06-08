Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583B139FF75
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhFHSd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhFHSc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B0B0613AE;
        Tue,  8 Jun 2021 18:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177035;
        bh=3HOKnaVi71YUI+jEO9hylFIiLEbQbbKztLrOt1LrGG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3jSw4uUQYjVQXwZRHHvFIv5CTV13AYmBlIvU14FSFiP1rIyInDlwUaUjeQ0ueB44
         64SbUJb8vfeYCOL0g0o8lR2pVfSsdTbXBi7oIQHKGIgVyDM2iTTIUpoAEPWn2NbhCU
         /8ymxhBcrSzKUUHPKZon5iv5tCtusojo4fazBAKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com
Subject: [PATCH 4.9 17/29] net: caif: fix memory leak in caif_device_notify
Date:   Tue,  8 Jun 2021 20:27:11 +0200
Message-Id: <20210608175928.382528927@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit b53558a950a89824938e9811eddfc8efcd94e1bb upstream.

In case of caif_enroll_dev() fail, allocated
link_support won't be assigned to the corresponding
structure. So simply free allocated pointer in case
of error

Fixes: 7c18d2205ea7 ("caif: Restructure how link caif link layer enroll")
Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/caif/caif_dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -366,6 +366,7 @@ static int caif_device_notify(struct not
 	struct cflayer *layer, *link_support;
 	int head_room = 0;
 	struct caif_device_entry_list *caifdevs;
+	int res;
 
 	cfg = get_cfcnfg(dev_net(dev));
 	caifdevs = caif_device_list(dev_net(dev));
@@ -391,8 +392,10 @@ static int caif_device_notify(struct not
 				break;
 			}
 		}
-		caif_enroll_dev(dev, caifdev, link_support, head_room,
+		res = caif_enroll_dev(dev, caifdev, link_support, head_room,
 				&layer, NULL);
+		if (res)
+			cfserl_release(link_support);
 		caifdev->flowctrl = dev_flowctrl;
 		break;
 


