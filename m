Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC8F469A53
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345621AbhLFPHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345708AbhLFPEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:04:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAA5C061354;
        Mon,  6 Dec 2021 07:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E93761322;
        Mon,  6 Dec 2021 15:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D33AC341C2;
        Mon,  6 Dec 2021 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802881;
        bh=rzhNHhs1j2g0urBtPmF4JNDjLmj+5T+5w+5qmfRitvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdrRfxTmQaDlE3Pc8etuloK261umfIt6Yf5UgcMnFp0p5DtmnDVyPvTq0rn3ySSTR
         H1ZOZCkBL+GNaQD/YN3giF/ugES9DA8dEh4WQwiX/dHkxPHOUq0FB27y2K6Envs+ww
         30aUdpo3HCYCM3oAwblMH0uKlTdeYeX3oA4MezcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 4.9 06/62] binder: fix test regression due to sender_euid change
Date:   Mon,  6 Dec 2021 15:55:49 +0100
Message-Id: <20211206145549.378566976@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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
@@ -1506,7 +1506,7 @@ static void binder_transaction(struct bi
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = proc->cred->euid;
+	t->sender_euid = task_euid(proc->tsk);
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;


