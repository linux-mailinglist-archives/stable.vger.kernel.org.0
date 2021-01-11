Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1712F13E7
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbhAKNQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732417AbhAKNQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A078722515;
        Mon, 11 Jan 2021 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370951;
        bh=ZaV/Ja8sH5DD2IwrWhZrgope+BzFtJZ0ir6j4ghf5vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbUBgmOVlC9+ikbFgdTaMThkO9G/CTW1FWDlxO8YT3s0Ao3O6C/5MzWL7/qbbtLkR
         0J6GfGrxBnpJ6QJZSFGjHWdGuJoorGtRbnHWVuaLer4e1Y5NGEJz4JuPyw4ilF7igv
         5go32uFwU32gdl2PXEZaugstImu3DgrWW0FPmzbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 076/145] Staging: comedi: Return -EFAULT if copy_to_user() fails
Date:   Mon, 11 Jan 2021 14:01:40 +0100
Message-Id: <20210111130052.181337282@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit cab36da4bf1a35739b091b73714a39a1bbd02b05 upstream.

Return -EFAULT on error instead of the number of bytes remaining to be
copied.

Fixes: bac42fb21259 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_CMD{,TEST} compat")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/X8c3pfwFy2jpy4BP@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2987,7 +2987,9 @@ static int put_compat_cmd(struct comedi3
 	v32.chanlist_len = cmd->chanlist_len;
 	v32.data = ptr_to_compat(cmd->data);
 	v32.data_len = cmd->data_len;
-	return copy_to_user(cmd32, &v32, sizeof(v32));
+	if (copy_to_user(cmd32, &v32, sizeof(v32)))
+		return -EFAULT;
+	return 0;
 }
 
 /* Handle 32-bit COMEDI_CMD ioctl. */


