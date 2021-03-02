Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D0732AF27
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhCCAPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:45 -0500
Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net ([206.189.21.223]:52035
        "HELO zg8tmja2lje4os4yms4ymjma.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1383767AbhCBMF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 07:05:58 -0500
Received: from pekshcsitd06010.hihonor.com (unknown [198.19.131.39])
        by front-1 (Coremail) with SMTP id CwGowAAXf07LIz5gcsNOAA--.1848S2;
        Tue, 02 Mar 2021 19:38:52 +0800 (CST)
From:   Yunlei He <heyunlei@hihonor.com>
To:     chao@kernel.org, jaegeuk@kernel.org, ebiggers@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, bintian.wang@hihonor.com,
        Yunlei He <heyunlei@hihonor.com>, stable@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: fsverity: modify truncation for verity enable failed
Date:   Tue,  2 Mar 2021 19:38:50 +0800
Message-Id: <20210302113850.17011-1-heyunlei@hihonor.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: CwGowAAXf07LIz5gcsNOAA--.1848S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtw47Xr1UCrW5ur4kGF45ZFb_yoW8JF17pF
        yDGFyUWw1rG3y7Wr1vvF1Uuw1rKFy7KrW2vFyDuw1kW3WkXwnYvayvyFW09a1aqr97Jw40
        qr4UCa9rCr17Ar7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
        XwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAI
        w28IcVCjz48v1sIEY20_XFWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWU
        JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUA8n
        5UUUUU=
X-CM-SenderInfo: pkh130hohlqxxlkr003uof0z/1tbiAQIKEV3ki2sD+gABs5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If file enable verity failed, should truncate anything wrote
past i_size, including cache pages. Move the truncation to
the end of function, in case of f2fs set xattr failed.

Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Yunlei He <heyunlei@hihonor.com>
---
 fs/f2fs/verity.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 054ec852b5ea..610f2a9b4928 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -169,10 +169,6 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 			err = filemap_write_and_wait(inode->i_mapping);
 	}
 
-	/* If we failed, truncate anything we wrote past i_size. */
-	if (desc == NULL || err)
-		f2fs_truncate(inode);
-
 	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
 
 	if (desc != NULL && !err) {
@@ -185,6 +181,13 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 			f2fs_mark_inode_dirty_sync(inode, true);
 		}
 	}
+
+	/* If we failed, truncate anything we wrote past i_size. */
+	if (desc == NULL || err) {
+		truncate_inode_pages(inode->i_mapping, inode->i_size);
+		f2fs_truncate(inode);
+	}
+
 	return err;
 }
 
-- 
2.17.1

