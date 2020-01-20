Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1950B14300A
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgATQgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:36:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35774 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATQgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:36:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so263549wmb.0
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 08:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZQ41aSscokjE3ibV0EnvsVz0h1A1sDwJhOP8lk8kXi0=;
        b=rqt8EwnjKclQe3LBMnUCZTBWpfiO1hbrdSehxM8zoJ0Wdu1O7EilzOvqAnD26vVUlK
         NRNjWQeP4I8l105kT3oHZ3ouuNMGBilJ+lJB/GFH2QFnXlkv9ZL/shRC1XISgomjTj5e
         ykLb/0gTPTUp2YI6zF13SBnekN8XeLDnNt+3UZYCEcxkCNOo3FdlkWc1PtM9QKRcIUfG
         5n31pEU0YI824R38RSTKxmUvi98pB5iMoveRm0xib6f+5zje2/cutKGEHApBrBjBBH2A
         846O8rl+xJdyY3H0oecweYVmZe+PFqrlhTMFanDbDYNFjyaxSZi8c9FzzcvonilfSkS+
         g5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZQ41aSscokjE3ibV0EnvsVz0h1A1sDwJhOP8lk8kXi0=;
        b=VmOCD8RlPfyN2UwYcDye4ThRYmJfXvf/qcRJgT33cIbR65p1aMBi43m+pPY5jcl2JY
         CB5FgZikSsroRUuJeAUqUpfUiIDUMGR5D7g4CB6196kaCwFkz8E5VXBzwWg7JiK2Tz1T
         OP94+uvFXZFXrg/SYUWnJ8QHB9exQhek4jCu1RDWWOqoPRbjS6SxTRXQ55d9Co3EK8FW
         uZ0oYKV0YLuRx3nw8G51K8mUXvHPkYIix7yP4rtzhS62bSPn+h2FLUwnaRiv++ypOQPz
         wd/I/CdTxmCpMAjMA+aF/f1QOHplbO+olYGAQXSp6XZXA/AMc+jlNXIOvkWi8RoUMr/+
         rAFQ==
X-Gm-Message-State: APjAAAXjW/xsYnm/EtVLCBPE3LhQFy8OZhlRtMu9bkgWSB2S2jVoc206
        05MMRK0BHhC9gy5yms/szA==
X-Google-Smtp-Source: APXvYqwFxwJd+Wr4ODNxNoVCGJTp6dWp9oqH2wjWHuVfb8ec732TyFQcGm5eRxnx8iXhztqxh0ZCTg==
X-Received: by 2002:a05:600c:1007:: with SMTP id c7mr193918wmc.158.1579538201876;
        Mon, 20 Jan 2020 08:36:41 -0800 (PST)
Received: from ninjahub.org ([91.235.65.22])
        by smtp.googlemail.com with ESMTPSA id x7sm47089018wrq.41.2020.01.20.08.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:36:41 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     jbi.octave@gmail.com
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Sterba <dsterba@suse.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antonio Borneo <antonio.borneo@st.com>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/7] tracing: Change offset type to s32 in preempt/irq tracepoints
Date:   Mon, 20 Jan 2020 16:36:20 +0000
Message-Id: <20200120163622.8603-5-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200120163622.8603-1-jbi.octave@gmail.com>
References: <20200120163622.8603-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

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
---
 include/trace/events/preemptirq.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/preemptirq.h b/include/trace/events/preemptirq.h
index 95fba0471e5b..3f249e150c0c 100644
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
 
 	TP_printk("caller=%pS parent=%pS",
-- 
2.24.1

