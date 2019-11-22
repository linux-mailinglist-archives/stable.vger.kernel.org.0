Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF3106DE8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfKVLEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbfKVLET (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14B312084D;
        Fri, 22 Nov 2019 11:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420658;
        bh=I/hN7bioODU5zQWOx0AH4pWxYq6n0Y2wxs/LWEPYvns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGFUsbn6um+wiAWUkZRkD4+oMTE5q9aH9wpIsGmkFr4kusgfJvfpIfw7o0Ms0I2Fv
         hSriu/7/35Pq2DEh5X2MLo/W6U69h1DryfwsDBHlON/mosEa449V/kS45Lo0TsE8Lb
         8vbgeCOy/3a66Oe2yJt7kIoKO0qnipS6Old93S/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 183/220] lightnvm: pblk: guarantee mw_cunits on read buffer
Date:   Fri, 22 Nov 2019 11:29:08 +0100
Message-Id: <20191122100927.433258602@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



