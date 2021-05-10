Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD5C37854D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhEJLAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234055AbhEJKzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41D1A6197C;
        Mon, 10 May 2021 10:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643418;
        bh=SUOhekehMWqrzICfDRCMSIHJvDJWvem14upZemA+pWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYfnl2f6WzAuDzfGxkse1CKXRkINrEJnuQLBiskE+WO3CjslZrv33eMzJt5Wh7DZR
         KsGicIdyVV3paYAeaXwdIyMHqqB5SOggwZz2+AAdfenNm3WuVdI+zSSnp49rEh+ywQ
         49trYob0IicoATwp7+X8PPS+XPIxClG1HpQXzTGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Xu Yihang <xuyihang@huawei.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 270/299] ext4: fix error return code in ext4_fc_perform_commit()
Date:   Mon, 10 May 2021 12:21:07 +0200
Message-Id: <20210510102013.849671585@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yihang <xuyihang@huawei.com>

commit e1262cd2e68a0870fb9fc95eb202d22e8f0074b7 upstream.

In case of if not ext4_fc_add_tlv branch, an error return code is missing.

Cc: stable@kernel.org
Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xu Yihang <xuyihang@huawei.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20210408070033.123047-1-xuyihang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1032,8 +1032,10 @@ static int ext4_fc_perform_commit(journa
 		head.fc_tid = cpu_to_le32(
 			sbi->s_journal->j_running_transaction->t_tid);
 		if (!ext4_fc_add_tlv(sb, EXT4_FC_TAG_HEAD, sizeof(head),
-			(u8 *)&head, &crc))
+			(u8 *)&head, &crc)) {
+			ret = -ENOSPC;
 			goto out;
+		}
 	}
 
 	spin_lock(&sbi->s_fc_lock);


