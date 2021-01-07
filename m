Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E012ED1B8
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbhAGOQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:16:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728894AbhAGOQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:16:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2EE32335A;
        Thu,  7 Jan 2021 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028955;
        bh=qP+9VmaW6GniQE0oNeVr19yzeSV9DhxRTPBDOSQyBiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqOqbcXOGTdh7o+YMf02bDyxJ15rpZvUYtV/v4azEuPNIWu8OSJvoNYL5exrvlrB+
         roEUbVYozJ8lvAwF06cbrts5PLnNArIJQ6RE44fmnOx/XIOy+3KyUjQQZmPmxkv9+/
         wi5ZiBP4QGcdqqbZIB87dq3J0P/+BT73UQLb9OH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [PATCH 4.4 12/19] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Thu,  7 Jan 2021 15:16:37 +0100
Message-Id: <20210107140828.151735927@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit 31dcb6c30a26d32650ce134820f27de3c675a45a upstream.

A kernel-infoleak was reported by syzbot, which was caused because
dbells was left uninitialized.
Using kzalloc() instead of kmalloc() fixes this issue.

Reported-by: syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com
Tested-by: syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Link: https://lore.kernel.org/r/20201122224534.333471-1-anant.thazhemadam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/vmw_vmci/vmci_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -750,7 +750,7 @@ static int vmci_ctx_get_chkpt_doorbells(
 			return VMCI_ERROR_MORE_DATA;
 		}
 
-		dbells = kmalloc(data_size, GFP_ATOMIC);
+		dbells = kzalloc(data_size, GFP_ATOMIC);
 		if (!dbells)
 			return VMCI_ERROR_NO_MEM;
 


