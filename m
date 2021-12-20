Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7114747AFD0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhLTPUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbhLTPSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE57C00FC7C;
        Mon, 20 Dec 2021 06:59:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9067B80EF1;
        Mon, 20 Dec 2021 14:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0307AC36AE8;
        Mon, 20 Dec 2021 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012362;
        bh=7JvV31XUvineH8ApZInp4mX7/HLkDFYdSuKt69tN/Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROokYZOrylZwy3bB7SPHpJLjgaUJ1KQIDpPqF5r2pbSBt91Cxno/JdMvtC8SXxrbf
         DP6A88iRxM4KZsKWJM5OdpK7EF3cHR3YRxQyv7uMgf1vGbuX9bY5JMxXHPfgJ6zHKx
         lVeS2cOicbFvax6BeMT4IeOmJm7VnzCI4NwdNHgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang1.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 141/177] locking/rtmutex: Fix incorrect condition in rtmutex_spin_on_owner()
Date:   Mon, 20 Dec 2021 15:34:51 +0100
Message-Id: <20211220143044.826704005@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

commit 8f556a326c93213927e683fc32bbf5be1b62540a upstream.

Optimistic spinning needs to be terminated when the spinning waiter is not
longer the top waiter on the lock, but the condition is negated. It
terminates if the waiter is the top waiter, which is defeating the whole
purpose.

Fixes: c3123c431447 ("locking/rtmutex: Dont dereference waiter lockless")
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211217074207.77425-1-qiang1.zhang@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1373,7 +1373,7 @@ static bool rtmutex_spin_on_owner(struct
 		 *  - the VCPU on which owner runs is preempted
 		 */
 		if (!owner->on_cpu || need_resched() ||
-		    rt_mutex_waiter_is_top_waiter(lock, waiter) ||
+		    !rt_mutex_waiter_is_top_waiter(lock, waiter) ||
 		    vcpu_is_preempted(task_cpu(owner))) {
 			res = false;
 			break;


