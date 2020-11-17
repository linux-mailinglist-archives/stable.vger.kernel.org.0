Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6552B60C8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgKQNMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:12:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbgKQNMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:12:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A2DC221EB;
        Tue, 17 Nov 2020 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618757;
        bh=Rc/JonjrewJk/D4i9150/6CuZjdpzXuSw8qk+z9fRnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYysMFPonxdlGREvMXI0TWFyISccMR6U33BZxlmHwnV1qH54O204vH1HwYJZbrXpF
         rrq1PeK3HVpAo2EDRfzjeb26BcGfAFejwCh6Qgc5+iyzaQ0K09bladzvcrSCuH2M+s
         Z+AY7FkQPAdq5K7gi+PGJyqTRUyWD752gBrA/sy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 77/78] ext4: fix leaking sysfs kobject after failed mount
Date:   Tue, 17 Nov 2020 14:05:43 +0100
Message-Id: <20201117122112.857600137@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit cb8d53d2c97369029cc638c9274ac7be0a316c75 upstream.

ext4_unregister_sysfs() only deletes the kobject.  The reference to it
needs to be put separately, like ext4_put_super() does.

This addresses the syzbot report
"memory leak in kobject_set_name_vargs (3)"
(https://syzkaller.appspot.com/bug?extid=9f864abad79fae7c17e1).

Reported-by: syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Fixes: 72ba74508b28 ("ext4: release sysfs kobject when failing to enable quotas on mount")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20200922162456.93657-1-ebiggers@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4336,6 +4336,7 @@ cantfind_ext4:
 #ifdef CONFIG_QUOTA
 failed_mount8:
 	ext4_unregister_sysfs(sb);
+	kobject_put(&sbi->s_kobj);
 #endif
 failed_mount7:
 	ext4_unregister_li_request(sb);


