Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E74B2F9F99
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391536AbhARM1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390708AbhARLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83C9322D03;
        Mon, 18 Jan 2021 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970293;
        bh=OtZkF8mb7q3okdZ9RuCXAbJfJHsoYINndQsYjO9GjIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4Dla6DUJDRw8hcRWEmARkDK/ICzD0gdMsSfyxsfD+nRoKDOMHwaydqTaRk6cRuHG
         xdD7EFOW5djHPu8WDPjmazypFcaHWCwMvquBPb5F746MHhGOtRkU2TATM9u/RkZQ+B
         Uef71GinAcsc8tz5HwZdeQFMBX7aHPt7pSaXgoCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Wang <pkuwangh@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 119/152] nvme-tcp: fix possible data corruption with bio merges
Date:   Mon, 18 Jan 2021 12:34:54 +0100
Message-Id: <20210118113358.430824100@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit ca1ff67d0fb14f39cf0cc5102b1fbcc3b14f6fb9 upstream.

When a bio merges, we can get a request that spans multiple
bios, and the overall request payload size is the sum of
all bios. When we calculate how much we need to send
from the existing bio (and bvec), we did not take into
account the iov_iter byte count cap.

Since multipage bvecs support, bvecs can split in the middle
which means that when we account for the last bvec send we
should also take the iov_iter byte count cap as it might be
lower than the last bvec size.

Reported-by: Hao Wang <pkuwangh@gmail.com>
Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Tested-by: Hao Wang <pkuwangh@gmail.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -201,7 +201,7 @@ static inline size_t nvme_tcp_req_cur_of
 
 static inline size_t nvme_tcp_req_cur_length(struct nvme_tcp_request *req)
 {
-	return min_t(size_t, req->iter.bvec->bv_len - req->iter.iov_offset,
+	return min_t(size_t, iov_iter_single_seg_count(&req->iter),
 			req->pdu_len - req->pdu_sent);
 }
 


