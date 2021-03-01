Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98099328F61
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242051AbhCATuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241586AbhCATlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:41:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CCD765093;
        Mon,  1 Mar 2021 17:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619930;
        bh=xwrO+w3ZIPjWd2FnVLrp7D7sadqK46TWOatqAUOY0VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0sM7E7CygHpzZa1tvpu2QPZBpFpNcNBfUQKoqkzXOX8sSNO6yEW2IXmVxPbKTZ4z
         eAMXgX/7bnsgr/uHCCGFwfqVzxIsnYVQCidOqjZjwz0sAxEzmNc6MGjA/bAR+kytop
         pfNwL3ll3kkUTcs8RKZ1xAO8csR5WM8+UIzTwl90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 633/663] f2fs: flush data when enabling checkpoint back
Date:   Mon,  1 Mar 2021 17:14:41 +0100
Message-Id: <20210301161213.174386108@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit b0ff4fe746fd028eef920ddc8c7b0361c1ede6ec upstream.

During checkpoint=disable period, f2fs bypasses all the synchronous IOs such as
sync and fsync. So, when enabling it back, we must flush all of them in order
to keep the data persistent. Otherwise, suddern power-cut right after enabling
checkpoint will cause data loss.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1764,6 +1764,9 @@ restore_flag:
 
 static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
+	/* we should flush all the data to keep data consistency */
+	sync_inodes_sb(sbi->sb);
+
 	down_write(&sbi->gc_lock);
 	f2fs_dirty_to_prefree(sbi);
 


