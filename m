Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0FF48917C
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbiAJHcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239615AbiAJHaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851CCC0258CC;
        Sun,  9 Jan 2022 23:27:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BB4CB81205;
        Mon, 10 Jan 2022 07:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9428EC36AEF;
        Mon, 10 Jan 2022 07:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799673;
        bh=GeiqySQAEqxgjDHX0+jeEn3qP1jo4JGurvPZgSGuruI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5fxEqYcny4ntQi/ErGjzIZ1UW8qe9nnHYAnDWF6kdP9q1oj6bqzSkAxIJekDwJJm
         NmtmE/ssyft+CT2HWx4SEZTpt/0L3CloPkCZWF0Sz5RdTJQuV73BdLhm9NRQUBUAUw
         eLzlwcV9/OoAhtCsHpwsL/PmqJB/k1qFq/rVOs/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhuang <zhuangyi1@huawei.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 01/34] f2fs: quota: fix potential deadlock
Date:   Mon, 10 Jan 2022 08:22:56 +0100
Message-Id: <20220110071815.697353000@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit a5c0042200b28fff3bde6fa128ddeaef97990f8d upstream.

As Yi Zhuang reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=214299

There is potential deadlock during quota data flush as below:

Thread A:			Thread B:
f2fs_dquot_acquire
down_read(&sbi->quota_sem)
				f2fs_write_checkpoint
				block_operations
				f2fs_look_all
				down_write(&sbi->cp_rwsem)
f2fs_quota_write
f2fs_write_begin
__do_map_lock
f2fs_lock_op
down_read(&sbi->cp_rwsem)
				__need_flush_qutoa
				down_write(&sbi->quota_sem)

This patch changes block_operations() to use trylock, if it fails,
it means there is potential quota data updater, in this condition,
let's flush quota data first and then trylock again to check dirty
status of quota data.

The side effect is: in heavy race condition (e.g. multi quota data
upaters vs quota data flusher), it may decrease the probability of
synchronizing quota data successfully in checkpoint() due to limited
retry time of quota flush.

Reported-by: Yi Zhuang <zhuangyi1@huawei.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1144,7 +1144,8 @@ static bool __need_flush_quota(struct f2
 	if (!is_journalled_quota(sbi))
 		return false;
 
-	down_write(&sbi->quota_sem);
+	if (!down_write_trylock(&sbi->quota_sem))
+		return true;
 	if (is_sbi_flag_set(sbi, SBI_QUOTA_SKIP_FLUSH)) {
 		ret = false;
 	} else if (is_sbi_flag_set(sbi, SBI_QUOTA_NEED_REPAIR)) {


