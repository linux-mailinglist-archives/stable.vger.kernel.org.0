Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6310734C96E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhC2I3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234076AbhC2I1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8491E619C3;
        Mon, 29 Mar 2021 08:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006400;
        bh=bIEDZuFsKuAvKMy90rwqNNGRjdBOBYGK8DrFVB9F2ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv5FHkXbBLh9leh7Gj448grA1Tg2UDk53AD14Pl9iZWtZ4xgeD9DklOxGAJYj5Y+m
         r+yCd2+ldefjezFyBzQLKxSV0PVPBrCBxd97p3om0Qqcn2TxWqT0x5CwaxbrfDUovJ
         I8rMyn0Ne94JESlrZphNmy64RRIi0L0+f59tVV0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 220/221] nvme: fix the nsid value to print in nvme_validate_or_alloc_ns
Date:   Mon, 29 Mar 2021 09:59:11 +0200
Message-Id: <20210329075636.478418211@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit f4f9fc29e56b6fa9d7fa65ec51d3c82aff99c99b upstream.

ns can be NULL at this point, and my move of the check from
the original patch by Chaitanya broke this.

Fixes: 0ec84df4953b ("nvme-core: check ctrl css before setting up zns")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4022,7 +4022,7 @@ static void nvme_validate_or_alloc_ns(st
 		if (!nvme_multi_css(ctrl)) {
 			dev_warn(ctrl->device,
 				"command set not reported for nsid: %d\n",
-				ns->head->ns_id);
+				nsid);
 			break;
 		}
 		nvme_alloc_ns(ctrl, nsid, &ids);


