Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F6618B588
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgCSNT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729883AbgCSNT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:19:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C27CA206D7;
        Thu, 19 Mar 2020 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623967;
        bh=GcU1V1irnlHb0FoLOQTl4tLyKbgG4+amY4C1QXTp9nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnJD4zlrjN45Ca66CuAnERWU9qKXJy3wSd//zUaHgdwzZiOseanWBfz/h6Xah0O05
         VI4MEiA8IlN7DvJn86wM5tPCTHuR2KKKbHAyJRClGf/2KW83wMWYbvIjZniP76maPF
         vjMT277ZG7Xa1QthYW4KgUmWxq3rBU/vEts8lwLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Igor Druzhinin <igor.druzhinin@citrix.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/48] scsi: libfc: free response frame from GPN_ID
Date:   Thu, 19 Mar 2020 14:03:56 +0100
Message-Id: <20200319123907.523172825@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Druzhinin <igor.druzhinin@citrix.com>

[ Upstream commit ff6993bb79b9f99bdac0b5378169052931b65432 ]

fc_disc_gpn_id_resp() should be the last function using it so free it here
to avoid memory leak.

Link: https://lore.kernel.org/r/1579013000-14570-2-git-send-email-igor.druzhinin@citrix.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Igor Druzhinin <igor.druzhinin@citrix.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_disc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index f969a71348ef1..8839f509b19ab 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -640,6 +640,8 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
+	if (!IS_ERR(fp))
+		fc_frame_free(fp);
 }
 
 /**
-- 
2.20.1



