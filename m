Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFD2489161
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbiAJHbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58822 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbiAJH3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C41EEB81216;
        Mon, 10 Jan 2022 07:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18050C36AEF;
        Mon, 10 Jan 2022 07:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799774;
        bh=WLcjkDH0MA5Ws7HBfmZfW8Pr+NSz5/fPbxZShZIadus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXGf3x5mPaYoN+dbHPDpxhA6cBMirmFURxtEb1rJb653ty8hKstu3fM/2aEmDXJmz
         R+Ly4+6WPdQXUV/aI4ARbj8zg8nGQToCm84aecdDKOFghY2R3KMuqlOXmAh4M/jje0
         sbqXr+0G+uYURcSDXY+IILbJc0dBc+uStB3Wb2Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 10/43] RDMA/uverbs: Check for null return of kmalloc_array
Date:   Mon, 10 Jan 2022 08:23:07 +0100
Message-Id: <20220110071817.700558031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit 7694a7de22c53a312ea98960fcafc6ec62046531 upstream.

Because of the possible failure of the allocation, data might be NULL
pointer and will cause the dereference of the NULL pointer later.
Therefore, it might be better to check it and return -ENOMEM.

Fixes: 6884c6c4bd09 ("RDMA/verbs: Store the write/write_ex uapi entry points in the uverbs_api")
Link: https://lore.kernel.org/r/20211231093315.1917667-1-jiasheng@iscas.ac.cn
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_uapi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -450,6 +450,9 @@ static int uapi_finalize(struct uverbs_a
 	uapi->num_write_ex = max_write_ex + 1;
 	data = kmalloc_array(uapi->num_write + uapi->num_write_ex,
 			     sizeof(*uapi->write_methods), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	for (i = 0; i != uapi->num_write + uapi->num_write_ex; i++)
 		data[i] = &uapi->notsupp_method;
 	uapi->write_methods = data;


