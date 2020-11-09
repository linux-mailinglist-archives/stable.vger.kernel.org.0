Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A802ABB84
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgKINJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgKINJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 820922076E;
        Mon,  9 Nov 2020 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927385;
        bh=0m6LVC/aGVjlg2KwcuEXF3GYxu+3hQsMRs9RZzPMy8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiuads/TT0zaXhspanV7IZod8D+KpIrCpruSu4BdbzoNJp32frMNUqSSYffCMr0eR
         afi66/z0BL6wwhCEzSniBtk8xQ/FOezVRdiTy9/O3ulyMIlp9NrI3/yB/wgJ3YoErd
         vpV6TSHpV+atGcD7zntjmpuzcrGueenpZB08mwAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 42/71] ftrace: Fix recursion check for NMI test
Date:   Mon,  9 Nov 2020 13:55:36 +0100
Message-Id: <20201109125021.883110542@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit ee11b93f95eabdf8198edd4668bf9102e7248270 upstream.

The code that checks recursion will work to only do the recursion check once
if there's nested checks. The top one will do the check, the other nested
checks will see recursion was already checked and return zero for its "bit".
On the return side, nothing will be done if the "bit" is zero.

The problem is that zero is returned for the "good" bit when in NMI context.
This will set the bit for NMIs making it look like *all* NMI tracing is
recursing, and prevent tracing of anything in NMI context!

The simple fix is to return "bit + 1" and subtract that bit on the end to
get the real bit.

Cc: stable@vger.kernel.org
Fixes: edc15cafcbfa3 ("tracing: Avoid unnecessary multiple recursion checks")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -595,7 +595,7 @@ static __always_inline int trace_test_an
 	current->trace_recursion = val;
 	barrier();
 
-	return bit;
+	return bit + 1;
 }
 
 static __always_inline void trace_clear_recursion(int bit)
@@ -605,6 +605,7 @@ static __always_inline void trace_clear_
 	if (!bit)
 		return;
 
+	bit--;
 	bit = 1 << bit;
 	val &= ~bit;
 


