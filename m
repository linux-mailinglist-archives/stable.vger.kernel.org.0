Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B3A29BC06
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368706AbgJ0Qaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802636AbgJ0Pug (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:50:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A563204EF;
        Tue, 27 Oct 2020 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813835;
        bh=rajoBg90m9v2veNuegkxxzBLUEQ6nFdodXsoaaQtBF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJqBG2DbpMEbRnSASoLS/TvkCnchi9Q4pewt4gOy3GJy8BhTOVUCDxr+CbWjFc9C/
         ng1FPb59CgvTAkCLFl6DF2Ah2TI0ulQ5oEzLIQZA+qV8BVFO1BXsSx4Fpy8C4Dqu8c
         yQzavBohYKQ7+TixcEcdSec4Tz4QrJFzcki501/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9991561e714f597095da@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 687/757] udf: Limit sparing table size
Date:   Tue, 27 Oct 2020 14:55:37 +0100
Message-Id: <20201027135522.754187717@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 44ac6b829c4e173fdf6df18e6dd86aecf9a3dc99 ]

Although UDF standard allows it, we don't support sparing table larger
than a single block. Check it during mount so that we don't try to
access memory beyond end of buffer.

Reported-by: syzbot+9991561e714f597095da@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 1c42f544096d8..a03b8ce5ef0fd 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1353,6 +1353,12 @@ static int udf_load_sparable_map(struct super_block *sb,
 			(int)spm->numSparingTables);
 		return -EIO;
 	}
+	if (le32_to_cpu(spm->sizeSparingTable) > sb->s_blocksize) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Too big sparing table size (%u)\n",
+			le32_to_cpu(spm->sizeSparingTable));
+		return -EIO;
+	}
 
 	for (i = 0; i < spm->numSparingTables; i++) {
 		loc = le32_to_cpu(spm->locSparingTable[i]);
-- 
2.25.1



