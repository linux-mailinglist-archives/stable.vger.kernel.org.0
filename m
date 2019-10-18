Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE39DD419
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbfJRWFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbfJRWFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14C6020679;
        Fri, 18 Oct 2019 22:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436347;
        bh=z0DvuLwhSC3a8DkNEt/tFpheLuPJ9uCVXMkkz4YfGcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MbKwwh2cX19V3xN9QjLwALj28XH+R+Dn4APYv8bEwcET/qfdm54tpeJSFKGhQNim
         xpmqZ931L2XSp8Vo6XYkXKUxM9pHEo2y2NJCm4/huUlcJbOUG/Tpv5N2y2xpYpy5il
         e2+GlgPwzd5M9xAK/lJL26o24xnrrWSTIRAB1RB8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/100] bcache: fix input overflow to writeback_rate_minimum
Date:   Fri, 18 Oct 2019 18:03:58 -0400
Message-Id: <20191018220525.9042-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit dab71b2db98dcdd4657d151b01a7be88ce10f9d1 ]

dc->writeback_rate_minimum is type unsigned integer variable, it is set
via sysfs interface, and converte from input string to unsigned integer
by d_strtoul_nonzero(). When the converted input value is larger than
UINT_MAX, overflow to unsigned integer happens.

This patch fixes the overflow by using sysfs_strotoul_clamp() to
convert input string and limit the value in range [1, UINT_MAX], then
the overflow can be avoided.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 5bb81e564ce88..3e8d1f1b562f8 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -289,7 +289,9 @@ STORE(__cached_dev)
 	sysfs_strtoul_clamp(writeback_rate_p_term_inverse,
 			    dc->writeback_rate_p_term_inverse,
 			    1, UINT_MAX);
-	d_strtoul_nonzero(writeback_rate_minimum);
+	sysfs_strtoul_clamp(writeback_rate_minimum,
+			    dc->writeback_rate_minimum,
+			    1, UINT_MAX);
 
 	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
 
-- 
2.20.1

