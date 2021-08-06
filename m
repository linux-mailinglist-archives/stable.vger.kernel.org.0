Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F7F3E2558
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhHFITo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244057AbhHFIS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A426120A;
        Fri,  6 Aug 2021 08:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237892;
        bh=IOb5L09PKj7J3uOQVbZ+w3JTUbB0AwULpZmvMN+jWv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fESjrLsB2YBCutAykmJJsiBph8vyEe1GCBLUnp6LCKPQEUM06mxmY/h8fCgyKid97
         MBO+SL2rapv7wyq4U1wAF4KS2wP9WIUWJ5ZmnAHmVxHd3Z/EMWt/zbsoZeLtIPig7b
         PQ5rR94KfNyeKfA1devxCxKCz8vJOT/cMGny8ErY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/23] r8152: Fix potential PM refcount imbalance
Date:   Fri,  6 Aug 2021 10:16:40 +0200
Message-Id: <20210806081112.405995437@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
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
index 24d124633037..873f288e7cec 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4317,9 +4317,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2



