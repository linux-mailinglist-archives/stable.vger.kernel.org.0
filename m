Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0EB4ABC38
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385048AbiBGLbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384503AbiBGL2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26E0C03FED7;
        Mon,  7 Feb 2022 03:26:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D40F86077B;
        Mon,  7 Feb 2022 11:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983BCC004E1;
        Mon,  7 Feb 2022 11:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233190;
        bh=uV0FX6F9dxSljJGabdenurckJ5uyJsUyGltbrmFkPvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnHNBv5RdgSryzrdhbUNyZbBnQiBKxl2Klk9c3I+lF5TUoAAlZkvvMFJmMQxtd/pC
         cK0tfTtYEfZrLeEHX7060keBd1FJ5tsWAsUp4ZMH3c5ZvIcph2eRRAhNIK1s6lJtYQ
         IuDT7LSL68klBnRtDxK9mUN+7qYG1cmzfFN/Q3pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 044/110] RDMA/mlx4: Dont continue event handler after memory allocation failure
Date:   Mon,  7 Feb 2022 12:06:17 +0100
Message-Id: <20220207103803.765024801@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
@@ -3249,7 +3249,7 @@ static void mlx4_ib_event(struct mlx4_de
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
 		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
 		if (!ew)
-			break;
+			return;
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
 		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);


