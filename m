Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F395C3E8236
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbhHJSGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238999AbhHJSEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B406161411;
        Tue, 10 Aug 2021 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617709;
        bh=btAsWNFwkIaXSn8TsKrBntDZORAVNEY1cv5+S42XIlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO2IFRF2dMewkyBMAD1jzwVL261jNrI/UT6noJd+4pH4x9WvbkFVI2kEQYgaXQCqM
         lT6ffu0eHEnswM4oWjnjYYCCX+fd6S4LTpvYkym7MdGrTpEhTZaq7dF4lSzXD5TzGY
         YGvA7gBfk2SzSPoqhis6oyOpFDUGADZxtSwOio0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Letu Ren <fantasquex@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 171/175] net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset
Date:   Tue, 10 Aug 2021 19:31:19 +0200
Message-Id: <20210810173006.579743625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
 drivers/net/ethernet/qlogic/qla3xxx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 2376b2729633..c00ad57575ea 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -154,7 +154,7 @@ static int ql_wait_for_drvr_lock(struct ql3_adapter *qdev)
 				      "driver lock acquired\n");
 			return 1;
 		}
-		ssleep(1);
+		mdelay(1000);
 	} while (++i < 10);
 
 	netdev_err(qdev->ndev, "Timed out waiting for driver lock...\n");
@@ -3274,7 +3274,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 		if ((value & ISP_CONTROL_SR) == 0)
 			break;
 
-		ssleep(1);
+		mdelay(1000);
 	} while ((--max_wait_time));
 
 	/*
@@ -3310,7 +3310,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 						   ispControlStatus);
 			if ((value & ISP_CONTROL_FSR) == 0)
 				break;
-			ssleep(1);
+			mdelay(1000);
 		} while ((--max_wait_time));
 	}
 	if (max_wait_time == 0)
-- 
2.30.2



