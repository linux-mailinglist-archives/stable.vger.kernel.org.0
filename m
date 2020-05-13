Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB8D1D0D57
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbgEMJwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387762AbgEMJwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 193F3206D6;
        Wed, 13 May 2020 09:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363533;
        bh=bkmkk4bP/D3Sq7OZCDTSZpVQIw/X4y2O9aX1jXh4CDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6Eq7gy1yYINPeOLhGCReiMZKFDqtl1YB8FOnr4+77J4xnTGwowCaeIVt3/dtW1ET
         t2/5P9qXA9zQobxACbq/pvKGV6O41SDz1UOi8evYoo2ep3mXzXQ7ohYAu69Qt9aGxl
         Nt8FcjLDmEjQpCZypMLEm67r3y4I8jC5E5DyfoFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Pais <allen.pais@oracle.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 022/118] net: dsa: Do not leave DSA master with NULL netdev_ops
Date:   Wed, 13 May 2020 11:44:01 +0200
Message-Id: <20200513094419.651633965@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 050569fc8384c8056bacefcc246bcb2dfe574936 ]

When ndo_get_phys_port_name() for the CPU port was added we introduced
an early check for when the DSA master network device in
dsa_master_ndo_setup() already implements ndo_get_phys_port_name(). When
we perform the teardown operation in dsa_master_ndo_teardown() we would
not be checking that cpu_dp->orig_ndo_ops was successfully allocated and
non-NULL initialized.

With network device drivers such as virtio_net, this leads to a NPD as
soon as the DSA switch hanging off of it gets torn down because we are
now assigning the virtio_net device's netdev_ops a NULL pointer.

Fixes: da7b9e9b00d4 ("net: dsa: Add ndo_get_phys_port_name() for CPU port")
Reported-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/master.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -289,7 +289,8 @@ static void dsa_master_ndo_teardown(stru
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 
-	dev->netdev_ops = cpu_dp->orig_ndo_ops;
+	if (cpu_dp->orig_ndo_ops)
+		dev->netdev_ops = cpu_dp->orig_ndo_ops;
 	cpu_dp->orig_ndo_ops = NULL;
 }
 


