Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAF73A605D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhFNKdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhFNKdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3FE1611C0;
        Mon, 14 Jun 2021 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666661;
        bh=QicEfaGcnhgcw1s1f4/5sec06a1yZXj2Cgd+966taq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Srgxjierj8KLMKZKbZ0oXwdAzneZnMSgbZg0/JXxnutQXoCpdUp+9hxnVSAjXQYBt
         7LDi9ufM17O9H7RyQ4S0up+uyMYE83G5PkGUVqmtFUCU1bYqXLNu+J/pRFpqC8d0f4
         SJcWclcAZyn4EhbeD1FXmViv+peUzmkR/oRQ1DOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brooke Basile <brookebasile@gmail.com>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Yauheni Kaliuta <yauheni.kaliuta@nokia.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 4.9 25/42] USB: f_ncm: ncm_bitrate (speed) is unsigned
Date:   Mon, 14 Jun 2021 12:27:16 +0200
Message-Id: <20210614102643.510117396@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

commit 3370139745853f7826895293e8ac3aec1430508e upstream.

[  190.544755] configfs-gadget gadget: notify speed -44967296

This is because 4250000000 - 2**32 is -44967296.

Fixes: 9f6ce4240a2b ("usb: gadget: f_ncm.c added")
Cc: Brooke Basile <brookebasile@gmail.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Yauheni Kaliuta <yauheni.kaliuta@nokia.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>
Acked-By: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210608005344.3762668-1-zenczykowski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -588,7 +588,7 @@ static void ncm_do_notify(struct f_ncm *
 		data[0] = cpu_to_le32(ncm_bitrate(cdev->gadget));
 		data[1] = data[0];
 
-		DBG(cdev, "notify speed %d\n", ncm_bitrate(cdev->gadget));
+		DBG(cdev, "notify speed %u\n", ncm_bitrate(cdev->gadget));
 		ncm->notify_state = NCM_NOTIFY_CONNECT;
 		break;
 	}


