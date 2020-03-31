Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCED199155
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgCaJTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732186AbgCaJTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:19:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F7F208E0;
        Tue, 31 Mar 2020 09:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646344;
        bh=QQ6ebnUvoHQNHZ6qn9BQCIRm9XiS9wC5bt9itZPaTN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9BBP9AYAlNrcGWjIm3IZCmf2OARjCZHnz5iLjpE5xGJijAM62pnO26QIPkDwCv2o
         +XXb22UjXW01kCk9X4wLVbz0gPQ9zVoh6tVte42sy0aDiRxw3SHTd+HH/Lu6t0Pa0e
         a4Cpimf5ts3YIrNOL3qP/sv6dG7dhJuB7+ZCD8II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6d2e7f6fa90e27be9d62@syzkaller.appspotmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH 5.4 147/155] staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
Date:   Tue, 31 Mar 2020 10:59:47 +0200
Message-Id: <20200331085434.592717738@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
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
@@ -180,6 +180,7 @@ static void prism2sta_disconnect_usb(str
 
 		cancel_work_sync(&hw->link_bh);
 		cancel_work_sync(&hw->commsqual_bh);
+		cancel_work_sync(&hw->usb_work);
 
 		/* Now we complete any outstanding commands
 		 * and tell everyone who is waiting for their


