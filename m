Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D3E419B7E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhI0RTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236965AbhI0RRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:17:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48049611C0;
        Mon, 27 Sep 2021 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762728;
        bh=pEDzT+EOb8LS8+AayuELS464mSBgj0Tye446mYQFlec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSt+okwEU6oeZIQh9dqHzJCIvHouqZl5AiXPlvf3wCxyq+rlm3Aj+xt8rwaZp9CNm
         PeGDyQqBsIAENYjNlS0lQGK56/1hxHmqSpHHahZMDo96gNSpr3Su/9ALa8v20IDCq3
         Fe+T+YZn515hPhYK/WmxjRDo0dskbx9YgL+ot9fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 030/162] misc: bcm-vk: fix tty registration race
Date:   Mon, 27 Sep 2021 19:01:16 +0200
Message-Id: <20210927170234.513156293@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit d9d1232b48344c6c72dbdf89fae1e7638e5df757 upstream.

Make sure to set the tty class-device driver data before registering the
tty to avoid having a racing open() dereference a NULL pointer.

Fixes: 91ca10d6fa07 ("misc: bcm-vk: add ttyVK support")
Cc: stable@vger.kernel.org      # 5.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210917115736.5816-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/bcm-vk/bcm_vk_tty.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/misc/bcm-vk/bcm_vk_tty.c
+++ b/drivers/misc/bcm-vk/bcm_vk_tty.c
@@ -267,13 +267,13 @@ int bcm_vk_tty_init(struct bcm_vk *vk, c
 		struct device *tty_dev;
 
 		tty_port_init(&vk->tty[i].port);
-		tty_dev = tty_port_register_device(&vk->tty[i].port, tty_drv,
-						   i, dev);
+		tty_dev = tty_port_register_device_attr(&vk->tty[i].port,
+							tty_drv, i, dev, vk,
+							NULL);
 		if (IS_ERR(tty_dev)) {
 			err = PTR_ERR(tty_dev);
 			goto unwind;
 		}
-		dev_set_drvdata(tty_dev, vk);
 		vk->tty[i].is_opened = false;
 	}
 


