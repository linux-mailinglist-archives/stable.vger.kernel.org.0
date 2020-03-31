Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3E198FA0
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgCaJFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbgCaJFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FC4520787;
        Tue, 31 Mar 2020 09:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645503;
        bh=NeubGs2Kg9duRgrqga3UHI//e9k9vjc8bZ8Y4TZt8vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8evKuMfHDfYTI4vEb+aYjvj8eh/4lV8iZQ6kTq+e3PX89r8RC9aQRrSMPCZXUtIS
         V+JKaZVREoCVlIdC8Fcp7UaRcjZE4Jy+1Y6rUHkiDxhi5RSAAd43+ntURO64QmtdMa
         LSaxmKr8O0WYvcYMUykyIuR82KWX26Wg+PyxbovY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 035/170] slcan: not call free_netdev before rtnl_unlock in slcan_open
Date:   Tue, 31 Mar 2020 10:57:29 +0200
Message-Id: <20200331085427.768203682@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 2091a3d42b4f339eaeed11228e0cbe9d4f92f558 ]

As the description before netdev_run_todo, we cannot call free_netdev
before rtnl_unlock, fix it by reorder the code.

This patch is a 1:1 copy of upstream slip.c commit f596c87005f7
("slip: not call free_netdev before rtnl_unlock in slip_open").

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/slcan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -625,7 +625,10 @@ err_free_chan:
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	slc_free_netdev(sl->dev);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
 	free_netdev(sl->dev);
+	return err;
 
 err_exit:
 	rtnl_unlock();


