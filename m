Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F63D330E4D
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhCHMg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhCHMgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65960651DC;
        Mon,  8 Mar 2021 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206972;
        bh=EWzwz2GmaVBck9PZXb2/AsyVlGpDlYAdurS7mXcShSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8sZAQrp/C4Es6I3bcLTF3tMV06O3A5Smk0VoaziwUGmkAX+BUX5+CxFgxp+J0sOl
         WohKsrQRV2YmCzq/B0/Z9w9DaFsXFFuQhB0T0brJ2ZiAMzLl2gylhg2AYOhVQ4r4Rm
         PvIuw/98esAyq+5kWqi1dA/w9214HP1Lbx9CHPII=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.11 21/44] ring-buffer: Force before_stamp and write_stamp to be different on discard
Date:   Mon,  8 Mar 2021 13:34:59 +0100
Message-Id: <20210308122719.623419315@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 6f6be606e763f2da9fc21de00538c97fe4ca1492 upstream.

Part of the logic of the new time stamp code depends on the before_stamp and
the write_stamp to be different if the write_stamp does not match the last
event on the buffer, as it will be used to calculate the delta of the next
event written on the buffer.

The discard logic depends on this, as the next event to come in needs to
inject a full timestamp as it can not rely on the last event timestamp in
the buffer because it is unknown due to events after it being discarded. But
by changing the write_stamp back to the time before it, it forces the next
event to use a full time stamp, instead of relying on it.

The issue came when a full time stamp was used for the event, and
rb_time_delta() returns zero in that case. The update to the write_stamp
(which subtracts delta) made it not change. Then when the event is removed
from the buffer, because the before_stamp and write_stamp still match, the
next event written would calculate its delta from the write_stamp, but that
would be wrong as the write_stamp is of the time of the event that was
discarded.

In the case that the delta change being made to write_stamp is zero, set the
before_stamp to zero as well, and this will force the next event to inject a
full timestamp and not use the current write_stamp.

Cc: stable@vger.kernel.org
Fixes: a389d86f7fd09 ("ring-buffer: Have nested events still record running time stamp")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2822,6 +2822,17 @@ rb_try_to_discard(struct ring_buffer_per
 			return 0;
 
 		/*
+		 * It's possible that the event time delta is zero
+		 * (has the same time stamp as the previous event)
+		 * in which case write_stamp and before_stamp could
+		 * be the same. In such a case, force before_stamp
+		 * to be different than write_stamp. It doesn't
+		 * matter what it is, as long as its different.
+		 */
+		if (!delta)
+			rb_time_set(&cpu_buffer->before_stamp, 0);
+
+		/*
 		 * If an event were to come in now, it would see that the
 		 * write_stamp and the before_stamp are different, and assume
 		 * that this event just added itself before updating


