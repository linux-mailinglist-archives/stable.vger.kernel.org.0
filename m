Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94011461E5E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379387AbhK2Sfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:35:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37864 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379580AbhK2Sde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:33:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9D5AB815C3;
        Mon, 29 Nov 2021 18:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E66EC53FC7;
        Mon, 29 Nov 2021 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210614;
        bh=+hPTTfB30qj91NOr8YuX+KHQ6cLv+RewxQLBhmIaVYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SW6mr7apxEhU26kk21sPXR+/2soeNLE2VbHi7tXfJvEMGAtPPMPoNhHfZ1JCNBDR6
         ebRhReRIIyXzOvV65C4toHyKfPZ9ZseRoK7QcoPHw0stVowzNK8ji2u4FjgcU1y0uI
         SSmakMhZmQdSdl5ZFHX+NrcYxpi8d52fOhcw7kew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/121] scsi: mpt3sas: Fix kernel panic during drive powercycle test
Date:   Mon, 29 Nov 2021 19:18:08 +0100
Message-Id: <20211129181713.562270305@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 31c384108bc9c..8418b59b3743b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3675,7 +3675,7 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
 
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data)
+		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
 			continue;
 		if (sas_device_priv_data->sas_target->sas_address
 		    != sas_address)
-- 
2.33.0



