Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30063FA48B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbfKMBzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbfKMBzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43C70204EC;
        Wed, 13 Nov 2019 01:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610117;
        bh=I/hN7bioODU5zQWOx0AH4pWxYq6n0Y2wxs/LWEPYvns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js7SRVYBpotuyGpXgiE/BVxpcpD9ngdcX9oEV0PcG7TfONC7GWlSlps4jT9BbHX1x
         a1Mjzld0+ax/kpdw2hTu9oKG6ZbtOTi2/ZK1XsIAmg/oO+kQxBULPrZQRQBPMOcz5n
         0K6ZTpgOcl8ehDZp5wgQzomS4JBXqy9geem82Jxs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 172/209] lightnvm: pblk: guarantee mw_cunits on read buffer
Date:   Tue, 12 Nov 2019 20:49:48 -0500
Message-Id: <20191113015025.9685-172-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier González <javier@javigon.com>

[ Upstream commit d672d92d9c433c365fd6cdb4da1c02562b5f1178 ]

OCSSD 2.0 defines the amount of data that the host must buffer per chunk
to guarantee reads through the geometry field mw_cunits. This value is
the base that pblk uses to determine the size of its read buffer.
Currently, this size is set to be the closes power-of-2 to mw_cunits
times the number of parallel units available to the pblk instance for
each open line (currently one). When an entry (4KB) is put in the
buffer, the L2P table points to it. As the buffer wraps up, the L2P is
updated to point to addresses on the device, thus guaranteeing mw_cunits
at a chunk level.

However, given that pblk cannot write to the device under ws_min
(normally ws_opt), there might be a window in which the buffer starts
wrapping up and updating L2P entries before the mw_cunits value in a
chunk has been surpassed.

In order not to violate the mw_cunits constrain in this case, account
for ws_opt on the read buffer creation.

Signed-off-by: Javier González <javier@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index 145922589b0c6..dc32274881b2f 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -181,7 +181,8 @@ static int pblk_rwb_init(struct pblk *pblk)
 	unsigned int power_size, power_seg_sz;
 	int pgs_in_buffer;
 
-	pgs_in_buffer = max(geo->mw_cunits, geo->ws_opt) * geo->all_luns;
+	pgs_in_buffer = (max(geo->mw_cunits, geo->ws_opt) + geo->ws_opt)
+								* geo->all_luns;
 
 	if (write_buffer_size && (write_buffer_size > pgs_in_buffer))
 		buffer_size = write_buffer_size;
-- 
2.20.1

