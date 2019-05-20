Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6DC23689
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388952AbfETMY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388944AbfETMYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D35BD216C4;
        Mon, 20 May 2019 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355095;
        bh=K54YEflfXLM4VSAwoRJKIcxe1vnu5XR84RhZ3XiT9mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1GyGmAQqqEgDqvBO6k9qyh1oNIjmZqSeJC9cY8Z35KTUYhQV7pveaim99qcLG8sC
         ENTexBSk8NUzE9vXaLySJdTE2v5GsmC+ylFnuAu9Hz1PjRMOiA6X1f1odcd62gG5T8
         P8962vE1UPbr5dFK8uhSo+V7d98SE3Hu1lUqOsk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 088/105] ext4: avoid panic during forced reboot due to aborted journal
Date:   Mon, 20 May 2019 14:14:34 +0200
Message-Id: <20190520115253.365916423@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 2c1d0e3631e5732dba98ef49ac0bec1388776793 upstream.

Handling of aborted journal is a special code path different from
standard ext4_error() one and it can call panic() as well. Commit
1dc1097ff60e ("ext4: avoid panic during forced reboot") forgot to update
this path so fix that omission.

Fixes: 1dc1097ff60e ("ext4: avoid panic during forced reboot")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org # 5.1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -698,7 +698,7 @@ void __ext4_abort(struct super_block *sb
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 		save_error_info(sb, function, line);
 	}
-	if (test_opt(sb, ERRORS_PANIC)) {
+	if (test_opt(sb, ERRORS_PANIC) && !system_going_down()) {
 		if (EXT4_SB(sb)->s_journal &&
 		  !(EXT4_SB(sb)->s_journal->j_flags & JBD2_REC_ERR))
 			return;


