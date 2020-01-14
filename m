Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED48C13A57E
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgANKIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbgANKIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:08:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7417C2467D;
        Tue, 14 Jan 2020 10:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996489;
        bh=4BXyphWGIi64QsKJpkaEKqah5x13QFTr6FzjuvcO7bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wot9GptdxiR7eg/tV9iY/8j/i5cFki3QQKv1tbt2VPB9g9w7SCuQGLn1clrm+v2Hy
         BGT8lluQK3yoYYzIdhp1xVUYZXLUvE73pZW2rCzaO7uLL7Hv6SPocSr4qdZTrnzvGu
         +dmfr3BiH3oBPjucvJzeVKVuwPswJ57q1aOmRRcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        David Sterba <dsterba@suse.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 10/46] tracing: Change offset type to s32 in preempt/irq tracepoints
Date:   Tue, 14 Jan 2020 11:01:27 +0100
Message-Id: <20200114094342.583498138@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Fernandes (Google) <joel@joelfernandes.org>

commit bf44f488e168368cae4139b4b33c3d0aaa11679c upstream.

Discussion in the below link reported that symbols in modules can appear
to be before _stext on ARM architecture, causing wrapping with the
offsets of this tracepoint. Change the offset type to s32 to fix this.

Link: http://lore.kernel.org/r/20191127154428.191095-1-antonio.borneo@st.com
Link: http://lkml.kernel.org/r/20200102194625.226436-1-joel@joelfernandes.org

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Antonio Borneo <antonio.borneo@st.com>
Cc: stable@vger.kernel.org
Fixes: d59158162e032 ("tracing: Add support for preempt and irq enable/disable events")
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/preemptirq.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/trace/events/preemptirq.h
+++ b/include/trace/events/preemptirq.h
@@ -18,13 +18,13 @@ DECLARE_EVENT_CLASS(preemptirq_template,
 	TP_ARGS(ip, parent_ip),
 
 	TP_STRUCT__entry(
-		__field(u32, caller_offs)
-		__field(u32, parent_offs)
+		__field(s32, caller_offs)
+		__field(s32, parent_offs)
 	),
 
 	TP_fast_assign(
-		__entry->caller_offs = (u32)(ip - (unsigned long)_stext);
-		__entry->parent_offs = (u32)(parent_ip - (unsigned long)_stext);
+		__entry->caller_offs = (s32)(ip - (unsigned long)_stext);
+		__entry->parent_offs = (s32)(parent_ip - (unsigned long)_stext);
 	),
 
 	TP_printk("caller=%pF parent=%pF",


