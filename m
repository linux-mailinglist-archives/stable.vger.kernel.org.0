Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5902217C19A
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgCFPVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 10:21:13 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42442 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFPVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 10:21:13 -0500
Received: by mail-ot1-f67.google.com with SMTP id 66so2723909otd.9;
        Fri, 06 Mar 2020 07:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=o1t9Luxf+r0rMs+OmKtEKltB7C3/OdTEjpCMSdTFkZw=;
        b=H1Z/Ug6siFGjzeRxcp4r9XfRXG9TQOds+XglqTN8tmexLbwQkPy3YIu7Y6yw6XkIql
         k6AVC051wI+2MFk/blWhJoijNBLWQ2Nl3iH9Ghkyx+VVI0168BEhB4HTYdaEsdGT5cgE
         X84DHGXdOlQMFAijQ6IidqIaL0iHoKlDo15HHTlq0B6unOJAAZLV5gTwcW0sO3GIjkXt
         te1sUNkeOVIim33WqSJJkI+GoudPdM/KuY+YITO0uCy5Ac3Gy3g5Aelc2w2kVSiJAJ9/
         Fon/BRGRZpCK7nCyPyNDB40RDQ2I6eMVC70Ru1JYCrG12E7Waj5Vcrorfw6pKypVzYjP
         Fj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=o1t9Luxf+r0rMs+OmKtEKltB7C3/OdTEjpCMSdTFkZw=;
        b=jtTF0HzVtZDpQk+isttEpMbI7r9c3oJ7vkjxaSB7L+5CHQuyq9NltrNSjYt2YGHB9M
         Nt1zUTJ6w3XrIowwDPC3Yi1/wQ2HLj9l+q4HaWWwAs6nm6ItmAAkPSOe/D2GsjbB8JMc
         4yEQGOxjpW2adQJJsxg6iD8gDz5MDX+hc3QPGh/O1kaolArxbeneZtcV0DEzuXHXkCvf
         W/7qkK1fw3HAhSiYPCIbmXXv41YKfk2GuJyVxTwJ/qclT1DFEB6wVV+yIebpfPoO8nz5
         iyJcabJo2TDNZ2uDPPbjlzHtyB50oOLR9YXallHQkp/x/ad9KiUnib2G+FYGnrMcZl6A
         Nk+A==
X-Gm-Message-State: ANhLgQ1iUKUjHt51iIZvN9HabcV2F0Z9UtZezR2ynTew4Es+X74z+BjJ
        K0ZFdQ76TmmuDKrHiiAWNQ==
X-Google-Smtp-Source: ADFU+vubFXnYaJY/462LGLlSD/6SHQ5yVkERr3a9xoPfpKLvHMzkQ+KASmxemOqzXdkWKjKf9PvrJA==
X-Received: by 2002:a9d:6544:: with SMTP id q4mr2819247otl.269.1583508072222;
        Fri, 06 Mar 2020 07:21:12 -0800 (PST)
Received: from serve.minyard.net ([47.184.164.37])
        by smtp.gmail.com with ESMTPSA id m69sm11459902otc.78.2020.03.06.07.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:21:11 -0800 (PST)
Received: from t560.minyard.net (unknown [IPv6:2001:470:b8f6:1b:7891:d81e:d9b4:ab4b])
        by serve.minyard.net (Postfix) with ESMTPA id 2E94A18004F;
        Fri,  6 Mar 2020 15:21:11 +0000 (UTC)
From:   minyard@acm.org
To:     linux-kernel@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>, stable@vger.kernel.org,
        Adrian Reber <areber@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>
Subject: [PATCH] pid: Fix error return value in some cases
Date:   Fri,  6 Mar 2020 09:20:01 -0600
Message-Id: <20200306152001.30442-1-minyard@acm.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Recent changes to alloc_pid() allow the pid number to be specified on
the command line.  If set_tid_size is set, then the code scanning the
levels will hard-set retval to -EPERM, overriding it's previous -ENOMEM
value.

After the code scanning the levels, there are error returns that do not
set retval, assuming it is still set to -ENOMEM.

In the first place, pid_ns_prepare_proc() returns its own error, just
use that.

In the second place:

	if (!(ns->pid_allocated & PIDNS_ADDING))
		goto out_unlock;

a return value of -ENOMEM is probably wrong, since that means that the
namespace is in deletion while this happened.  -EINVAL is probably a
better choice.

Fixes: 49cb2fc42ce4 "fork: extend clone3() to support setting a PID"
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: <stable@vger.kernel.org> # 5.5
Cc: Adrian Reber <areber@redhat.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/pid.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 0f4ecb57214c..1921f7f4b236 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -248,7 +248,8 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 	}
 
 	if (unlikely(is_child_reaper(pid))) {
-		if (pid_ns_prepare_proc(ns))
+		retval = pid_ns_prepare_proc(ns);
+		if (retval)
 			goto out_free;
 	}
 
@@ -261,8 +262,10 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 
 	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
-	if (!(ns->pid_allocated & PIDNS_ADDING))
+	if (!(ns->pid_allocated & PIDNS_ADDING)) {
+		retval = -EINVAL;
 		goto out_unlock;
+	}
 	for ( ; upid >= pid->numbers; --upid) {
 		/* Make the PID visible to find_pid_ns. */
 		idr_replace(&upid->ns->idr, pid, upid->nr);
-- 
2.17.1

