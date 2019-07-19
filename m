Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C026DA59
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfGSEBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbfGSEBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93AE521897;
        Fri, 19 Jul 2019 04:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508896;
        bh=YPHQWDnAjj6f0it24YzhQzQrShEq69mzDHoUQixDxp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5TWs8TEwQZ/mx7I1XRVurRH8pfS5GEG78r18znce9w5oWjT2HNj8GS5mr+TAEbZZ
         OqEZ8bIdN2uXJt+5Rnh08fKCqSMQNfjI7hjTdccR+I3rNnhNLGTIunVT+uvS4WlvQN
         vYeEyplUD/ej0aqV1qt4NV/g69ngtZaFtRP9Tguo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heng Xiao <heng.xiao@unisoc.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.2 144/171] f2fs: fix to avoid long latency during umount
Date:   Thu, 18 Jul 2019 23:56:15 -0400
Message-Id: <20190719035643.14300-144-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heng Xiao <heng.xiao@unisoc.com>

[ Upstream commit 6e0cd4a9dd4df1a0afcb454f1e654b5c80685913 ]

In umount, we give an constand time to handle pending discard, previously,
in __issue_discard_cmd() we missed to check timeout condition in loop,
result in delaying long time, fix it.

Signed-off-by: Heng Xiao <heng.xiao@unisoc.com>
[Chao Yu: add commit message]
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8903b61457e7..291f7106537c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1486,6 +1486,10 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 		list_for_each_entry_safe(dc, tmp, pend_list, list) {
 			f2fs_bug_on(sbi, dc->state != D_PREP);
 
+			if (dpolicy->timeout != 0 &&
+				f2fs_time_over(sbi, dpolicy->timeout))
+				break;
+
 			if (dpolicy->io_aware && i < dpolicy->io_aware_gran &&
 						!is_idle(sbi, DISCARD_TIME)) {
 				io_interrupted = true;
-- 
2.20.1

