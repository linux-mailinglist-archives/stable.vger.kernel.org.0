Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFAF1F460B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgFIRr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732103AbgFIRr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7323520801;
        Tue,  9 Jun 2020 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724846;
        bh=akhqUkT0c9xF/42feGFbgYB1eZCfR8+2RTKObv/fnaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+siqMPWa08kbtMxKgvqkjjBKBIYDfIlFSbSNEMHMivFNrCZDsttJzbtlYJcETXuj
         xLgqtHijMicGy94soIo804RkIK3pZoijTOuRjSmgpBB5DPunjUraXQW3YnTE6UQAgY
         vp7zVs9dBGABzNdsRUOkbuao82lfjvKU8inSxdos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 17/36] slip: not call free_netdev before rtnl_unlock in slip_open
Date:   Tue,  9 Jun 2020 19:44:17 +0200
Message-Id: <20200609173934.264332124@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609173933.288044334@linuxfoundation.org>
References: <20200609173933.288044334@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit f596c87005f7b1baeb7d62d9a9e25d68c3dfae10 upstream.

As the description before netdev_run_todo, we cannot call free_netdev
before rtnl_unlock, fix it by reorder the code.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to <4.11: free_netdev() is called through sl_free_netdev()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slip.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -867,7 +867,10 @@ err_free_chan:
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
 	sl_free_netdev(sl->dev);
+	return err;
 
 err_exit:
 	rtnl_unlock();


