Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371273A62DA
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhFNLFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234567AbhFNLCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A89A61874;
        Mon, 14 Jun 2021 10:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667429;
        bh=2SgvNj6ou6VNa7dm/tdITAyo9EzdsLrOwNOltAcAyho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KV0iNufBwaBxWjI0Qqme874yj+PTzYX0TvSusyXOVbaIrijabfqNNrfV0eKQoyueF
         cLR03EX/wjVn6C++NcBSWYHYRxTzw/Msk9+P0VzaytDGM3BDFpllnlYR34EUifdsn6
         bKObJk1P6NHlhSWLzm5EtZP+ZEE7yTxMTAFhXddI=
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
Subject: [PATCH 5.10 067/131] USB: f_ncm: ncm_bitrate (speed) is unsigned
Date:   Mon, 14 Jun 2021 12:27:08 +0200
Message-Id: <20210614102655.309472492@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
@@ -583,7 +583,7 @@ static void ncm_do_notify(struct f_ncm *
 		data[0] = cpu_to_le32(ncm_bitrate(cdev->gadget));
 		data[1] = data[0];
 
-		DBG(cdev, "notify speed %d\n", ncm_bitrate(cdev->gadget));
+		DBG(cdev, "notify speed %u\n", ncm_bitrate(cdev->gadget));
 		ncm->notify_state = NCM_NOTIFY_CONNECT;
 		break;
 	}


