Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C421B7457
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgDXMZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbgDXMZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:25:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7DB21707;
        Fri, 24 Apr 2020 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731107;
        bh=oN4xXc//JXVyLYe37q429CpdJ1zd5XafytMl0uRgsEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZCojek3xu49ET4CkKm1LfEzUj1S41hoOMXPpl338Bj19i4pusAQ57oXt5qoA4Z8u
         h6GqSlwqDntd/XjjYc8frkbmUO1tYhxmguW8rbmg5kbb91cTYtGlVaQUlW54R/Olwt
         VzMr1eOpJkmhu5KzCYCI3ZdlF3KQtVtHlRrNQoCE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <mchristi@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/8] scsi: target: fix PR IN / READ FULL STATUS for FC
Date:   Fri, 24 Apr 2020 08:24:58 -0400
Message-Id: <20200424122503.11046-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122503.11046-1-sashal@kernel.org>
References: <20200424122503.11046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

