Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97746344327
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhCVMsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230423AbhCVMqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:46:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D5876191A;
        Mon, 22 Mar 2021 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416955;
        bh=6qDsWRdDrEprk/lwWGwSYooI02SaMRqvmo6OHwXlbKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1MqxZnqtA84FOn2MvbznXqjLkAckqBITCmiqth/xIa3Ul4jcOYS3dDuemmvuqpV2
         +Rk5sbR755Iyjk4MNqU8sQoIoVAUASdNpWAcutG7KE1BY1dj0w6zKwkXd4x7Nw2gI9
         dajhUNcWrxSbCnEDwDtwWNuygetV476Bp/HL3WAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabine Forkel <sabine.forkel@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: [PATCH 5.4 08/60] s390/vtime: fix increased steal time accounting
Date:   Mon, 22 Mar 2021 13:27:56 +0100
Message-Id: <20210322121922.651893197@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit d54cb7d54877d529bc1e0e1f47a3dd082f73add3 upstream.

Commit 152e9b8676c6e ("s390/vtime: steal time exponential moving average")
inadvertently changed the input value for account_steal_time() from
"cputime_to_nsecs(steal)" to just "steal", resulting in broken increased
steal time accounting.

Fix this by changing it back to "cputime_to_nsecs(steal)".

Fixes: 152e9b8676c6e ("s390/vtime: steal time exponential moving average")
Cc: <stable@vger.kernel.org> # 5.1
Reported-by: Sabine Forkel <sabine.forkel@de.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/vtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -217,7 +217,7 @@ void vtime_flush(struct task_struct *tsk
 	avg_steal = S390_lowcore.avg_steal_timer / 2;
 	if ((s64) steal > 0) {
 		S390_lowcore.steal_timer = 0;
-		account_steal_time(steal);
+		account_steal_time(cputime_to_nsecs(steal));
 		avg_steal += steal;
 	}
 	S390_lowcore.avg_steal_timer = avg_steal;


