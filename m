Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EE5283A4E
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgJEPdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgJEPdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E2320637;
        Mon,  5 Oct 2020 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911996;
        bh=otmGQo9aR4iQ9MN62v2ZbUOHYAhYSjVV9JXbojRulVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i02JEebWdLT+7WOmLa3T0TAMOjV2Hy6bw8OZdyQU3DfCwM6bqZet4VENFfr0z4GRQ
         mB36WgEW6TbNunOXPfALX94fWDmpZexNy3fxA0GoYIYdWYYsdLAKEVwWXKZeKCWoPq
         EwWkwZLWqb+wSktzUWVf/lpIO4Ggy7yL0+wObXNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 60/85] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case
Date:   Mon,  5 Oct 2020 17:26:56 +0200
Message-Id: <20201005142117.611099488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

[ Upstream commit 149415586243bd0ea729760fb6dd7b3c50601871 ]

transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd for
the lookup. Hence, update this field directly for the
TARGET_SCF_LOOKUP_LUN_FROM_TAG case.

Link: https://lore.kernel.org/r/1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com
Fixes: a36840d80027 ("target: Initialize LUN in transport_init_se_cmd()")
Reported-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e6e1fa68de542..94f4f05b5002c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1840,7 +1840,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * out unpacked_lun for the original se_cmd.
 	 */
 	if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
-		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
+		if (!target_lookup_lun_from_tag(se_sess, tag,
+						&se_cmd->orig_fe_lun))
 			goto failure;
 	}
 
-- 
2.25.1



