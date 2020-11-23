Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893F12C0B89
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgKWN0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:26:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731082AbgKWMc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A508520728;
        Mon, 23 Nov 2020 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134747;
        bh=E1LT5lMp5sUTENxUoH2r6Gvo/RNc/kwo1PUsUpVQOnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8FwKPgUcereFsreDgJ7UFKRKMQJBzaaYA100kcE2wS8ivTZic2HNblh0Lw+GPUIQ
         Q4VA1/NTg5U4F4Sj6XJIu67YLed4y5BXnBXN0Eo9TdLJ1vUmxKxXUCz56jLnUleC4w
         0XjQJ9vJNvqzxSUPaf/Mk5dUFyZa/wXOXUSFu3NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E7=A7=A6=E4=B8=96=E6=9D=BE?= <qinshisong1205@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 4.19 66/91] speakup: Do not let the line discipline be used several times
Date:   Mon, 23 Nov 2020 13:22:26 +0100
Message-Id: <20201123121812.529516001@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit d4122754442799187d5d537a9c039a49a67e57f1 upstream.

Speakup has only one speakup_tty variable to store the tty it is managing. This
makes sense since its codebase currently assumes that there is only one user who
controls the screen reading.

That however means that we have to forbid using the line discipline several
times, otherwise the second closure would try to free a NULL ldisc_data, leading to

general protection fault: 0000 [#1] SMP KASAN PTI
RIP: 0010:spk_ttyio_ldisc_close+0x2c/0x60
Call Trace:
 tty_ldisc_release+0xa2/0x340
 tty_release_struct+0x17/0xd0
 tty_release+0x9d9/0xcc0
 __fput+0x231/0x740
 task_work_run+0x12c/0x1a0
 do_exit+0x9b5/0x2230
 ? release_task+0x1240/0x1240
 ? __do_page_fault+0x562/0xa30
 do_group_exit+0xd5/0x2a0
 __x64_sys_exit_group+0x35/0x40
 do_syscall_64+0x89/0x2b0
 ? page_fault+0x8/0x30
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Cc: stable@vger.kernel.org
Reported-by: 秦世松 <qinshisong1205@gmail.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Tested-by: Shisong Qin <qinshisong1205@gmail.com>
Link: https://lore.kernel.org/r/20201110183541.fzgnlwhjpgqzjeth@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/spk_ttyio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/staging/speakup/spk_ttyio.c
+++ b/drivers/staging/speakup/spk_ttyio.c
@@ -49,15 +49,25 @@ static int spk_ttyio_ldisc_open(struct t
 
 	if (tty->ops->write == NULL)
 		return -EOPNOTSUPP;
+
+	mutex_lock(&speakup_tty_mutex);
+	if (speakup_tty) {
+		mutex_unlock(&speakup_tty_mutex);
+		return -EBUSY;
+	}
 	speakup_tty = tty;
 
 	ldisc_data = kmalloc(sizeof(struct spk_ldisc_data), GFP_KERNEL);
-	if (!ldisc_data)
+	if (!ldisc_data) {
+		speakup_tty = NULL;
+		mutex_unlock(&speakup_tty_mutex);
 		return -ENOMEM;
+	}
 
 	sema_init(&ldisc_data->sem, 0);
 	ldisc_data->buf_free = true;
 	speakup_tty->disc_data = ldisc_data;
+	mutex_unlock(&speakup_tty_mutex);
 
 	return 0;
 }


