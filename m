Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078FF2E9A83
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbhADQKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbhADQAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DA7420769;
        Mon,  4 Jan 2021 16:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776004;
        bh=xG67Zm/Pub3LnzeGF+mtGQjupBLMb7U8Wk+xH/2uKM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUOy3qTYNPGEb+VAq0Fmk/TATkJN8S72sIjUghFaYAIV6zamqMPeRfd7jJoAHFfbS
         Ipc2vE3oGWSgHKHHsvKtMJ/uy0RijnQss/3qnivS6zG1Sa/PcQweIQb3CUVt8/lOMS
         IhKhON1R+PwYzc6uZjIdL/giEYAx6IjGOBtyWHGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [PATCH 5.4 27/47] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Mon,  4 Jan 2021 16:57:26 +0100
Message-Id: <20210104155707.054036333@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
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
 


