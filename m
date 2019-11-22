Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB28107033
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfKVKpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfKVKpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5812620718;
        Fri, 22 Nov 2019 10:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419518;
        bh=wg46qknz9Hf2607OK9IVon7QRzTj/a1p1YRAecuuMHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHvr2G/Y1GRHuRdnWWfQVOFizn8FPgMsPkpnTi0h9dqTl+/0DtLGN7LQgfIbw5iHc
         xk3fi0YhFcvdSvJQB2KDu5ossWFeHppYTIFQ9dCu3I1CEPIctO91Z/j5CFGKIJ1QiY
         F2tlp/drvrj5IHHMwLZ2icD9Cpi7/2/Iiqf/MyTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 139/222] scsi: NCR5380: Handle BUS FREE during reselection
Date:   Fri, 22 Nov 2019 11:27:59 +0100
Message-Id: <20191122100912.901414049@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit ca694afad707cb3ae2fdef3b28454444d9ac726e ]

The X3T9.2 specification (draft) says, under "6.1.4.2 RESELECTION time-out
procedure", that a target may assert RST or go to BUS FREE phase if the
initiator does not respond within 200 us. Something like this has been
observed with AztecMonster II target. When it happens, all we can do is wait
for the target to try again.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 03f9ddbc37fbb..27270631c70c2 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2133,6 +2133,9 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	if (NCR5380_poll_politely(instance,
 	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		if ((NCR5380_read(STATUS_REG) & (SR_BSY | SR_SEL)) == 0)
+			/* BUS FREE phase */
+			return;
 		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
 		do_abort(instance);
 		return;
-- 
2.20.1



