Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D167812F180
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgABWMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbgABWMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A479A21835;
        Thu,  2 Jan 2020 22:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003129;
        bh=XCrMYPSy00dmp+xZlNm315bjWK1ggHduK0R/R0yeLjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpOhECwtmrAqAYHf2VKqPYuTybbKaPPM2is6PxzDmVmvTm11REQk0rvzwvsOHEZf3
         MeQpob31T6bQsSVHe+utKkUvxBwKJmeid/+7owlcXWiBGDnyk2O5avMhWjp28KO/vq
         F24jWrDbZajXkSgOolDQ4CZfCfMqiQrNeZpgFUsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/191] scsi: mpt3sas: Fix clear pending bit in ioctl status
Date:   Thu,  2 Jan 2020 23:04:47 +0100
Message-Id: <20200102215830.407472300@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 782b281883caf70289ba6a186af29441a117d23e ]

When user issues diag register command from application with required size,
and if driver unable to allocate the memory, then it will fail the register
command. While failing the register command, driver is not currently
clearing MPT3_CMD_PENDING bit in ctl_cmds.status variable which was set
before trying to allocate the memory. As this bit is set, subsequent
register command will be failed with BUSY status even when user wants to
register the trace buffer will less memory.

Clear MPT3_CMD_PENDING bit in ctl_cmds.status before returning the diag
register command with no memory status.

Link: https://lore.kernel.org/r/1568379890-18347-4-git-send-email-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 7d696952b376..3c463e8f6074 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1584,7 +1584,8 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 			ioc_err(ioc, "%s: failed allocating memory for diag buffers, requested size(%d)\n",
 				__func__, request_data_sz);
 			mpt3sas_base_free_smid(ioc, smid);
-			return -ENOMEM;
+			rc = -ENOMEM;
+			goto out;
 		}
 		ioc->diag_buffer[buffer_type] = request_data;
 		ioc->diag_buffer_sz[buffer_type] = request_data_sz;
-- 
2.20.1



