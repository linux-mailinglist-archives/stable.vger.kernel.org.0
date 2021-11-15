Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE384525B7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhKPB5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239338AbhKOSOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:14:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA47633DE;
        Mon, 15 Nov 2021 17:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998576;
        bh=5dY26stGzssEDVsXBZRXTULPoknLwBQkpiVg/rsA0y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6TXA9n8Xu7Nwqujwg2vNdw36tKSOPd+9S5MGxK23HxaQY2IlfrBDVFiMKSXOLQFH
         I6zvOOSTJwtpriNQpwq2Y/iV8u+W/NAazXjMdW6DKMyNQoiwV+l5QcHW8+n/dsVUa5
         y5obk7NeUz8CFw5jC6XS0gknXZ8nu6qWUPbv18Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 559/575] s390/tape: fix timer initialization in tape_std_assign()
Date:   Mon, 15 Nov 2021 18:04:44 +0100
Message-Id: <20211115165403.026152083@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 213fca9e23b59581c573d558aa477556f00b8198 upstream.

commit 9c6c273aa424 ("timer: Remove init_timer_on_stack() in favor
of timer_setup_on_stack()") changed the timer setup from
init_timer_on_stack(() to timer_setup(), but missed to change the
mod_timer() call. And while at it, use msecs_to_jiffies() instead
of the open coded timeout calculation.

Cc: stable@vger.kernel.org
Fixes: 9c6c273aa424 ("timer: Remove init_timer_on_stack() in favor of timer_setup_on_stack()")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/tape_std.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/char/tape_std.c
+++ b/drivers/s390/char/tape_std.c
@@ -53,7 +53,6 @@ int
 tape_std_assign(struct tape_device *device)
 {
 	int                  rc;
-	struct timer_list    timeout;
 	struct tape_request *request;
 
 	request = tape_alloc_request(2, 11);
@@ -70,7 +69,7 @@ tape_std_assign(struct tape_device *devi
 	 * So we set up a timeout for this call.
 	 */
 	timer_setup(&request->timer, tape_std_assign_timeout, 0);
-	mod_timer(&timeout, jiffies + 2 * HZ);
+	mod_timer(&request->timer, jiffies + msecs_to_jiffies(2000));
 
 	rc = tape_do_io_interruptible(device, request);
 


