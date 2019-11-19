Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACF0101878
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfKSFbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728851AbfKSFbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9374721939;
        Tue, 19 Nov 2019 05:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141507;
        bh=jG2aSz2Pb4y1MKAx7DVTE3iYnfIdbnCZP2NYAc2w5SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ri+UnuQylCzcgbfXdSRUr5qBlxgB65WWKTZsx1E/Ywtxs1G0vjBvqOuWzhOiDn8LT
         htypav1eEbrG4UMho/qtlFzORIgi/1RDDOKD3CLsry/26c71VnaqgZqq+o55su9vy2
         NQiuY++UAMz1AmPqCvXWQaK/GAUTkq7Tjdc1bw1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/422] f2fs: submit bio after shutdown
Date:   Tue, 19 Nov 2019 06:15:41 +0100
Message-Id: <20191119051408.051714137@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 5ce805869cbed93267ed26552ff76e30f05c91f7 ]

Sometimes, some merged IOs could get a chance to be submitted, resulting in
system hang in shutdown test. This issues IOs all the time after shutdown.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c61beaedf0789..b4a634da1372b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -543,6 +543,8 @@ skip:
 	if (fio->in_list)
 		goto next;
 out:
+	if (is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN))
+		__submit_merged_bio(io);
 	up_write(&io->io_rwsem);
 }
 
-- 
2.20.1



