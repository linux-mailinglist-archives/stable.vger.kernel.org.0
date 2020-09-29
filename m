Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3152327CD0E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733097AbgI2Mlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbgI2LNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:13:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15907208FE;
        Tue, 29 Sep 2020 11:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377991;
        bh=R7udU7qjbVJXNkZIZ23f31Yog5VwT1i1S/jbgDaczaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hapPsaMxQIOnsws92/fWUuoI77MNcd4IQpHjfrZWAjDOTiLUeJrUODgWw7LTFi2Ho
         dPeeRBGqg/zns8m8DBFMpJM1o0kOFS5yo7mHphZkz+uncoPFCLxTzwcIqOpcKjuylV
         gv1awv09PEJ3Qu2jqBxWQwT+gA8cNCFsnlFfgGSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shamir Rabinovitch <shamir.rabinovitch@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 006/166] RDMA/ucma: ucma_context reference leak in error path
Date:   Tue, 29 Sep 2020 12:58:38 +0200
Message-Id: <20200929105935.510507124@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>

commit ef95a90ae6f4f21990e1f7ced6719784a409e811 upstream.

Validating input parameters should be done before getting the cm_id
otherwise it can leak a cm_id reference.

Fixes: 6a21dfc0d0db ("RDMA/ucma: Limit possible option size")
Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
[iwamatsu: Backported to 4.4, 4.9 and 4.14: adjust context]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ucma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1315,13 +1315,13 @@ static ssize_t ucma_set_option(struct uc
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
+	if (unlikely(cmd.optlen > KMALLOC_MAX_SIZE))
+		return -EINVAL;
+
 	ctx = ucma_get_ctx(file, cmd.id);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	if (unlikely(cmd.optlen > KMALLOC_MAX_SIZE))
-		return -EINVAL;
-
 	optval = memdup_user((void __user *) (unsigned long) cmd.optval,
 			     cmd.optlen);
 	if (IS_ERR(optval)) {


