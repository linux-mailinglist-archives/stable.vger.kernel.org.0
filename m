Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71BC3D6092
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhGZPXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237477AbhGZPXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB8D260F93;
        Mon, 26 Jul 2021 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315415;
        bh=IQtjU2qoyCtCHROhsWif9GtS7XjGEBoyZQjQsz74pfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kj5UsnTkxekMaoTwY9Ho4p4Li3ykyJvl9/HgaW4JYo21qIzGbjkxRMvR6BRX3IhrF
         /yclQs/4FO59BPvPSCX1TWpXdnosLh4RNcxg5EB+oCsYHREi7lZgCIZYMG+fQSXo1/
         ZwxkJpVSGa82UiQQXqUG4qBpCef2NLW59D6ORmps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengwen Feng <fengchengwen@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/167] net: hns3: fix possible mismatches resp of mailbox
Date:   Mon, 26 Jul 2021 17:38:40 +0200
Message-Id: <20210726153842.326363615@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengwen Feng <fengchengwen@huawei.com>

[ Upstream commit 1b713d14dc3c077ec45e65dab4ea01a8bc41b8c1 ]

Currently, the mailbox synchronous communication between VF and PF use
the following fields to maintain communication:
1. Origin_mbx_msg which was combined by message code and subcode, used
to match request and response.
2. Received_resp which means whether received response.

There may possible mismatches of the following situation:
1. VF sends message A with code=1 subcode=1.
2. PF was blocked about 500ms when processing the message A.
3. VF will detect message A timeout because it can't get the response
within 500ms.
4. VF sends message B with code=1 subcode=1 which equal message A.
5. PF processes the first message A and send the response message to
VF.
6. VF will identify the response matched the message B because the
code/subcode is the same. This will lead to mismatch of request and
response.

To fix the above bug, we use the following scheme:
1. The message sent from VF was labelled with match_id which was a
unique 16-bit non-zero value.
2. The response sent from PF will label with match_id which got from
the request.
3. The VF uses the match_id to match request and response message.

As for PF driver, it only needs to copy the match_id from request to
response.

Fixes: dde1a86e93ca ("net: hns3: Add mailbox support to PF driver")
Signed-off-by: Chengwen Feng <fengchengwen@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h        | 6 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 98a9f5e3fe86..98f55fbe6c3d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -134,7 +134,8 @@ struct hclge_mbx_vf_to_pf_cmd {
 	u8 mbx_need_resp;
 	u8 rsv1[1];
 	u8 msg_len;
-	u8 rsv2[3];
+	u8 rsv2;
+	u16 match_id;
 	struct hclge_vf_to_pf_msg msg;
 };
 
@@ -144,7 +145,8 @@ struct hclge_mbx_pf_to_vf_cmd {
 	u8 dest_vfid;
 	u8 rsv[3];
 	u8 msg_len;
-	u8 rsv1[3];
+	u8 rsv1;
+	u16 match_id;
 	struct hclge_pf_to_vf_msg msg;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 2c2d53f5c56e..61f6f0287cbe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -47,6 +47,7 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 
 	resp_pf_to_vf->dest_vfid = vf_to_pf_req->mbx_src_vfid;
 	resp_pf_to_vf->msg_len = vf_to_pf_req->msg_len;
+	resp_pf_to_vf->match_id = vf_to_pf_req->match_id;
 
 	resp_pf_to_vf->msg.code = HCLGE_MBX_PF_VF_RESP;
 	resp_pf_to_vf->msg.vf_mbx_msg_code = vf_to_pf_req->msg.code;
-- 
2.30.2



