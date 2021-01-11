Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BB52F1524
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbhAKNN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732013AbhAKNN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E356622AAB;
        Mon, 11 Jan 2021 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370795;
        bh=/pd8RLnDeNu7p+BdZvik1txSdKxNe8f/cfwwP4ayZU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogF+5Ed/ekbGB73CJG0fdit2WXTS4QnaYYosoPrxCcU0CQgHVvCfU/yRzNF3pW/wL
         ArNC7Ph7ejbrJMrKk5Qz4SY8ODEAAN1t1o4NCmbDLg9IBX8fy+Tkw3CCE9gT1G+M9n
         Cz9llMgmfK95cQlmKeCdaQ9OOxha+ga4m3zBlGEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        syzbot+297d20e437b79283bf6d@syzkaller.appspotmail.com,
        Yuyang Du <yuyang.du@intel.com>,
        Shuah Khan <shuahkh@osg.samsung.com>, linux-usb@vger.kernel.org
Subject: [PATCH 5.4 59/92] usb: usbip: vhci_hcd: protect shift size
Date:   Mon, 11 Jan 2021 14:02:03 +0100
Message-Id: <20210111130041.991864965@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 718bf42b119de652ebcc93655a1f33a9c0d04b3c upstream.

Fix shift out-of-bounds in vhci_hcd.c:

  UBSAN: shift-out-of-bounds in ../drivers/usb/usbip/vhci_hcd.c:399:41
  shift exponent 768 is too large for 32-bit type 'int'

Fixes: 03cd00d538a6 ("usbip: vhci-hcd: Set the vhci structure up to work")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+297d20e437b79283bf6d@syzkaller.appspotmail.com
Cc: Yuyang Du <yuyang.du@intel.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201229071309.18418-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/vhci_hcd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -396,6 +396,8 @@ static int vhci_hub_control(struct usb_h
 		default:
 			usbip_dbg_vhci_rh(" ClearPortFeature: default %x\n",
 					  wValue);
+			if (wValue >= 32)
+				goto error;
 			vhci_hcd->port_status[rhport] &= ~(1 << wValue);
 			break;
 		}


