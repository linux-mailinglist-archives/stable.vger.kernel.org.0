Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D3D10BF3A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfK0UkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729018AbfK0UkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:40:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5FFE215A5;
        Wed, 27 Nov 2019 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887222;
        bh=HOcaq0eTt3sWpujI16INbD4a6Vw/LVwz3TEbLWtPfQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sahs92IXieQxljJ4dld2QNkj4wPWvvQU27ySH6A1l3ZMp9IXKUd7CLiUbPJn2ucLs
         KIPLrwXnk25DgnUOS4yNcaqi1I+vIG0JL6aD5NWj+Hd4GCXCcPUUEQnBRaUW7Mb27F
         I7LsydZCz8XsrpjdiV7TLQuAKcTsFVeHIkAR/uP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 028/151] scsi: ips: fix missing break in switch
Date:   Wed, 27 Nov 2019 21:30:11 +0100
Message-Id: <20191127203018.600601785@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
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



