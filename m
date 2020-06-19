Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201892013E1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403980AbgFSQFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391455AbgFSPJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:09:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7D120776;
        Fri, 19 Jun 2020 15:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579393;
        bh=YP48rbtDsCt7cPYauRcjGLjAc3a4MGalUtGGAlwwvpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMUkfy2Yt5rblpUWmY5+WUKI+m/5GkYNfXeSU6BvfQ57kGLAz3pDrNdme7U2bnnBv
         tb+2dRlWIN9fjVx7WvGIvnlrBVJuwqgW8yJ2oQsQ070Oi+0aKG9qn6tYrt6OxuogaV
         +ocApjDTjnXWOww76mt5Q/dVXWTPgrF4fX6/Ow94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/261] libertas_tf: avoid a null dereference in pointer priv
Date:   Fri, 19 Jun 2020 16:31:42 +0200
Message-Id: <20200619141654.243850050@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 049ceac308b0d57c4f06b9fb957cdf95d315cf0b ]

Currently there is a check if priv is null when calling lbtf_remove_card
but not in a previous call to if_usb_reset_dev that can also dereference
priv.  Fix this by also only calling lbtf_remove_card if priv is null.

It is noteable that there don't seem to be any bugs reported that the
null pointer dereference has ever occurred, so I'm not sure if the null
check is required, but since we're doing a null check anyway it should
be done for both function calls.

Addresses-Coverity: ("Dereference before null check")
Fixes: baa0280f08c7 ("libertas_tf: don't defer firmware loading until start()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200501173900.296658-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index 25ac9db35dbf..bedc09215088 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -247,10 +247,10 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	lbtf_deb_enter(LBTF_DEB_MAIN);
 
-	if_usb_reset_device(priv);
-
-	if (priv)
+	if (priv) {
+		if_usb_reset_device(priv);
 		lbtf_remove_card(priv);
+	}
 
 	/* Unlink and free urb */
 	if_usb_free(cardp);
-- 
2.25.1



