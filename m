Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2289A3EB81A
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbhHMPLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241738AbhHMPKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7982F61131;
        Fri, 13 Aug 2021 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867412;
        bh=0HwXxBgV4lUjdQgqjR5GL8H3n+p5DveIEMlAlZRdATc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEIk69dxinuChl+hmmZ4NPv/I7VH8lLpOYfhJScJ4lSwRRI4NWYlhrZV6WUWXlreV
         WI5bsyx7jh3kBC33VMNgdBcZaWMc9CJWXyMQW30llihaupALILQX1ZB4+3EuSVjUk4
         dtnCDp1a9e6Yia+EAGkahoyaaoYYqiWIpCe9Sn2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Letu Ren <fantasquex@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/30] net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset
Date:   Fri, 13 Aug 2021 17:06:54 +0200
Message-Id: <20210813150523.293477392@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Letu Ren <fantasquex@gmail.com>

[ Upstream commit 92766c4628ea349c8ddab0cd7bd0488f36e5c4ce ]

When calling the 'ql_wait_for_drvr_lock' and 'ql_adapter_reset', the driver
has already acquired the spin lock, so the driver should not call 'ssleep'
in atomic context.

This bug can be fixed by using 'mdelay' instead of 'ssleep'.

Reported-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -155,7 +155,7 @@ static int ql_wait_for_drvr_lock(struct
 				      "driver lock acquired\n");
 			return 1;
 		}
-		ssleep(1);
+		mdelay(1000);
 	} while (++i < 10);
 
 	netdev_err(qdev->ndev, "Timed out waiting for driver lock...\n");
@@ -3287,7 +3287,7 @@ static int ql_adapter_reset(struct ql3_a
 		if ((value & ISP_CONTROL_SR) == 0)
 			break;
 
-		ssleep(1);
+		mdelay(1000);
 	} while ((--max_wait_time));
 
 	/*
@@ -3323,7 +3323,7 @@ static int ql_adapter_reset(struct ql3_a
 						   ispControlStatus);
 			if ((value & ISP_CONTROL_FSR) == 0)
 				break;
-			ssleep(1);
+			mdelay(1000);
 		} while ((--max_wait_time));
 	}
 	if (max_wait_time == 0)


