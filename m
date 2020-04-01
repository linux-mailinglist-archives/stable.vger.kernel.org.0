Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB2219B1F9
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388865AbgDAQjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387964AbgDAQjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:39:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A9642063A;
        Wed,  1 Apr 2020 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759185;
        bh=czNnYhZCIR0owLlyGh6iNgbaZ96RDbl26VfpnZQE6OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPV7FIg7m45j/PzaRBB9CtN/x+YYr5tiV+wES6uSQq8D6sqnlCr4TfFYf8O6KITIL
         2rzG6eyfjVWY0ayTWqVDJptQaVXrmemsrfaMXaeMJou1ZjWiB9D072ITzC+b6R2UL2
         AQWVLY9GdK+AZpwxn4ckvWkaB2oEkb0N6TNBE1k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6d2e7f6fa90e27be9d62@syzkaller.appspotmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH 4.9 083/102] staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
Date:   Wed,  1 Apr 2020 18:18:26 +0200
Message-Id: <20200401161546.381443645@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit a1f165a6b738f0c9d744bad4af7a53909278f5fc upstream.

We should cancel hw->usb_work before kfree(hw).

Reported-by: syzbot+6d2e7f6fa90e27be9d62@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1585120006-30042-1-git-send-email-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/prism2usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -179,6 +179,7 @@ static void prism2sta_disconnect_usb(str
 
 		cancel_work_sync(&hw->link_bh);
 		cancel_work_sync(&hw->commsqual_bh);
+		cancel_work_sync(&hw->usb_work);
 
 		/* Now we complete any outstanding commands
 		 * and tell everyone who is waiting for their


