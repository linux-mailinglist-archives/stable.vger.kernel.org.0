Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB4A143006
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgATQgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:36:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32882 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATQgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:36:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so160528wrq.0
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 08:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YBP6J1UVtbLvTO2guxNgQ2a446KKGi6HafR839ScyTo=;
        b=eBbFN9SYC7knEUxJ/7yHjozhuhQXx5ldeTw4mzvZCxk99136dL9lmhP1wyAPVDazOv
         4XZ08NSFnqO3+q9ocMowsGxcYUqqWQRLP/z8y/iWxEZ2m3w2/qCaaIvdX2alg7SLSmGx
         nbKTXMzx2XJgCP7lPxoEeke0kqHcYURpXGBoU8nAFaG39JKPkiBkO6v3cSYg1NfFQh6k
         2XJkKjz0TMtYx1cnJEl89gg3TgdInPrEWfE48nnJyE5p4e/5P+5Pr1pu+TIMiDE0yG13
         h2ChYMHmD6dxshE20nE6bWGtsz3c65vPTigbrY/47secW1u7laIU23U06LuKE0laCUGl
         4E3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YBP6J1UVtbLvTO2guxNgQ2a446KKGi6HafR839ScyTo=;
        b=Yh3tSHaebp8nm2d8nxUVOpV5cXQwqj74G0qBJLSojz3Sz5YrPZaItvuUWz6ZBAX0EP
         uRAxa7/akeUFZ6MfhcvkJq9yO04969QEeD0C29p1dopeutP0RkXKF8Vh1UR8tm5UY4Cm
         B7lUBbX9D4mDokcXMYtpqPoU+bCUIFN1xvxuINgXlj431+z+SVBusBTuLMfPoT3ippED
         kKPht9gJhX35VntPxq1zn9cDTSD6eLcIdO5BdZE/DSgp3Lq/o4LYZcQ5ZV5Nhw8eOWk9
         A79lKPE2dnpMXtyFsHT56GZYp2SY99NsESv25UGChSQ9C7vSJj3sO+coJ2/3caFF42Cu
         7U7Q==
X-Gm-Message-State: APjAAAUrAt1JYZ1skXjsPnndNi3+TYfeGZpbFKPVKaswuZ93WmzwEUou
        I8tPfx8SmmdFak2E1S/S2A==
X-Google-Smtp-Source: APXvYqxa8NQyVZKO77uusm7IuevwVDkVgz7wbpHshS3GGufwTSkRk64peT9KwF17WQqcX7m4Y5z43A==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr334226wrw.255.1579538197472;
        Mon, 20 Jan 2020 08:36:37 -0800 (PST)
Received: from ninjahub.org ([91.235.65.22])
        by smtp.googlemail.com with ESMTPSA id x7sm47089018wrq.41.2020.01.20.08.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:36:36 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     jbi.octave@gmail.com
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: [PATCH 1/7] tracing: Initialize val to zero in parse_entry of inject code
Date:   Mon, 20 Jan 2020 16:36:16 +0000
Message-Id: <20200120163622.8603-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

gcc produces a variable may be uninitialized warning for "val" in
parse_entry(). This is really a false positive, but the code is subtle
enough to just initialize val to zero and it's not a fast path to worry
about it.

Marked for stable to remove the warning in the stable trees as well.

Cc: stable@vger.kernel.org
Fixes: 6c3edaf9fd6a3 ("tracing: Introduce trace event injection")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_inject.c b/kernel/trace/trace_events_inject.c
index d45079ee62f8..22bcf7c51d1e 100644
--- a/kernel/trace/trace_events_inject.c
+++ b/kernel/trace/trace_events_inject.c
@@ -195,7 +195,7 @@ static int parse_entry(char *str, struct trace_event_call *call, void **pentry)
 	unsigned long irq_flags;
 	void *entry = NULL;
 	int entry_size;
-	u64 val;
+	u64 val = 0;
 	int len;
 
 	entry = trace_alloc_entry(call, &entry_size);
-- 
2.24.1

