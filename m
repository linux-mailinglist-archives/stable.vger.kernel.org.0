Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D9018814C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgCQLHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbgCQLHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:07:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6DAD2071C;
        Tue, 17 Mar 2020 11:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443257;
        bh=jPyM3qE2/ZKFJSaTlU0gmDV+PKPs99wF1Qnb/KkVCiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OecHsMX7FOMOJv2jmHessTMQycS4sxcZAKgcqkMlOBz85J4k2K21mPHKS3oEHjtT6
         D5OpoZDEbd2HxFBSUVq+9YW9sfyuHB/hLDkG0B5VRYDmON07Y6eTBA9yAdCybw2lpO
         W6am8Nu/Bvfs5AnIi4kVmYiec+mYsy27BFFMrrr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 026/151] net/smc: cancel event worker during device removal
Date:   Tue, 17 Mar 2020 11:53:56 +0100
Message-Id: <20200317103328.588704431@linuxfoundation.org>
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

[ Upstream commit ece0d7bd74615773268475b6b64d6f1ebbd4b4c6 ]

During IB device removal, cancel the event worker before the device
structure is freed.

Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
Reported-by: syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_ib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -580,6 +580,7 @@ static void smc_ib_remove_dev(struct ib_
 	smc_smcr_terminate_all(smcibdev);
 	smc_ib_cleanup_per_ibdev(smcibdev);
 	ib_unregister_event_handler(&smcibdev->event_handler);
+	cancel_work_sync(&smcibdev->port_event_work);
 	kfree(smcibdev);
 }
 


