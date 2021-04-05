Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366D6353F68
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbhDEJL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238892AbhDEJLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE130613A7;
        Mon,  5 Apr 2021 09:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613875;
        bh=UKghFny69coTffHjMIZPzcbMA/FSap3044jk8omocHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QH27VaWGDSskJ0Jo819ye5uG+nz/ykHSxy4mS4U0MPXQWnbu+MQE2yJaWaB8buAp+
         X7cyIQUBZrzrFwL69fzTw+9/69xc9TuQARO3vBFBy6VBoGWJ1MLW+DrYHo63WHDmY4
         X2A8WDGmqR0c8IsTw6V0p7u6kRI2LGc8Mbm6hrlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 125/126] Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"
Date:   Mon,  5 Apr 2021 10:54:47 +0200
Message-Id: <20210405085035.165900931@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit d3dc04cd81e0eaf50b2d09ab051a13300e587439 upstream.

This reverts commit 15b2219facadec583c24523eed40fa45865f859f.

Before IO threads accepted signals, the freezer using take signals to wake
up an IO thread would cause them to loop without any way to clear the
pending signal. That is no longer the case, so stop special casing
PF_IO_WORKER in the freezer.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/freezer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
 		return false;
 	}
 
-	if (!(p->flags & (PF_KTHREAD | PF_IO_WORKER)))
+	if (!(p->flags & PF_KTHREAD))
 		fake_signal_wake_up(p);
 	else
 		wake_up_state(p, TASK_INTERRUPTIBLE);


