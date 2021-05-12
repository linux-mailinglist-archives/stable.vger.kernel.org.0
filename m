Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF037CCD4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbhELQsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243632AbhELQlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FF5161E50;
        Wed, 12 May 2021 16:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835528;
        bh=MQADYLZj+YBnT+1AdNqgk9CDQ1A79OUfTtfPthMRutM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGRcoIbY3lV1DbhLGG+kOt0xbhkc2WWVL3rwXdpat/pEH4Z4LvvAFK0AkJCn6RITq
         YGk8Wfe7X0HXMMMKaiCxeKvBw1Hgk+W27k0VXbVokaPhjGiWiasMWmKClx+zYFuu5N
         Ol4Wg8rWwMNs1KFrG2uHnllg597+IcYyHjfxjq64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 373/677] scsi: qla2xxx: Check kzalloc() return value
Date:   Wed, 12 May 2021 16:46:59 +0200
Message-Id: <20210512144849.719291602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e5406d8ad4a1659f4d4d1b39fe203855c4eaef2d ]

Instead of crashing if kzalloc() fails, make qla2x00_get_host_stats()
return -ENOMEM.

Link: https://lore.kernel.org/r/20210320232359.941-8-bvanassche@acm.org
Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port")
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Lee Duncan <lduncan@suse.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index d021e51344f5..aef2f7cc89d3 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2584,6 +2584,10 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
 	}
 
 	data = kzalloc(response_len, GFP_KERNEL);
+	if (!data) {
+		kfree(req_data);
+		return -ENOMEM;
+	}
 
 	ret = qla2xxx_get_ini_stats(fc_bsg_to_shost(bsg_job), req_data->stat_type,
 				    data, response_len);
-- 
2.30.2



