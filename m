Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C555BAAE8
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiIPKZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiIPKY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A0CB1BBC;
        Fri, 16 Sep 2022 03:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43A2762A40;
        Fri, 16 Sep 2022 10:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5237AC433C1;
        Fri, 16 Sep 2022 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323289;
        bh=VEz9JjpyYaclJ4Ov0Hv/XzqEJ+WmTyM5wk09wy0ywus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNBzV6XQYig8hEHY8YrZ0cBk/knUgZLmRolihgTDx+McMWGCQhx38+FoqH+xORfx4
         N84RPVLjxwjZTSjoXL/GqBGyt6VstApMQyBnMhlFGRHoaccck7h995roUsW71RDpPP
         RY38gNOtkUB7gD28/uUhobZdEvLL63binaJkkau0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu-Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.19 37/38] RDMA/irdma: Use s/g array in post send only when its valid
Date:   Fri, 16 Sep 2022 12:09:11 +0200
Message-Id: <20220916100450.018144346@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sindhu-Devale <sindhu.devale@intel.com>

commit 2c8844431d065ae15a6b442f5769b60aeaaa07af upstream.

Send with invalidate verb call can pass in an
uninitialized s/g array with 0 sge's which is
filled into irdma WQE and causes a HW asynchronous
event.

Fix this by using the s/g array in irdma post send
only when its valid.

Fixes: 551c46e ("RDMA/irdma: Add user/kernel shared libraries")
Signed-off-by: Sindhu-Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20220906223244.1119-5-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/uk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -497,7 +497,8 @@ int irdma_uk_send(struct irdma_qp_uk *qp
 			      FIELD_PREP(IRDMAQPSQ_IMMDATA, info->imm_data));
 		i = 0;
 	} else {
-		qp->wqe_ops.iw_set_fragment(wqe, 0, op_info->sg_list,
+		qp->wqe_ops.iw_set_fragment(wqe, 0,
+					    frag_cnt ? op_info->sg_list : NULL,
 					    qp->swqe_polarity);
 		i = 1;
 	}


