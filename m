Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D34ABCC4
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387102AbiBGLjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385851AbiBGLcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF71C043181;
        Mon,  7 Feb 2022 03:32:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78F3DB80EBD;
        Mon,  7 Feb 2022 11:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0263C004E1;
        Mon,  7 Feb 2022 11:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233567;
        bh=gn4OAdhu+hH8rfibNVVxX0yqlvsmy0BuWCaHNaM1xOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prOl8y9c6JD/WCjf6T8MWgEcWM+J7EtelLBTv74abrq02MvTCmjFw12PW21DDVT4G
         2xCuyy7WjPKUQ017DM4oVmHIPkDqb++GFnrCVUEhw67JLqk6Xt4OfaXd8+Zh7qeGyE
         ZX8q8TQm/S3Di2HCN01G7T17OMKgGg+YsqiYFyoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.16 051/126] IB/rdmavt: Validate remote_addr during loopback atomic tests
Date:   Mon,  7 Feb 2022 12:06:22 +0100
Message-Id: <20220207103805.876644010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 4028bccb003cf67e46632dee7f97ddc5d7b6e685 upstream.

The rdma-core test suite sends an unaligned remote address and expects a
failure.

ERROR: test_atomic_non_aligned_addr (tests.test_atomic.AtomicTest)

The qib/hfi1 rc handling validates properly, but the test has the client
and server on the same system.

The loopback of these operations is a distinct code path.

Fix by syntaxing the proposed remote address in the loopback code path.

Fixes: 15703461533a ("IB/{hfi1, qib, rdmavt}: Move ruc_loopback to rdmavt")
Link: https://lore.kernel.org/r/1642584489-141005-1-git-send-email-mike.marciniszyn@cornelisnetworks.com
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -3073,6 +3073,8 @@ do_write:
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC)))
 			goto inv_err;
+		if (unlikely(wqe->atomic_wr.remote_addr & (sizeof(u64) - 1)))
+			goto inv_err;
 		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
 					  wqe->atomic_wr.remote_addr,
 					  wqe->atomic_wr.rkey,


