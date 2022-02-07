Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11BC4ABCC1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387096AbiBGLjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385837AbiBGLcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBB5C043181;
        Mon,  7 Feb 2022 03:32:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 564B2B80EC3;
        Mon,  7 Feb 2022 11:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717FAC004E1;
        Mon,  7 Feb 2022 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233564;
        bh=4jVbnwfVC3bF207Ch0FiydCtVRc8MucTpP3gbvg3VWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8lieLTQs9tksiOZnPLQwP0FPEujde2GbR25deL5t/kvpZn3vVOyturPU9oH6OVwN
         bZ/6ICU36FbM7W7YDP2gOqqrpYwoynYgweFmHYQSOd11Dptf9ptUygtxk6WF/u5GCu
         AES8CXp/hDvEglzHJHRjw1ith9Kht4J9kKxEhKKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.16 050/126] RDMA/siw: Fix refcounting leak in siw_create_qp()
Date:   Mon,  7 Feb 2022 12:06:21 +0100
Message-Id: <20220207103805.844976517@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a75badebfdc0b3823054bedf112edb54d6357c75 upstream.

The atomic_inc() needs to be paired with an atomic_dec() on the error
path.

Fixes: 514aee660df4 ("RDMA: Globally allocate and release QP memory")
Link: https://lore.kernel.org/r/20220118091104.GA11671@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -311,7 +311,8 @@ int siw_create_qp(struct ib_qp *ibqp, st
 
 	if (atomic_inc_return(&sdev->num_qp) > SIW_MAX_QP) {
 		siw_dbg(base_dev, "too many QP's\n");
-		return -ENOMEM;
+		rv = -ENOMEM;
+		goto err_atomic;
 	}
 	if (attrs->qp_type != IB_QPT_RC) {
 		siw_dbg(base_dev, "only RC QP's supported\n");


