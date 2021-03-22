Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7297C344163
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCVMdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhCVMcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B936C619A0;
        Mon, 22 Mar 2021 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416338;
        bh=v604UhnfAOcV6/lLI85/Rvp8vQDeW4X5WTHjoJMBMCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hW6NeepUnu1FuZHCmTPC3v0uZRTt3+RnHzgyRla4OxOs1x0jNZgun/9crHC2+cBkJ
         IctciCM1h8zk9Oxd/oMB6frIiId5A7LLe7YqYokd531DaGcW8S6yYZUGwTMcPFJ8Zs
         ri/ZV/erVcmOthym3Zdg7qSWE372XInJ3ccMsk/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.11 067/120] scsi: mpt3sas: Do not use GFP_KERNEL in atomic context
Date:   Mon, 22 Mar 2021 13:27:30 +0100
Message-Id: <20210322121931.909896134@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit a50bd64616907ed126ffbdbaa06c5ce708c4a404 upstream.

mpt3sas_get_port_by_id() can be called when a spinlock is held. Use
GFP_ATOMIC instead of GFP_KERNEL when allocating memory.

Issue spotted by call_kern.cocci:
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 7125 inside lock on line 7123 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 6842 inside lock on line 6839 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 6854 inside lock on line 6851 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 7706 inside lock on line 7702 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 10260 inside lock on line 10256 but uses GFP_KERNEL

Link: https://lore.kernel.org/r/20210220093951.905362-1-christophe.jaillet@wanadoo.fr
Fixes: 324c122fc0a4 ("scsi: mpt3sas: Add module parameter multipath_on_hba")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -407,7 +407,7 @@ mpt3sas_get_port_by_id(struct MPT3SAS_AD
 	 * And add this object to port_table_list.
 	 */
 	if (!ioc->multipath_on_hba) {
-		port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
+		port = kzalloc(sizeof(struct hba_port), GFP_ATOMIC);
 		if (!port)
 			return NULL;
 


