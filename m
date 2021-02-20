Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D323204A8
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 10:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhBTJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 04:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhBTJUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Feb 2021 04:20:13 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E2AC061574
        for <stable@vger.kernel.org>; Sat, 20 Feb 2021 01:19:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c19so5149516pjq.3
        for <stable@vger.kernel.org>; Sat, 20 Feb 2021 01:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h82CGeWW0Nm6m8tQ2hnWnAmFo5rW5QFn6OqQG4pilBY=;
        b=o3YY22MrYBXetJLpqGSjB9einnJSAQi9v0biSR2yHJYmNCWP0ZHkj4Bzk43C3Pkxwq
         uDfinV8OWaD9QiqHOIgS2hQMLGhPDQTiJ6++CQ3/4mnmlvLEX9T3zWW7aaSsxl91uCJp
         27Eip0/Tcfoicj3BdbUwgJsVhzlVYGcL6Icvxd2v80njlwITrpw13ygc6HCYYOPcCybT
         RWkxuzbWOpL3iBtz/Oo5gD1MWxiLG5bXbFIFZfd1OlCTB0gjmXLFNlVMDhGiVghtOQ/z
         n2Z8xS0UeXFf5SaJekFYS1eWFkevwKyvTPia61prD6lKYnjhYHG1SgomhR0PkWwnRa+m
         I6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h82CGeWW0Nm6m8tQ2hnWnAmFo5rW5QFn6OqQG4pilBY=;
        b=Zwz6uTKVDIMjmkjdyQTLLAcH++/refhXTW8EIE75mv84M+hBTa2tqXVRYoztaIwX31
         qijETaCqUjjWxlIDS2aNUMrstzW49IDAbnCz0U3hiED5tvpY5Zr5cpWNA8xz6BtJmiK2
         8WvEdwTz1HcLWtzAjf2tfvHyNSjt944DXKb4KP5A1rLvqvf36oDvlkIOjW2LcYdACSsE
         ogW72279Pjx1UnIWiRYmyfth1lAkbdJ4TNZEiG/UiXKayOaJslMQpbsBn3nxQ6KISdmF
         IWYspyOhqWdZsvGqzEplhjTWEIMrf9+bCHo/xFd22pGsnc/wTe+tUV8BEz0O/iHb61yk
         Yifg==
X-Gm-Message-State: AOAM533LmdrAWWBAE8oLsYkIPo+ekGOoN2a5LaGdfWqnKPS/6QDfd3Kv
        Xy7B/+BKzdLUQCuKswKFSUM=
X-Google-Smtp-Source: ABdhPJyBunK2d6iz5+rmAvJpwmx0kacGZ715FmUbJ9TdVbM6oXSWkxvan+uyro/DCVhW6pbs7ht3og==
X-Received: by 2002:a17:90a:5505:: with SMTP id b5mr12642991pji.194.1613812772266;
        Sat, 20 Feb 2021 01:19:32 -0800 (PST)
Received: from localhost.localdomain (host-61-70-202-235.static.kbtelecom.net. [61.70.202.235])
        by smtp.googlemail.com with ESMTPSA id u17sm12478590pgh.72.2021.02.20.01.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 01:19:31 -0800 (PST)
From:   Kun-Chuan Hsieh <jetswayss@gmail.com>
To:     antiquerefer@gmail.com
Cc:     Kun-Chuan Hsieh <jetswayss@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] tools/resolve_btfids: Fix build error with older host toolchain
Date:   Sat, 20 Feb 2021 09:19:06 +0000
Message-Id: <20210220091906.1432074-1-jetswayss@gmail.com>
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

