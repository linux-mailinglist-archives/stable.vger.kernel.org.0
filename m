Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2797E304A99
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbhAZFDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:03:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731022AbhAYSwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 410B22310A;
        Mon, 25 Jan 2021 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600723;
        bh=HFYo4Y1Q2p1Oup6eWHfaH/2RgWK7eKYtOYYJiw4sHto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygXkb069ApeDNEej/HQ50Ml8bvvCFY/T3MGEZRPoVgMsXIp0rqtfsc2vAoHmnh0mc
         RmiVjxxpAHQqNxSQgy5nu4eAdQl2ePf/3jxHaxF/z0XnrfpJf+KiIHYdL7nrRz6TVJ
         g7i5hdFhiQoc1K0kfPe4E3LEH6G4YWGdQiy+xcyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/199] printk: fix kmsg_dump_get_buffer length calulations
Date:   Mon, 25 Jan 2021 19:38:38 +0100
Message-Id: <20210125183220.331125049@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 89ccf18f032f26946e2ea6258120472eec6aa745 ]

kmsg_dump_get_buffer() uses @syslog to determine if the syslog
prefix should be written to the buffer. However, when calculating
the maximum number of records that can fit into the buffer, it
always counts the bytes from the syslog prefix.

Use @syslog when calculating the maximum number of records that can
fit into the buffer.

Fixes: e2ae715d66bf ("kmsg - kmsg_dump() use iterator to receive log buffer content")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210113164413.1599-1-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3376,7 +3376,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	while (prb_read_valid_info(prb, seq, &info, &line_count)) {
 		if (r.info->seq >= dumper->next_seq)
 			break;
-		l += get_record_print_text_size(&info, line_count, true, time);
+		l += get_record_print_text_size(&info, line_count, syslog, time);
 		seq = r.info->seq + 1;
 	}
 
@@ -3386,7 +3386,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 						&info, &line_count)) {
 		if (r.info->seq >= dumper->next_seq)
 			break;
-		l -= get_record_print_text_size(&info, line_count, true, time);
+		l -= get_record_print_text_size(&info, line_count, syslog, time);
 		seq = r.info->seq + 1;
 	}
 


