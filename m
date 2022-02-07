Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E54ABB55
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384393AbiBGL2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382361AbiBGLS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:18:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB7CC0401D2;
        Mon,  7 Feb 2022 03:18:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7953661388;
        Mon,  7 Feb 2022 11:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484B1C004E1;
        Mon,  7 Feb 2022 11:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232728;
        bh=nLja3KJrMm451tePeJRkSOSCVt0H4TJ+JcyUcy8Hgq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRYrsXInCGgkzBE/2N7Jyu4AQnM/7CmsK7SdVrr+u6z1reAooRNVWbN3QrGHWjYqy
         uXiLc0O3Ir0Tb2DU5M4HMQvdbfd8SHHV1q+KL/UOqtLDGMaXpr/a4bDLXcfWAEOH1/
         MsG2GR175QJvDAaRtz9sqdLGx45aC6/uJJK2TbVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 18/44] RDMA/mlx4: Dont continue event handler after memory allocation failure
Date:   Mon,  7 Feb 2022 12:06:34 +0100
Message-Id: <20220207103753.747092286@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

commit f3136c4ce7acf64bee43135971ca52a880572e32 upstream.

The failure to allocate memory during MLX4_DEV_EVENT_PORT_MGMT_CHANGE
event handler will cause skip the assignment logic, but
ib_dispatch_event() will be called anyway.

Fix it by calling to return instead of break after memory allocation
failure.

Fixes: 00f5ce99dc6e ("mlx4: Use port management change event instead of smp_snoop")
Link: https://lore.kernel.org/r/12a0e83f18cfad4b5f62654f141e240d04915e10.1643622264.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3291,7 +3291,7 @@ static void mlx4_ib_event(struct mlx4_de
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
 		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
 		if (!ew)
-			break;
+			return;
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
 		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);


