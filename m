Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E1E395CF2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhEaNkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231560AbhEaNh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2354D6145E;
        Mon, 31 May 2021 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467576;
        bh=PCg0zHwCKIdVTKf5I8vRIK0jC9BXhIWMSDVCnQXMyWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLtOa76N9fUFi0yRnljBBh9y9MAAI8yGlADTERo75zrffRoJKs43B6wQDC10ast9C
         n6sIC03cZt4B6T55zN7hx2AHDIt1+U6JaD/eGTrolwFvdtIGhwLoYIK16cIDzQpFxs
         USzQNAHo3HmFZ6mCkfjqU77fscFuRxUzlYfC0THg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/116] scsi: libsas: Use _safe() loop in sas_resume_port()
Date:   Mon, 31 May 2021 15:14:44 +0200
Message-Id: <20210531130643.781611211@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8c7e7b8486cda21269d393245883c5e4737d5ee7 ]

If sas_notify_lldd_dev_found() fails then this code calls:

	sas_unregister_dev(port, dev);

which removes "dev", our list iterator, from the list.  This could lead to
an endless loop.  We need to use list_for_each_entry_safe().

Link: https://lore.kernel.org/r/YKUeq6gwfGcvvhty@mwanda
Fixes: 303694eeee5e ("[SCSI] libsas: suspend / resume support")
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index fad23dd39114..1a0b2ce398f7 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -41,7 +41,7 @@ static bool phy_is_wideport_member(struct asd_sas_port *port, struct asd_sas_phy
 
 static void sas_resume_port(struct asd_sas_phy *phy)
 {
-	struct domain_device *dev;
+	struct domain_device *dev, *n;
 	struct asd_sas_port *port = phy->port;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_internal *si = to_sas_internal(sas_ha->core.shost->transportt);
@@ -60,7 +60,7 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 	 * 1/ presume every device came back
 	 * 2/ force the next revalidation to check all expander phys
 	 */
-	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
 		int i, rc;
 
 		rc = sas_notify_lldd_dev_found(dev);
-- 
2.30.2



