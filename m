Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88509469FDB
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387841AbhLFPyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:54:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55386 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392397AbhLFPv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:51:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 994D3B81018;
        Mon,  6 Dec 2021 15:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C919FC34902;
        Mon,  6 Dec 2021 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638805676;
        bh=StwSQ/ixdmlyaHNpzLmIWNf2DQBv+rVnwKA9+3gkeEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlRRjyW5XaIoHE2C+6pvw+M5Vdz3KTH6W57UM4mTNSxLKgmIg9aGbK4/zQ4zF2A48
         EMGqq6CpRdgQCI5Tk9FheFbU4P3WM/uzK33bTYjPMPmv2zJAOYGWutQN72sAL9UhBb
         3uimk20+2h2jgRvahu9eWmZr02964gx24dWdv/ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@vgerk.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 084/207] tracing/histograms: String compares should not care about signed values
Date:   Mon,  6 Dec 2021 15:55:38 +0100
Message-Id: <20211206145613.150086990@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 450fec13d9170127678f991698ac1a5b05c02e2f upstream.

When comparing two strings for the "onmatch" histogram trigger, fields
that are strings use string comparisons, which do not care about being
signed or not.

Do not fail to match two string fields if one is unsigned char array and
the other is a signed char array.

Link: https://lore.kernel.org/all/20211129123043.5cfd687a@gandalf.local.home/

Cc: stable@vgerk.kernel.org
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>
Fixes: b05e89ae7cf3b ("tracing: Accept different type for synthetic event fields")
Reviewed-by: Masami Hiramatsu <mhiramatsu@kernel.org>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3419,7 +3419,7 @@ static int check_synth_field(struct synt
 
 	if (strcmp(field->type, hist_field->type) != 0) {
 		if (field->size != hist_field->size ||
-		    field->is_signed != hist_field->is_signed)
+		    (!field->is_string && field->is_signed != hist_field->is_signed))
 			return -EINVAL;
 	}
 


