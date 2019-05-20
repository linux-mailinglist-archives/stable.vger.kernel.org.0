Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115712374D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbfETMX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388715AbfETMXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:23:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E89214AE;
        Mon, 20 May 2019 12:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355035;
        bh=jlAxy7qu2d/sHWB+iguW6FoOguS3pnhmvYhNhR0sF84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzZMDMhwdbCGn6y/+P+OT5Ut5ecQoX+4inE9LTMcDb55zZlYRjWvhODY8dsdJaeoe
         bHetchECRq2sqjomBix9FXQ/DkOG6Zd1Kt+0oC2gPMhZ7JilA1D2w8237Up8cwTByd
         JrYXVuX7UZHwW1jZgN+KRgFHWbfNDmRoG9jV1IjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Debabrata Banerjee <dbanerje@akamai.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 4.19 072/105] ext4: fix ext4_show_options for file systems w/o journal
Date:   Mon, 20 May 2019 14:14:18 +0200
Message-Id: <20190520115252.164850715@linuxfoundation.org>
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

From: Debabrata Banerjee <dbanerje@akamai.com>

commit 50b29d8f033a7c88c5bc011abc2068b1691ab755 upstream.

Instead of removing EXT4_MOUNT_JOURNAL_CHECKSUM from s_def_mount_opt as
I assume was intended, all other options were blown away leading to
_ext4_show_options() output being incorrect.

Fixes: 1e381f60dad9 ("ext4: do not allow journal_opts for fs w/o journal")
Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4270,7 +4270,7 @@ static int ext4_fill_super(struct super_
 				 "data=, fs mounted w/o journal");
 			goto failed_mount_wq;
 		}
-		sbi->s_def_mount_opt &= EXT4_MOUNT_JOURNAL_CHECKSUM;
+		sbi->s_def_mount_opt &= ~EXT4_MOUNT_JOURNAL_CHECKSUM;
 		clear_opt(sb, JOURNAL_CHECKSUM);
 		clear_opt(sb, DATA_FLAGS);
 		sbi->s_journal = NULL;


