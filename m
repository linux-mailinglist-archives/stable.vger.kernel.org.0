Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305213204A9
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 10:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhBTJXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 04:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTJXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Feb 2021 04:23:33 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF0EC061574
        for <stable@vger.kernel.org>; Sat, 20 Feb 2021 01:22:52 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id m2so6932502pgq.5
        for <stable@vger.kernel.org>; Sat, 20 Feb 2021 01:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h82CGeWW0Nm6m8tQ2hnWnAmFo5rW5QFn6OqQG4pilBY=;
        b=VCZ3wErdT3MM/iAv6MEdNJwTkvTcuOl/SKRD4xRy2Kj9/73biVvAnd+FBKk2lLnVuU
         wuehje3ZvEzeraMQYAgNRwaJl7GDh2hgKslbhqjel7wlT1UkhiJNVNPZeRUfsp/n7gzw
         1TpblMo2Anu4OtTTkv/fKvpL5eF9IIb04MmJQVyYi8F+tg8NZJScKTU6YzDzC0b8mTDJ
         9WNsO+nPm5Cp27mSwtQ9wbMjP43w2UXl760nd4nmvv0anW/lAPbXIVaSXWNIiawN1z4n
         S5ju9ZhcVh0FnVdUP0cr5Uejvtj5gnP9ctUo1OWPCR+nr7XDeMvobGNe7hPyYAGlSHqf
         TCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h82CGeWW0Nm6m8tQ2hnWnAmFo5rW5QFn6OqQG4pilBY=;
        b=hlx1/VR75AUrAh8TIO8itRK8uOZzWiecZAMZYeNhCJgU9Nw3jqlz5iGHVZfHKTa0t3
         EvYi1r/RfQ19pC9dAyCiyVL8Dlw5xioepnnX/rIQoTZRcVtp/64JGCteJXxvL17Ckwk7
         5qUhKGTUKt6NIHuACswlZt+WO4ie/jFSniVqpBTtqIp9zYak/OqixNQJRafJwI8YpC3r
         w2B6Ew97yRBw7zEb5/xx89gvB+Nv5K9eRQZ/IRDm8YGZzsNouGNB1kMuR+uwoMdeyDhO
         jlDcdJOp9dLLsHpxmW8wAwJLBbyq3IincJLGlFVbuJH62+a6J22XbQC2BYjC0ZLIhwnn
         hMLA==
X-Gm-Message-State: AOAM531hT0VkZ9Lcvv1tOxcPRzA8ym/DTqSPfj1zeJB6ZtoL7WKTxuUO
        Se9wb8JIqTuMP48sQ+G5+so=
X-Google-Smtp-Source: ABdhPJxVuXmpp8iAdHFg4IuBIOpMbT2NaywSSJvSHNBKcYvxWE+KdDjTJAeb5FTyHHEcbRdUYjelwg==
X-Received: by 2002:a63:547:: with SMTP id 68mr11719814pgf.196.1613812972167;
        Sat, 20 Feb 2021 01:22:52 -0800 (PST)
Received: from localhost.localdomain (host-61-70-202-235.static.kbtelecom.net. [61.70.202.235])
        by smtp.googlemail.com with ESMTPSA id l144sm11945381pfd.104.2021.02.20.01.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 01:22:51 -0800 (PST)
From:   Kun-Chuan Hsieh <jetswayss@gmail.com>
To:     ast@kernel.org
Cc:     Kun-Chuan Hsieh <jetswayss@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] tools/resolve_btfids: Fix build error with older host toolchain
Date:   Sat, 20 Feb 2021 09:22:28 +0000
Message-Id: <20210220092228.1432280-1-jetswayss@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Older verions of libelf cannot recognize the compressed section.

However, it's only required to fix the compressed section info when compiling with CONFIG_DEBUG_INFO_COMPRESSED flag is set.
Only compile the compressed_section_fix function when necessary will make it easier to enable the BTF function.
Since the tool resolve_btfids is compiled with host toolchain.
The host toolchain might be older than the cross compile toolchain.

Cc: stable <stable@vger.kernel.org>

Signed-off-by: Kun-Chuan Hsieh <jetswayss@gmail.com>
---
 tools/bpf/resolve_btfids/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 7409d7860aa6..ad40346c6631 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -260,6 +260,7 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
 	return btf_id__add(root, id, false);
 }
 
+#ifdef CONFIG_DEBUG_INFO_COMPRESSED
 /*
  * The data of compressed section should be aligned to 4
  * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld
@@ -292,6 +293,7 @@ static int compressed_section_fix(Elf *elf, Elf_Scn *scn, GElf_Shdr *sh)
 	}
 	return 0;
 }
+#endif
 
 static int elf_collect(struct object *obj)
 {
@@ -370,8 +372,10 @@ static int elf_collect(struct object *obj)
 			obj->efile.idlist_addr  = sh.sh_addr;
 		}
 
+#ifdef CONFIG_DEBUG_INFO_COMPRESSED
 		if (compressed_section_fix(elf, scn, &sh))
 			return -1;
+#endif
 	}
 
 	return 0;
-- 
2.25.1

