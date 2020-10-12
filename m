Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B1628B6F6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbgJLNjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730053AbgJLNio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C5BE21BE5;
        Mon, 12 Oct 2020 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509924;
        bh=uvwa/k5xa2M1gsseXq64HOYbcOvqvzqq/Zn+AUygn8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3fNfDJiuTl7eus9IjXZJPG3ktJgD99NmtOr3hrzTGkWVUsM8c27lbbBo33ZiITcg
         4IGKY6Mg014/U+Eh37Qu08taUJeLFQVYSti3igd5qxGja5QOTU8LSqtFKwX4nD0hn2
         Rkyvco/j8ZroONDiAmEHGQe7z254kcdXrIkCd/VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 17/49] nvme-core: put ctrl ref when module ref get fail
Date:   Mon, 12 Oct 2020 15:27:03 +0200
Message-Id: <20201012132630.238981493@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

commit 4bab69093044ca81f394bd0780be1b71c5a4d308 upstream.

When try_module_get() fails in the nvme_dev_open() it returns without
releasing the ctrl reference which was taken earlier.

Put the ctrl reference which is taken before calling the
try_module_get() in the error return code path.

Fixes: 52a3974feb1a "nvme-core: get/put ctrl and transport module in nvme_dev_open/release()"
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2606,8 +2606,10 @@ static int nvme_dev_open(struct inode *i
 	}
 
 	nvme_get_ctrl(ctrl);
-	if (!try_module_get(ctrl->ops->module))
+	if (!try_module_get(ctrl->ops->module)) {
+		nvme_put_ctrl(ctrl);
 		return -EINVAL;
+	}
 
 	file->private_data = ctrl;
 	return 0;


