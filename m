Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924B13E24FB
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhHFIPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243832AbhHFIP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 996CD611CC;
        Fri,  6 Aug 2021 08:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237711;
        bh=RYv/LVHPl7XhcSxojrBThWSp24asBCQfMCmUPKws9QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v19I9xYjtxRiqimkQr/vl33tZ2dkBuNpT+v/Fa7quO8oeEjgJFC5cCYDRb91hEzu7
         drByuYAS9Cru+Fd3bwED2AnMEqTAZp/VJC2cNFW3MHF4gox03IP2QaHlAuvFSAxyGE
         whSzBEMJ0kc0UEX8GSAgri1LSYXqQdIJ8NornJSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 3/7] r8152: Fix potential PM refcount imbalance
Date:   Fri,  6 Aug 2021 10:14:42 +0200
Message-Id: <20210806081109.431771827@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081109.324409899@linuxfoundation.org>
References: <20210806081109.324409899@linuxfoundation.org>
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
index 64fdea332886..96f6edcb0062 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3347,9 +3347,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2



