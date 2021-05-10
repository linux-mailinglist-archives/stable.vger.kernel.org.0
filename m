Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92091378532
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhEJK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhEJKzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32E2061C25;
        Mon, 10 May 2021 10:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643369;
        bh=5tR5IpQs+z9kEAOU5POh1Sr9kQA/z9dSZJFgHXH2P10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejFtPkBOcFrNDb06UForly0k9GJ5n3etcBdb5Mq69ZJBfJK37IUWB5OvoOzbaxX8F
         +Xe6KmZmPtUwaXDYAuIyps0xoxc/y4WoXG/4ipldAPABfGnkFPjRvw9pBtjUG0sp+w
         LEfV/+2qsOHna42/RkcMwcdCC5q+FkQPusdYchc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bcc922b19ccc64240b42@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 5.10 288/299] tty: fix memory leak in vc_deallocate
Date:   Mon, 10 May 2021 12:21:25 +0200
Message-Id: <20210510102014.429410247@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

commit 211b4d42b70f1c1660feaa968dac0efc2a96ac4d upstream.

syzbot reported memory leak in tty/vt.
The problem was in VT_DISALLOCATE ioctl cmd.
After allocating unimap with PIO_UNIMAP it wasn't
freed via VT_DISALLOCATE, but vc_cons[currcons].d was
zeroed.

Reported-by: syzbot+bcc922b19ccc64240b42@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210327214443.21548-1-paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1382,6 +1382,7 @@ struct vc_data *vc_deallocate(unsigned i
 		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
 		vcs_remove_sysfs(currcons);
 		visual_deinit(vc);
+		con_free_unimap(vc);
 		put_pid(vc->vt_pid);
 		vc_uniscr_set(vc, NULL);
 		kfree(vc->vc_screenbuf);


