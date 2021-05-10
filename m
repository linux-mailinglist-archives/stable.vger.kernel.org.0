Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48CD378765
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbhEJLPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236349AbhEJLHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 654236197C;
        Mon, 10 May 2021 11:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644414;
        bh=MNU0Z9BeWqMxMVxxdYp1eofHi+2PqJ+dmvfvTutR8M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsbC4gB48ZxADE3hxfRBtkzwQsOrdi3ZZ94vGtuAjYhoG9EmA3exkXqf2Jftvj3MM
         t9zhtx0fMaMT4klLjaoBjQgfE5RQfLoecuOZOTvPtI/gQJu5r/bNjxmaM4frL/fOsY
         npy76uvzBPxR9TcNz4Gbhzz3qYfGh+P31zr8I74o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 038/384] scsi: mpt3sas: Only one vSES is present even when IOC has multi vSES
Date:   Mon, 10 May 2021 12:17:07 +0200
Message-Id: <20210510102016.126608770@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 4c51f956965120b3441cdd39c358b87daba13e19 upstream.

Whenever the driver is adding a vSES to virtual-phys list it is
reinitializing the list head. Hence those vSES devices which were added
previously are lost.

Stop reinitializing the list every time a new vSES device is added.

Link: https://lore.kernel.org/r/20210330105004.20413-1-sreekanth.reddy@broadcom.com
Cc: stable@vger.kernel.org #v5.11.10+
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6483,6 +6483,9 @@ _scsih_alloc_vphy(struct MPT3SAS_ADAPTER
 		if (!vphy)
 			return NULL;
 
+		if (!port->vphys_mask)
+			INIT_LIST_HEAD(&port->vphys_list);
+
 		/*
 		 * Enable bit corresponding to HBA phy number on its
 		 * parent hba_port object's vphys_mask field.
@@ -6490,7 +6493,6 @@ _scsih_alloc_vphy(struct MPT3SAS_ADAPTER
 		port->vphys_mask |= (1 << phy_num);
 		vphy->phy_mask |= (1 << phy_num);
 
-		INIT_LIST_HEAD(&port->vphys_list);
 		list_add_tail(&vphy->list, &port->vphys_list);
 
 		ioc_info(ioc,


