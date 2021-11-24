Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B273F45C4EC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348168AbhKXNxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352050AbhKXNu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBBB163238;
        Wed, 24 Nov 2021 13:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759059;
        bh=jmTD+TYAnXdpdVG0Ox6khCkYZynPZ9YU4sgRWqPsCwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPlMBVVNdy0oEdSdsQDkrv3rdKlwvn1C3Fk2RKmOaoRBKdETg5ZRHPIWM8MT1Irsx
         8ioMkyrVfFSQFCVgdJ138WTuZz/y+yG4VMSg0udlG2fmRc2JAwf03WvCe6pO4lkJFv
         CsmYpBxeMDT/Pqxk6BxjbNjO81ekC4vYSv8joXRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/279] bnxt_en: reject indirect blk offload when hw-tc-offload is off
Date:   Wed, 24 Nov 2021 12:56:45 +0100
Message-Id: <20211124115722.876571265@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

[ Upstream commit b0757491a118ae5727cf9f1c3a11544397d46596 ]

The driver does not check if hw-tc-offload is enabled for the device
before offloading a flow in the context of indirect block callback.
Fix this by checking NETIF_F_HW_TC in the features flag and rejecting
the offload request.  This will avoid unnecessary dmesg error logs when
hw-tc-offload is disabled, such as these:

bnxt_en 0000:19:00.1 eno2np1: dev(ifindex=294) not on same switch
bnxt_en 0000:19:00.1 eno2np1: Error: bnxt_tc_add_flow: cookie=0xffff8dace1c88000 error=-22
bnxt_en 0000:19:00.0 eno1np0: dev(ifindex=294) not on same switch
bnxt_en 0000:19:00.0 eno1np0: Error: bnxt_tc_add_flow: cookie=0xffff8dace1c88000 error=-22

Reported-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Fixes: 627c89d00fb9 ("bnxt_en: flow_offload: offload tunnel decap rules via indirect callbacks")
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index e6a4a768b10b2..1471b6130a2b9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1868,7 +1868,7 @@ static int bnxt_tc_setup_indr_block_cb(enum tc_setup_type type,
 	struct flow_cls_offload *flower = type_data;
 	struct bnxt *bp = priv->bp;
 
-	if (flower->common.chain_index)
+	if (!tc_cls_can_offload_and_chain0(bp->dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
-- 
2.33.0



