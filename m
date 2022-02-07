Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536234ABBA9
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384683AbiBGL3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383151AbiBGLVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD864C0401C9;
        Mon,  7 Feb 2022 03:21:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C3336126D;
        Mon,  7 Feb 2022 11:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CD3C004E1;
        Mon,  7 Feb 2022 11:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232898;
        bh=xcwRTLWfcoreqpPWUuCpo3zgDv3YjEwAjCch1f5MauY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3nB+vRb8eoRfoamc8CP15Ea4td4ZBPDJNJ1mQRPshPGCa2fqJpRvfULCxCEx8YVH
         Qm1ip2N/IPRmxXsIxORkEsopJM/Q/cbSGKos7xKQlv27e4Nlmfo2ir7QW0wOxH8XfK
         yR/8ul9At1jzAi+AX4XrK27PdnTgQzBGOV43TtGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 27/74] IB/rdmavt: Validate remote_addr during loopback atomic tests
Date:   Mon,  7 Feb 2022 12:06:25 +0100
Message-Id: <20220207103758.129515893@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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
@@ -3124,6 +3124,8 @@ do_write:
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC)))
 			goto inv_err;
+		if (unlikely(wqe->atomic_wr.remote_addr & (sizeof(u64) - 1)))
+			goto inv_err;
 		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
 					  wqe->atomic_wr.remote_addr,
 					  wqe->atomic_wr.rkey,


