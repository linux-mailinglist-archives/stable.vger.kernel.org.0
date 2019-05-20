Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD312358A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391141AbfETMfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391134AbfETMfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:35:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB07216C4;
        Mon, 20 May 2019 12:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355746;
        bh=K54YEflfXLM4VSAwoRJKIcxe1vnu5XR84RhZ3XiT9mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pd/ru7MOdaff/XZpHmvlYNr4zQ8NG5ySum6F9qkbC8R+zQYtm4//sfHYCQc5V4d00
         tMlKYMacdxeeICW+uU3maOwDsyIeiu+cqTf8qCHQ1+M6dL8fnuNjCd+Cpb+qmvvcD7
         JvTLriTdVEHjgF4KTNOY1b86Le2fi2NL6Q15O9q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.1 110/128] ext4: avoid panic during forced reboot due to aborted journal
Date:   Mon, 20 May 2019 14:14:57 +0200
Message-Id: <20190520115256.395873801@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
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


