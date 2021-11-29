Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EAE461DF6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379225AbhK2SbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:04 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49358 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354060AbhK2S3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2EA56CE13D8;
        Mon, 29 Nov 2021 18:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14A7C53FAD;
        Mon, 29 Nov 2021 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210343;
        bh=cR5rsPfjG7G3AhjfCWOlDaniH6LozsZimAzTmumDmiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpfEPQ/oTvkqT6IX/d9rhS06fQboVVSwCxFRote9SYWZJ2Cb2L2QBDo3zw2qXKEee
         myeWd7MAYlHQEck6MbXdw55h6chnQJfJMw47+04K8f2MpulbXgtvMQ0HcJ3ySa409m
         AIyV4VsVHvWCDJBIk7sdtNkZ6IcA43+eMRi/UboU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/92] scsi: mpt3sas: Fix kernel panic during drive powercycle test
Date:   Mon, 29 Nov 2021 19:18:24 +0100
Message-Id: <20211129181709.256205607@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 0ee4ba13e09c9d9c1cb6abb59da8295d9952328b ]

While looping over shost's sdev list it is possible that one
of the drives is getting removed and its sas_target object is
freed but its sdev object remains intact.

Consequently, a kernel panic can occur while the driver is trying to access
the sas_address field of sas_target object without also checking the
sas_target object for NULL.

Link: https://lore.kernel.org/r/20211117104909.2069-1-sreekanth.reddy@broadcom.com
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 3654cfc4376fa..97c1f242ef0a3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3387,7 +3387,7 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
 
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data)
+		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
 			continue;
 		if (sas_device_priv_data->sas_target->sas_address
 		    != sas_address)
-- 
2.33.0



