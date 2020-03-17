Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647051880F5
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgCQLOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgCQLOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:14:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D50820663;
        Tue, 17 Mar 2020 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443639;
        bh=FeeCtJYHWjRxHTGLQxSNDsMnhcPlVxM8eF3G5iJk+Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzhcDRNaxU66RONAp7i8vX0Kd+guiApPCi/wBOFAeFIiSE49ptnr+LbluhhtJXRwg
         Heip79mCoBhM9Al7mMXRbgnOHTQ7xRsgIXf5yL8J0v7KOYiLLjtjvrK9vCxZCiaov5
         wuXd4/7zY9TDyXDZtKq0w+J+pd9NAg/K0b8aR5uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+84484ccebdd4e5451d91@syzkaller.appspotmail.com,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 151/151] net/smc: check for valid ib_client_data
Date:   Tue, 17 Mar 2020 11:56:01 +0100
Message-Id: <20200317103337.434858198@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

commit a2f2ef4a54c0d97aa6a8386f4ff23f36ebb488cf upstream.

In smc_ib_remove_dev() check if the provided ib device was actually
initialized for SMC before.

Reported-by: syzbot+84484ccebdd4e5451d91@syzkaller.appspotmail.com
Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/smc/smc_ib.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -573,6 +573,8 @@ static void smc_ib_remove_dev(struct ib_
 	struct smc_ib_device *smcibdev;
 
 	smcibdev = ib_get_client_data(ibdev, &smc_ib_client);
+	if (!smcibdev || smcibdev->ibdev != ibdev)
+		return;
 	ib_set_client_data(ibdev, &smc_ib_client, NULL);
 	spin_lock(&smc_ib_devices.lock);
 	list_del_init(&smcibdev->list); /* remove from smc_ib_devices */


