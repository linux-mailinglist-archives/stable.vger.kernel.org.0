Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050C02D626A
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgLJQsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391099AbgLJOhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:42 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Avila" <elavila@google.com>,
        Daniel Mentz <danielmentz@google.com>,
        Will McVicker <willmcvicker@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 17/75] ring-buffer: Update write stamp with the correct ts
Date:   Thu, 10 Dec 2020 15:26:42 +0100
Message-Id: <20201210142606.911077398@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 55ea4cf403800af2ce6b125bc3d853117e0c0456 upstream.

The write stamp, used to calculate deltas between events, was updated with
the stale "ts" value in the "info" structure, and not with the updated "ts"
variable. This caused the deltas between events to be inaccurate, and when
crossing into a new sub buffer, had time go backwards.

Link: https://lkml.kernel.org/r/20201124223917.795844-1-elavila@google.com

Cc: stable@vger.kernel.org
Fixes: a389d86f7fd09 ("ring-buffer: Have nested events still record running time stamp")
Reported-by: "J. Avila" <elavila@google.com>
Tested-by: Daniel Mentz <danielmentz@google.com>
Tested-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3291,7 +3291,7 @@ __rb_reserve_next(struct ring_buffer_per
 			/* Nothing came after this event between C and E */
 			info->delta = ts - info->after;
 			(void)rb_time_cmpxchg(&cpu_buffer->write_stamp,
-					      info->after, info->ts);
+					      info->after, ts);
 			info->ts = ts;
 		} else {
 			/*


