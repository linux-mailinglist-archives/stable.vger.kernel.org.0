Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417C115F0F6
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388048AbgBNR6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388019AbgBNP4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB092086A;
        Fri, 14 Feb 2020 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695814;
        bh=hJczrfq4NJKGpubcEvXSXTXvYRR3QAEZ6ENaMdbMA0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJ+vawhykcraPPXM7k2ZPZx6L4M7KXaSu0feD+U44T209NyqofjS6Uju4RH5ZBXw6
         DMY6uZD+aQgzlX/bup91h7RikRzyLMCLqeDsR3IenAO/acYeqpPlG4TnyMXF7ckbL/
         VzbtC5WAzcwOYBfLaJS91SYWNuElKck3BFQDpSqk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Gorenko <sergeygo@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 372/542] IB/srp: Never use immediate data if it is disabled by a user
Date:   Fri, 14 Feb 2020 10:46:04 -0500
Message-Id: <20200214154854.6746-372-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Gorenko <sergeygo@mellanox.com>

[ Upstream commit 0fbb37dd82998b5c83355997b3bdba2806968ac7 ]

Some SRP targets that do not support specification SRP-2, put the garbage
to the reserved bits of the SRP login response.  The problem was not
detected for a long time because the SRP initiator ignored those bits. But
now one of them is used as SRP_LOGIN_RSP_IMMED_SUPP. And it causes a
critical error on the target when the initiator sends immediate data.

The ib_srp module has a use_imm_date parameter to enable or disable
immediate data manually. But it does not help in the above case, because
use_imm_date is ignored at handling the SRP login response. The problem is
definitely caused by a bug on the target side, but the initiator's
behavior also does not look correct.  The initiator should not use
immediate data if use_imm_date is disabled by a user.

This commit adds an additional checking of use_imm_date at the handling of
SRP login response to avoid unexpected use of immediate data.

Fixes: 882981f4a411 ("RDMA/srp: Add support for immediate data")
Link: https://lore.kernel.org/r/20200115133055.30232-1-sergeygo@mellanox.com
Signed-off-by: Sergey Gorenko <sergeygo@mellanox.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b7f7a5f7bd986..cd1181c39ed29 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2546,7 +2546,8 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	if (lrsp->opcode == SRP_LOGIN_RSP) {
 		ch->max_ti_iu_len = be32_to_cpu(lrsp->max_ti_iu_len);
 		ch->req_lim       = be32_to_cpu(lrsp->req_lim_delta);
-		ch->use_imm_data  = lrsp->rsp_flags & SRP_LOGIN_RSP_IMMED_SUPP;
+		ch->use_imm_data  = srp_use_imm_data &&
+			(lrsp->rsp_flags & SRP_LOGIN_RSP_IMMED_SUPP);
 		ch->max_it_iu_len = srp_max_it_iu_len(target->cmd_sg_cnt,
 						      ch->use_imm_data,
 						      target->max_it_iu_size);
-- 
2.20.1

