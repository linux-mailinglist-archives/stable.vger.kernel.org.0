Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8012C979F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 07:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgLAGp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 01:45:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8169 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgLAGp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 01:45:59 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ClXds5lK9z15TpS;
        Tue,  1 Dec 2020 14:44:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 14:45:13 +0800
From:   Jack Qiu <jack.qiu@huawei.com>
To:     <linux-f2fs-devel@lists.sourceforge.net>
CC:     <stable@vger.kernel.org>
Subject: [PATCH] f2fs: init dirty_secmap incorrectly
Date:   Tue, 1 Dec 2020 15:45:47 +0800
Message-ID: <20201201074547.1872-1-jack.qiu@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

section is dirty, but dirty_secmap may not set

Reported-by: Jia Yang <jiayang5@huawei.com>
Fixes: da52f8ade40b ("f2fs: get the right gc victim section when section
has several segments")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jack Qiu <jack.qiu@huawei.com>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1596502f7375..f2a4265318f5 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4544,7 +4544,7 @@ static void init_dirty_segmap(struct f2fs_sb_info *sbi)
 		return;

 	mutex_lock(&dirty_i->seglist_lock);
-	for (segno = 0; segno < MAIN_SECS(sbi); segno += blks_per_sec) {
+	for (segno = 0; segno < MAIN_SEGS(sbi); segno += sbi->segs_per_sec) {
 		valid_blocks = get_valid_blocks(sbi, segno, true);
 		secno = GET_SEC_FROM_SEG(sbi, segno);

--
2.17.1

