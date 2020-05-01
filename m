Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FBF1C1324
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgEAN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbgEAN12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 274D12166E;
        Fri,  1 May 2020 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339647;
        bh=oN4xXc//JXVyLYe37q429CpdJ1zd5XafytMl0uRgsEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvDDWkxd04b0EJiZF+jj6OEI0VW0o1ca6ppnrBtKmHsPIjfQ8jAu4KiogmjlGClIU
         ytPo1r2mtYYc1FQ1v9FiSFaET9nbNfhu3s8hOuUKkF9yVWkNKyCMFNgDULXKRxWYV/
         vpBmHPGiuIg4oVnaqZhuTbwScy5KLZcbFr/4h714=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <mchristi@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 62/70] scsi: target: fix PR IN / READ FULL STATUS for FC
Date:   Fri,  1 May 2020 15:21:50 +0200
Message-Id: <20200501131531.563955312@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 8fed04eb79a74cbf471dfaa755900a51b37273ab ]

Creation of the response to READ FULL STATUS fails for FC based
reservations. Reason is the too high loop limit (< 24) in
fc_get_pr_transport_id(). The string representation of FC WWPN is 23 chars
long only ("11:22:33:44:55:66:77:88"). So when i is 23, the loop body is
executed a last time for the ending '\0' of the string and thus hex2bin()
reports an error.

Link: https://lore.kernel.org/r/20200408132610.14623-3-bstroesser@ts.fujitsu.com
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6e75095af6818..2ecb2f7042a13 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -75,7 +75,7 @@ static int fc_get_pr_transport_id(
 	 * encoded TransportID.
 	 */
 	ptr = &se_nacl->initiatorname[0];
-	for (i = 0; i < 24; ) {
+	for (i = 0; i < 23; ) {
 		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
 			continue;
-- 
2.20.1



