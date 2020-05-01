Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB57B1C158B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgEANaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgEANaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:30:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B781A208D6;
        Fri,  1 May 2020 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339810;
        bh=2C+zaXH0NcVwovhzxCpIT+U1m1TU7namuJZfIR6ant8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDmIlfpybFALJLGUvkP7SNyg3QSA5vtqMT4wWwTIrL62oHEDqhZqupPog75S7JsKJ
         OnMWfSchb4jO/wHmEKuSgtiXfJIL02oiZame6R74hiLHpZUsrAhykM0rbf56d7XmiX
         G8YnAPzbyFMqwZNItpUT81LDg62qaFYENNpzO0Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.9 56/80] UAS: no use logging any details in case of ENODEV
Date:   Fri,  1 May 2020 15:21:50 +0200
Message-Id: <20200501131530.483623421@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 5963dec98dc52d52476390485f07a29c30c6a582 upstream.

Once a device is gone, the internal state does not matter anymore.
There is no need to spam the logs.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 326349f824619 ("uas: add dead request list")
Link: https://lore.kernel.org/r/20200415141750.811-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -191,6 +191,9 @@ static void uas_log_cmd_state(struct scs
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
+	if (status == -ENODEV) /* too late */
+		return;
+
 	scmd_printk(KERN_INFO, cmnd,
 		    "%s %d uas-tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
 		    prefix, status, cmdinfo->uas_tag,


