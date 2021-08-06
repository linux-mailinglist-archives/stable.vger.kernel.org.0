Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603773E24F6
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243728AbhHFIPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243731AbhHFIPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D17611C6;
        Fri,  6 Aug 2021 08:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237699;
        bh=oPvlV2NsK4f1ssaKBVn25F6huJX4K96v8zrnFjhoR1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDbpZr4uZHWzi482ob5BNwJezj2jvr0JA+yCE15kG8mz7ziEkpTYs4H+PbO2f1T6J
         AGSvu/G3rHfwxVSu3U9NhfqzJz+Gm080OcgMiXUTOJPvbgXsDwB1rS5ykDhdcAARHi
         RwiH069EAHTi137CZS6Mj/KKFMjyFkZ7p5NAHYTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 3/6] r8152: Fix potential PM refcount imbalance
Date:   Fri,  6 Aug 2021 10:14:35 +0200
Message-Id: <20210806081109.047228695@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081108.939164003@linuxfoundation.org>
References: <20210806081108.939164003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9c23aa51477a37f8b56c3c40192248db0663c196 ]

rtl8152_close() takes the refcount via usb_autopm_get_interface() but
it doesn't release when RTL8152_UNPLUG test hits.  This may lead to
the imbalance of PM refcount.  This patch addresses it.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1186194
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5baaa8291624..ebf6d4cf09ea 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3159,9 +3159,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2



