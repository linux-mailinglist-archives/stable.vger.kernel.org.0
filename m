Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC03A2E9A04
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbhADQGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbhADQCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CC4A22516;
        Mon,  4 Jan 2021 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776122;
        bh=xG67Zm/Pub3LnzeGF+mtGQjupBLMb7U8Wk+xH/2uKM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BK5TzQFjrTcO0ttslxfRtZnIlUMKmo2it7YxkdFZeprVVrZaifTFB5M+K9hE0XvSd
         cfoPu439iNBo7QvfgLQilb3SMqhAYN8/VRyzIsluvDEuq9IgdiJGO2QuTwwCMQuW0p
         r9ymzDSCdJsw3kFPHzkF+WcFruKV0ZtJ71c2SId8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [PATCH 5.10 30/63] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Mon,  4 Jan 2021 16:57:23 +0100
Message-Id: <20210104155710.281866429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
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
@@ -743,7 +743,7 @@ static int vmci_ctx_get_chkpt_doorbells(
 			return VMCI_ERROR_MORE_DATA;
 		}
 
-		dbells = kmalloc(data_size, GFP_ATOMIC);
+		dbells = kzalloc(data_size, GFP_ATOMIC);
 		if (!dbells)
 			return VMCI_ERROR_NO_MEM;
 


