Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74B335408D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbhDEJSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239986AbhDEJSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:18:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A659061387;
        Mon,  5 Apr 2021 09:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614302;
        bh=UKghFny69coTffHjMIZPzcbMA/FSap3044jk8omocHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izu8vLK/nq7ObRSObe5LE/t7weaR9F5m1CNa7qq4knKUeJbww5T3D0PlcJiajig0W
         O/m7JkGidgBnTNb0AlGkFRpJ9scYEkuaCgRPf8Rxn9aPL5Pjyv6Y7dd3MWlgSFonkK
         q/C5FtwprpNbYRClKkx0VBd+aXjoKbZRL9PGfIi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 151/152] Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"
Date:   Mon,  5 Apr 2021 10:55:00 +0200
Message-Id: <20210405085039.119165942@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
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


