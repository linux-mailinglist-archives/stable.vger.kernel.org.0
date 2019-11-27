Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314E010B78B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfK0Uey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbfK0Uex (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC7420866;
        Wed, 27 Nov 2019 20:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886892;
        bh=HOcaq0eTt3sWpujI16INbD4a6Vw/LVwz3TEbLWtPfQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpqp3ihttFVGSDXodGl8xiR8y3GvCo6prUNlJxu3OIYEYfYqcAO2UnvijLjE/1PHE
         682NFHIB7WKjSbzin0THahxOj+Ao7eIqcKQiQlvS2L6LcqSZYc2ImDZGoImglLpUYv
         TiZ7SiK6SKuU2PzI7Ua2VxFqblwLIy8Uh7I0IcCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 034/132] scsi: ips: fix missing break in switch
Date:   Wed, 27 Nov 2019 21:30:25 +0100
Message-Id: <20191127202929.463223722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit 5d25ff7a544889bc4b749fda31778d6a18dddbcb ]

Add missing break statement in order to prevent the code from falling
through to case TEST_UNIT_READY.

Addresses-Coverity-ID: 1357338 ("Missing break in switch")
Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 02cb76fd44208..6bbf2945a3e00 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3500,6 +3500,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 
 		case START_STOP:
 			scb->scsi_cmd->result = DID_OK << 16;
+			break;
 
 		case TEST_UNIT_READY:
 		case INQUIRY:
-- 
2.20.1



