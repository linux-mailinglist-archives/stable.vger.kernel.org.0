Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F771BCAAA
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbgD1Svh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729218AbgD1ShL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:37:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BCD20B80;
        Tue, 28 Apr 2020 18:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099031;
        bh=aA6z5Im+fckIqDKy07hv31qtqVKsbkx6P9lhSktTShc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fY/tYTIGwKMRVKzVKsa6tAVFwToeUFGVci7Hl+HVDZl8xgT+1OS6GMpoJPmFWkCTR
         4dAdCB/tI4T9Aq+c/O5UxcF+u2euua4uTAib4ANOKE5CnehsR++5Fs24nzHP91PYkn
         0Z3rgixrh5PyRnNOfyJyyIFr3wVuhyOB0xmU4kz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.6 146/167] UAS: no use logging any details in case of ENODEV
Date:   Tue, 28 Apr 2020 20:25:22 +0200
Message-Id: <20200428182244.058058234@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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


