Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7014713FD11
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389002AbgAPXVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388331AbgAPXVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FE27217F4;
        Thu, 16 Jan 2020 23:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216891;
        bh=eFuu4AkZbGFVHxSIUBlGUCNXhcBY2Ws9zphvVve1H/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2um/G5f67ns4aw54EHFH0NzhrDU7u0CKvDw+klWeylwZQb/CbSs68uraHnp/kIh0
         7OySLmJH7YhxniC+8g4nUeOdNXAaWCMJ8TomHukHcy3rRs+tf/FU+NaNMf++vUhqVJ
         kD9ywBnIPP3cl2boDfVTK1/Q94whKyQPAXDnUQRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.4 062/203] RDMA/hns: remove a redundant le16_to_cpu
Date:   Fri, 17 Jan 2020 00:16:19 +0100
Message-Id: <20200116231749.450593412@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

commit 9f7d7064009c37cb26eee4a83302cf077fe180d6 upstream.

Type of ah->av.vlan is u16, there will be a problem using le16_to_cpu
on it.

Fixes: 82e620d9c3a0 ("RDMA/hns: Modify the data structure of hns_roce_av")
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Link: https://lore.kernel.org/r/1567566885-23088-2-git-send-email-liweihang@hisilicon.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -389,7 +389,7 @@ static int hns_roce_v2_post_send(struct
 			roce_set_field(ud_sq_wqe->byte_36,
 				       V2_UD_SEND_WQE_BYTE_36_VLAN_M,
 				       V2_UD_SEND_WQE_BYTE_36_VLAN_S,
-				       le16_to_cpu(ah->av.vlan));
+				       ah->av.vlan);
 			roce_set_field(ud_sq_wqe->byte_36,
 				       V2_UD_SEND_WQE_BYTE_36_HOPLIMIT_M,
 				       V2_UD_SEND_WQE_BYTE_36_HOPLIMIT_S,


