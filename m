Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4790DF54F0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732840AbfKHS5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388647AbfKHS5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:57:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4906821D7E;
        Fri,  8 Nov 2019 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239423;
        bh=ICwTiJJIQe0fmhwbzy+FvXvjoP2i9RnfICTCUkz24yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZ9ac2Rko33tYdRZFKBoeXvkVMQz43fb1qQklGWii500UeW2OKmwjzTGbt2s6OPRF
         wjicJIa5msfTr5bHad89JH0s1g2p1IjyE7XubfY3wpxObOHNipw8l0M9DUBRCJ3P/z
         wf8Vt8ramAIW5SqGicDTzEaUMYLUKePQvpiE1VIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Petr Vorel <pvorel@suse.cz>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9 34/34] alarmtimer: Change remaining ENOTSUPP to EOPNOTSUPP
Date:   Fri,  8 Nov 2019 19:50:41 +0100
Message-Id: <20191108174657.278889084@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <pvorel@suse.cz>

Fix backport of commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.

Update backport to change ENOTSUPP to EOPNOTSUPP in
alarm_timer_{del,set}(), which were removed in
f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1.

Fixes: 65b7a5a36afb11a6769a70308c1ef3a2afae6bf4

Signed-off-by: Petr Vorel <pvorel@suse.cz>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/alarmtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -586,7 +586,7 @@ static void alarm_timer_get(struct k_iti
 static int alarm_timer_del(struct k_itimer *timr)
 {
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
 		return TIMER_RETRY;
@@ -610,7 +610,7 @@ static int alarm_timer_set(struct k_itim
 	ktime_t exp;
 
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;


