Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005762900C0
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405524AbgJPJIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394896AbgJPJHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:07:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29DA120848;
        Fri, 16 Oct 2020 09:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839255;
        bh=KcIEWczBuJ5XVoDH/sdmyOJrrZnoRvSFRt8CRA3yxyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHwSoE93sWCE05g1YPAwdQFiuq+Ri1QQQ9b4yi5avCi/h4ykd7i6Vv8vX8iYo2SQd
         5pctjbmaCpGae9hmCNsEwlFmNiNAuhPm1o9HrSzD3iODHL3mb7116Ors1GCbNXQ/pC
         GM1LnGETw1sHgUPZem2h1gbHesyujCCfpEgI+Eng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [PATCH 4.9 11/16] staging: comedi: check validity of wMaxPacketSize of usb endpoints found
Date:   Fri, 16 Oct 2020 11:07:15 +0200
Message-Id: <20201016090437.776010612@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.205626543@linuxfoundation.org>
References: <20201016090437.205626543@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit e1f13c879a7c21bd207dc6242455e8e3a1e88b40 upstream.

While finding usb endpoints in vmk80xx_find_usb_endpoints(), check if
wMaxPacketSize = 0 for the endpoints found.

Some devices have isochronous endpoints that have wMaxPacketSize = 0
(as required by the USB-2 spec).
However, since this doesn't apply here, wMaxPacketSize = 0 can be
considered to be invalid.

Reported-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
Tested-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201010082933.5417-1-anant.thazhemadam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/vmk80xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -676,6 +676,9 @@ static int vmk80xx_find_usb_endpoints(st
 	if (!devpriv->ep_rx || !devpriv->ep_tx)
 		return -ENODEV;
 
+	if (!usb_endpoint_maxp(devpriv->ep_rx) || !usb_endpoint_maxp(devpriv->ep_tx))
+		return -EINVAL;
+
 	return 0;
 }
 


