Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7B414CDA
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfEFOo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbfEFOoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:44:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A944B20C01;
        Mon,  6 May 2019 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153894;
        bh=0sCxsk4ZhCr/cOB8EqI0wCflLdcv00pT061/03t1zBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDOlpuXkZgEfWBtR+YWZzcMCLX9C3175dUlwFVjyShZMfK8XbYU0BZZtBMRmis6my
         gK9vLTqgsFG3MM5FEJ2qUSh+zVK/BzvrgLlpPwhW7nbI35d7K+q9XIgfenbjs3wDGJ
         32sk8WtxLH59MXSjdyk9rLixaRhnoh/1xM8kgfL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/75] bonding: show full hw address in sysfs for slave entries
Date:   Mon,  6 May 2019 16:32:43 +0200
Message-Id: <20190506143056.396926948@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 18bebc6dd3281955240062655a4df35eef2c46b3 ]

Bond expects ethernet hwaddr for its slave, but it can be longer than 6
bytes - infiniband interface for example.

 # cat /sys/devices/<skipped>/net/ib0/address
 80:00:02:08:fe:80:00:00:00:00:00:00:7c:fe:90:03:00:be:5d:e1

 # cat /sys/devices/<skipped>/net/ib0/bonding_slave/perm_hwaddr
 80:00:02:08:fe:80

So print full hwaddr in sysfs "bonding_slave/perm_hwaddr" as well.

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_sysfs_slave.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 7d16c51e6913..641a532b67cb 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -55,7 +55,9 @@ static SLAVE_ATTR_RO(link_failure_count);
 
 static ssize_t perm_hwaddr_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%pM\n", slave->perm_hwaddr);
+	return sprintf(buf, "%*phC\n",
+		       slave->dev->addr_len,
+		       slave->perm_hwaddr);
 }
 static SLAVE_ATTR_RO(perm_hwaddr);
 
-- 
2.20.1



