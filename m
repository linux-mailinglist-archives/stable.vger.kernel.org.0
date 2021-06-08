Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073303A0351
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhFHTPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237784AbhFHTMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:12:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A82C61955;
        Tue,  8 Jun 2021 18:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178176;
        bh=mN88wxoYh1WHwN7vlvO8noDUiwHiDZNE5q8CZaHZWko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzSVIY5LD5kgc3m9/o/XerVVyppziUmuKAJTVr3MkKcfB14Fe/THmbCdA8tLL3lMJ
         2j79X7sKN6zNUWW6mG7XeNcK7yOMbvsVentFb00pwgQ6IoKh9qmoV8t3FdApg4/nKF
         RZl4nt1mrD+kE/WvZUG2J1ktXpHCcorS+abHl5TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com
Subject: [PATCH 5.12 105/161] net: caif: fix memory leak in caif_device_notify
Date:   Tue,  8 Jun 2021 20:27:15 +0200
Message-Id: <20210608175949.021807669@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
@@ -370,6 +370,7 @@ static int caif_device_notify(struct not
 	struct cflayer *layer, *link_support;
 	int head_room = 0;
 	struct caif_device_entry_list *caifdevs;
+	int res;
 
 	cfg = get_cfcnfg(dev_net(dev));
 	caifdevs = caif_device_list(dev_net(dev));
@@ -395,8 +396,10 @@ static int caif_device_notify(struct not
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
 


