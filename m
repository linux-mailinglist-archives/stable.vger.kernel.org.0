Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DA330C075
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhBBN6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233370AbhBBN4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E099C64F66;
        Tue,  2 Feb 2021 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273513;
        bh=y6ATv8G0zfuUfFNJiOSTF7sPrAFuRP9P5nN4ff341N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZLtCZHQ9fDPrvU4ivH1FYJPOJe8VvlMs8FJUfBk2741Bjlqq+V6X/u6bzdyzsq0+
         SkWXiLRoT5eTPI3ASVXX5kxNHAq2JISdzPBJtyC8Jzyh3XFxPvIH7F98v0b0BhwbKT
         UiuvcmfPoSb79jpizonsYvSvYg058MEsqQYx/iOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 134/142] NFC: fix possible resource leak
Date:   Tue,  2 Feb 2021 14:38:17 +0100
Message-Id: <20210202133003.221795071@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit d8f923c3ab96dbbb4e3c22d1afc1dc1d3b195cd8 upstream.

Put the device to avoid resource leak on path that the polling flag is
invalid.

Fixes: a831b9132065 ("NFC: Do not return EBUSY when stopping a poll that's already stopped")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121153745.122184-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -852,6 +852,7 @@ static int nfc_genl_stop_poll(struct sk_
 
 	if (!dev->polling) {
 		device_unlock(&dev->dev);
+		nfc_put_device(dev);
 		return -EINVAL;
 	}
 


