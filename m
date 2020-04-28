Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70441BC9AA
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgD1Snu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbgD1Sns (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53CE420730;
        Tue, 28 Apr 2020 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099427;
        bh=aA6z5Im+fckIqDKy07hv31qtqVKsbkx6P9lhSktTShc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad0e4e2gSOfp1gLFzwiwXvHyItMxvXmqzS6ignJOiafIR1LkSDA2AMAJvsSUoPPU3
         kQUQVTbgMecsb8+UU043BrHFDwicYc0jgpAjSdv+oiCXOxOn6T69aGNXkuSa4/Qidg
         Bjr8om+R1pVAdgPEP6LovFbt8n4wLJjbz6FdxHVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 147/168] UAS: no use logging any details in case of ENODEV
Date:   Tue, 28 Apr 2020 20:25:21 +0200
Message-Id: <20200428182250.173811338@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
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
@@ -190,6 +190,9 @@ static void uas_log_cmd_state(struct scs
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
+	if (status == -ENODEV) /* too late */
+		return;
+
 	scmd_printk(KERN_INFO, cmnd,
 		    "%s %d uas-tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
 		    prefix, status, cmdinfo->uas_tag,


