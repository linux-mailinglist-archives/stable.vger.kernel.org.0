Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B5A106E56
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbfKVLE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731212AbfKVLEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BB92070E;
        Fri, 22 Nov 2019 11:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420664;
        bh=m5hJaHVZrLSf1mJK7b9kB9bQlJxzbNzPsHf/khSsGYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwGeDFdPlbTEGaaajHZ86u1+OCFe2RT4M8enLWGknkBoTnVbdlbj11RHSDgvL4Etd
         z0yevWC9NwvIVP2g8UAIDrhB4nMYoEJJCuXae7JQZ6mDt80azNmz+MaPqbh5hO/GFZ
         hLrnq8REe5QyEcJFV2xWX2Av8cHoQDR9h8+ouXt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Hans Holmberg <hans.holmberg@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/220] lightnvm: pblk: fix error handling of pblk_lines_init()
Date:   Fri, 22 Nov 2019 11:29:10 +0100
Message-Id: <20191122100927.535051969@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit a70985f83c625a5eaf618be81621e5e4521a66c6 ]

In the too many bad blocks error handling case, we should release all
the allocated resources, otherwise it will cause memory leak.

Fixes: 2deeefc02dff ("lightnvm: pblk: fail gracefully on line alloc. failure")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Hans Holmberg <hans.holmberg@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index dc32274881b2f..91fd2b291db91 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -1084,7 +1084,8 @@ static int pblk_lines_init(struct pblk *pblk)
 
 	if (!nr_free_chks) {
 		pblk_err(pblk, "too many bad blocks prevent for sane instance\n");
-		return -EINTR;
+		ret = -EINTR;
+		goto fail_free_lines;
 	}
 
 	pblk_set_provision(pblk, nr_free_chks);
-- 
2.20.1



