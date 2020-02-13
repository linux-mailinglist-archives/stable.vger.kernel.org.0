Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3215C474
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgBMPr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387650AbgBMP1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:03 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358D32465D;
        Thu, 13 Feb 2020 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607623;
        bh=Kp5ITOmmGRq5nUzVovCIS4LzsjYjFZEjGH8vi4E4nvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlNcgDbEu0+M3EN1y663NVDmtGMxawgTIh7dfST0K54bXhm8SoJEOgfHnElROxrq6
         /A9iomX/VMAF6Hiv93uHmfkquxUFfn+gWYqZiH2Q96kzpPYP9AL+Pd3g1/7PKcEw/3
         /BCapFVZPi9febq5kexLWZS+fdtZ5ICOAZTfqTzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 04/96] IB/srp: Never use immediate data if it is disabled by a user
Date:   Thu, 13 Feb 2020 07:20:11 -0800
Message-Id: <20200213151840.592525080@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Gorenko <sergeygo@mellanox.com>

commit 0fbb37dd82998b5c83355997b3bdba2806968ac7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2536,7 +2536,8 @@ static void srp_cm_rep_handler(struct ib
 	if (lrsp->opcode == SRP_LOGIN_RSP) {
 		ch->max_ti_iu_len = be32_to_cpu(lrsp->max_ti_iu_len);
 		ch->req_lim       = be32_to_cpu(lrsp->req_lim_delta);
-		ch->use_imm_data  = lrsp->rsp_flags & SRP_LOGIN_RSP_IMMED_SUPP;
+		ch->use_imm_data  = srp_use_imm_data &&
+			(lrsp->rsp_flags & SRP_LOGIN_RSP_IMMED_SUPP);
 		ch->max_it_iu_len = srp_max_it_iu_len(target->cmd_sg_cnt,
 						      ch->use_imm_data);
 		WARN_ON_ONCE(ch->max_it_iu_len >


