Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED34F4A3C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbfKHMHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732242AbfKHLkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C0F521D7F;
        Fri,  8 Nov 2019 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213243;
        bh=jG2aSz2Pb4y1MKAx7DVTE3iYnfIdbnCZP2NYAc2w5SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcosBiwtD2tA6XPjC0baVgWhns7RtEYnLfdQsNTMDDefcJPF/UdMFCtFOYM2YYK/W
         NiGRP+v7zU5tbUlkIYNn8G2JBXaZK5teQOme+2wB/6WsU7wc/3IIi3sdYApjH7MTGD
         6pq5ue41XcufQgObtaiancvHO6GZ+HCnHFZkI2Tg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 112/205] f2fs: submit bio after shutdown
Date:   Fri,  8 Nov 2019 06:36:19 -0500
Message-Id: <20191108113752.12502-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

