Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECF43CA783
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhGOSzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240937AbhGOSxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0E2610C7;
        Thu, 15 Jul 2021 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375046;
        bh=13i/jDwstlzIXZoKdzAWI7iJFWxfrnmMBNrXWjWbsKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngSruuAr89oouM7VbVLo0goCNbnB7tz5k4q9ys91/7GIy7S29bmT5riRgAuk5ptfm
         sbMy1C3y/vBqy84xLINjs7QwweIhSGf4s5U157BRpZ8vCl7fZzTUi8HgeBIECN9BeW
         3EOAldR02K90KdI5LI4rE7/MrE5WpHYAMs5USLVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.10 135/215] ath11k: unlock on error path in ath11k_mac_op_add_interface()
Date:   Thu, 15 Jul 2021 20:38:27 +0200
Message-Id: <20210715182623.431835974@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 59ec8e2fa5aaed6afd18d5362dc131aab92406e7 upstream.

These error paths need to drop the &ar->conf_mutex before returning.

Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/X85sVGVP/0XvlrEJ@mwanda
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath11k/mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4603,13 +4603,13 @@ err_peer_del:
 		if (ret) {
 			ath11k_warn(ar->ab, "failed to delete peer vdev_id %d addr %pM\n",
 				    arvif->vdev_id, vif->addr);
-			return ret;
+			goto err;
 		}
 
 		ret = ath11k_wait_for_peer_delete_done(ar, arvif->vdev_id,
 						       vif->addr);
 		if (ret)
-			return ret;
+			goto err;
 
 		ar->num_peers--;
 	}


