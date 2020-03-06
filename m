Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB9017C43C
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 18:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgCFRXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 12:23:22 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42267 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCFRXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 12:23:21 -0500
Received: by mail-oi1-f194.google.com with SMTP id l12so3267376oil.9;
        Fri, 06 Mar 2020 09:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=mupmjwiAHLO8iDpFb95apJkaHWQ/TigGpL1KHSH4xms=;
        b=mmjBEgbQSwlmZBkUWvBEhBbTakC8GIm7keMvXibT0uSILLN4w0088NkuioPZjJN/Kw
         kESY0EFLWnkPNvV6RA/hPOzBj141OwBct0DPfvpHPYqqCYir1KD1CrD+kINPpEkC+B7s
         Jd5fwyXz5jyLf9zSkNsizNLFaqee+e86JuAVu094AXn3JXGyiwu8hdCdq+8uINWypNoc
         9IHls7U3oIaYiNODymX3x3tf6RpkpaSdq4SA+1zFy5vNDXurV6c49v6/x90a4o6/S04E
         17N3iYPQzS8gzQ7iUiV+Tk4siIRPUOQynx5OR8h4sFxsAxDuIvq3Y+DfXmuibrxPgMBZ
         5jdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=mupmjwiAHLO8iDpFb95apJkaHWQ/TigGpL1KHSH4xms=;
        b=DxzXCI7T6DTY/NKsa4kG8XQ4EoDkbqX4yWL2+Tx2tDK9S2PnvYVjXTrxJkdlPbg+F0
         UTiKeBg6kRWz1oZbg/cjFfr6LREaBJ+JVDi20WyV7EvWZORipUeHLavCZpXHgDrkEEeK
         Y9ZcizXizmTrb9m4RLpgzS27hyuXNp/7Y31MK5M9tHHYNAS6Upi0oGAfkyHhRqC4NbUX
         7ecC7YbsQQ/vrpz6TcppRHb9tq50+3IrRlUY9RvLorZLNgE4oAdz0GlAoUlWicCPB3pg
         dNQ8xo618Ur3RYqUd94oH4RRCOmSAMYUxKjMEafQhN5SiN0Ly8NeRtuqAZ6RX8idWQ0a
         +vpQ==
X-Gm-Message-State: ANhLgQ2iRlmhQlvf/+ruFhguy2NA9OeRFzwoqCu3gpA1YNq71WUdigPN
        zpOxjQPKU5bykhXxT38u/Q==
X-Google-Smtp-Source: ADFU+vvBg+x2eS3bDKBwRsXWeeqM6GNkqgJ/Cui1n9BXflU+I533ynTTHO4Y/CWBp8XW40MnFsCFsg==
X-Received: by 2002:aca:4b93:: with SMTP id y141mr3470010oia.18.1583515401152;
        Fri, 06 Mar 2020 09:23:21 -0800 (PST)
Received: from serve.minyard.net ([47.184.164.37])
        by smtp.gmail.com with ESMTPSA id g7sm11638601otk.17.2020.03.06.09.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 09:23:20 -0800 (PST)
Received: from t560.minyard.net (unknown [IPv6:2001:470:b8f6:1b:7891:d81e:d9b4:ab4b])
        by serve.minyard.net (Postfix) with ESMTPA id 193A6180002;
        Fri,  6 Mar 2020 17:23:20 +0000 (UTC)
From:   minyard@acm.org
To:     linux-kernel@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>, stable@vger.kernel.org,
        Adrian Reber <areber@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v2] pid: Fix error return value in some cases
Date:   Fri,  6 Mar 2020 11:23:14 -0600
Message-Id: <20200306172314.12232-1-minyard@acm.org>
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

So set retval back to -ENOMEM after scanning the levels.

Fixes: 49cb2fc42ce4 "fork: extend clone3() to support setting a PID"
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: <stable@vger.kernel.org> # 5.5
Cc: Adrian Reber <areber@redhat.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
---

Changes from v1:
  Just set retval to -ENOMEM before the gotos that would use it.

I do think that the second instance:

        if (!(ns->pid_allocated & PIDNS_ADDING))
                goto out_unlock;

is returning the wrong error value, but that's probably not a big
deal, and if it was fixed would probably need to be a separate change.

In the first instance, the error return values are almost all -ENOMEM,
anyway.

 kernel/pid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/pid.c b/kernel/pid.c
index 0f4ecb57214c..19645b25b77c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -247,6 +247,8 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 		tmp = tmp->parent;
 	}
 
+	retval = -ENOMEM;
+
 	if (unlikely(is_child_reaper(pid))) {
 		if (pid_ns_prepare_proc(ns))
 			goto out_free;
-- 
2.17.1

