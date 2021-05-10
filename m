Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3893786F2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhEJLMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235732AbhEJLF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80A3061482;
        Mon, 10 May 2021 10:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644157;
        bh=jcQY+hQeCyRaAiIN0ruuZAsRzx2KPQ2e15Vdb/KsaFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkzRmOc4iZ1PHr6nNNr2hOb2gmGeW2B4mEUV3IWOzMHqVjwiV41V69Tk66ebcL6dE
         yTnkk0fAcphprWkruOFKjaxIDHFXNMeViQNb6k+NmD+U6NB1RiDXuV3hGNnPmrdnOf
         iWGE+HvaoazPDite4A3iX5zfttmDVOu4te/PDA6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Xu Yihang <xuyihang@huawei.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.11 310/342] ext4: fix error return code in ext4_fc_perform_commit()
Date:   Mon, 10 May 2021 12:21:40 +0200
Message-Id: <20210510102020.348824950@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -1093,8 +1093,10 @@ static int ext4_fc_perform_commit(journa
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


