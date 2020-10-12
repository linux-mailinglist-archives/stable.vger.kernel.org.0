Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B702528B8C2
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbgJLNzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389657AbgJLNpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846242225F;
        Mon, 12 Oct 2020 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510267;
        bh=ECMisNL/3ISLyOzerwuAYHR8RzFjOxrIyD7RWOoAV9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTUc6gzxvinD5Os9euFLgwgOLzwiVSlYErNdFIbJ3w6rdpkAdWdMFY2IKNEUCguA5
         6O9wUncEurlQb4pwPfy/G/ISS1uuI4OPpqJ1VyFtYKM3/6bj5YFTP5QNj9199Gg4M9
         apr47XIRSjG441Z2T+ijxHfOEGt9b842qXsKczf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.8 026/124] nvme-core: put ctrl ref when module ref get fail
Date:   Mon, 12 Oct 2020 15:30:30 +0200
Message-Id: <20201012133148.115584432@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
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
@@ -3061,8 +3061,10 @@ static int nvme_dev_open(struct inode *i
 	}
 
 	nvme_get_ctrl(ctrl);
-	if (!try_module_get(ctrl->ops->module))
+	if (!try_module_get(ctrl->ops->module)) {
+		nvme_put_ctrl(ctrl);
 		return -EINVAL;
+	}
 
 	file->private_data = ctrl;
 	return 0;


