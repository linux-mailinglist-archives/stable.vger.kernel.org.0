Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4C7461DE4
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353890AbhK2Sa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:30:27 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49152 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354520AbhK2S21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:28:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBF54CE13D5;
        Mon, 29 Nov 2021 18:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AFFC5831B;
        Mon, 29 Nov 2021 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210306;
        bh=o5vpV34eCXQXdqm9nhvkUPoDvY9nr58m/v1DWqAcaeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1L87xdCgTH9wE/XJ3NxrCYANxWa8U5XQ3NXDMFZ0ie4B1TZlBHo5Rm1xOFeeF+lw
         QN54Gq7CJzDj0lhGF5FaybtJHY+NQ17JvNuLKoaa68gGj5u7O2IbQ49+Z8p6ggGiT3
         rFolBRYtf70iAa4hKCvjECtToxp3FAYp+WsiFeWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 09/92] binder: fix test regression due to sender_euid change
Date:   Mon, 29 Nov 2021 19:17:38 +0100
Message-Id: <20211129181707.726543812@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit c21a80ca0684ec2910344d72556c816cb8940c01 upstream.

This is a partial revert of commit
29bc22ac5e5b ("binder: use euid from cred instead of using task").
Setting sender_euid using proc->cred caused some Android system test
regressions that need further investigation. It is a partial
reversion because subsequent patches rely on proc->cred.

Fixes: 29bc22ac5e5b ("binder: use euid from cred instead of using task")
Cc: stable@vger.kernel.org # 4.4+
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Change-Id: I9b1769a3510fed250bb21859ef8beebabe034c66
Link: https://lore.kernel.org/r/20211112180720.2858135-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3095,7 +3095,7 @@ static void binder_transaction(struct bi
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = proc->cred->euid;
+	t->sender_euid = task_euid(proc->tsk);
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;


