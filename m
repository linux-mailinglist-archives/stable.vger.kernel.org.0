Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675B233B987
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhCOOGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233404AbhCOOBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B6A164F0D;
        Mon, 15 Mar 2021 14:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816872;
        bh=NHI2zy8EIbXBo9+j9AzgGaNPZECXDU4lEsxTgk8kLpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuFMhMBERgysL0+jSkkccriCoUJL2IixorV3qLKubd2J5qC49hbBBx982lybUWcCS
         /HaLIg/I46/RFLdndkotWgL55XKQQqDUDY37v1rhK+maVzlha6p9RgWlCjttxbLrh/
         A9PBjU29sflTcUz5EIOyEQTZhOBkiGzDGSAWCuK0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 163/168] nvme: release namespace head reference on error
Date:   Mon, 15 Mar 2021 14:56:35 +0100
Message-Id: <20210315135555.717916076@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Keith Busch <kbusch@kernel.org>

commit ac262508daa88fb12c5dc53cf30bde163f9f26c9 upstream.

If a namespace identification does not match the subsystem's head for
that NSID, release the reference that was taken when the matching head
was initially found.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3467,6 +3467,7 @@ static int nvme_init_ns_head(struct nvme
 				"IDs don't match for shared namespace %d\n",
 					nsid);
 			ret = -EINVAL;
+			nvme_put_ns_head(head);
 			goto out_unlock;
 		}
 	}


