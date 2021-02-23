Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A5F322385
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 02:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhBWBVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 20:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhBWBVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 20:21:01 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAE2C061574;
        Mon, 22 Feb 2021 17:20:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 23so3242433pgg.4;
        Mon, 22 Feb 2021 17:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2gSkHr7RCik5ZmoW0MEj74bKu0lmALWQ3nRrzoTAlE=;
        b=Lq5MgyDxsfV301vPRHl4fzJ9mrAQdkODNyOnBL/A5on5HFwt9Y1vraPCjwKuSC/h7V
         cni3IndVLUGMWILh7UbIS+5aVv0UKBEySY9rFXPxq1622WGGiyg6XfWNGvjE81kzLzUv
         q91E8F58U2g+i1E/BjHIHxyXMu/aUQb66EW7HYPf4tXetqzYAuYmmr3GaJmStnqh5aFL
         HW9g7qIqYgjcwYJkJn9+ZrQTIWA+CDVRXuuLkvo5yCy+8PUAW6DeWQOyoLP5UiiADiM3
         IfUuWwKAw5iq14qaA3oqFbPGm0Si30LrJ51Zw7o7/51/hS+gp6Q6WpLIfrtMUEtGvW07
         tDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2gSkHr7RCik5ZmoW0MEj74bKu0lmALWQ3nRrzoTAlE=;
        b=hzMEJhuFPt5PhxU7dsCuxFHq4Gjmb4ey1p8mhFYVo+H9ltNWLGAZF79w5MPIxDQjQF
         LlpsZ5Oqm6ojy+qW2l4QNaz9Do+V/VNQhLQAqbTIcdgU+q1nYhyqm53fkvdj8dpMWgWV
         cBwufL1Cay525RaRDRLGeGkDTKvhRgk/2SQGtpKlO8QWzOdvKJDw8dEgnz+LHDNlDKDu
         65bvApKwI0WKriF60UQrWfbBWNAn7J7ldbK/TcVToeqdcOMwrnFjHS+CO4kgTi9zyVhs
         csod717tgppDU3nEyqF2sk14Q8/8J2ianV/vB9JnfIy0yf+KhSv+NRnFSxHIVLXYszaH
         3JGA==
X-Gm-Message-State: AOAM530kwNvKrlMb57LhZCidSSlTdOSm+OKyu5c8vR7RhBBhsj98lGZB
        myVVVvjNgf3LOuSII9DgmTbx1R5wWJf7Nw==
X-Google-Smtp-Source: ABdhPJx6+3wuU71AnFdPArCyu4qlt1guZ5ux1hBZqrO70d7yJzFbCBlDn1OhGEWI0qoR8MalMGqf3A==
X-Received: by 2002:a05:6a00:1e:b029:1ed:b82c:bb64 with SMTP id h30-20020a056a00001eb02901edb82cbb64mr4672502pfk.78.1614043219828;
        Mon, 22 Feb 2021 17:20:19 -0800 (PST)
Received: from localhost.localdomain (host-61-70-202-235.static.kbtelecom.net. [61.70.202.235])
        by smtp.googlemail.com with ESMTPSA id f19sm21444998pgl.49.2021.02.22.17.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:20:19 -0800 (PST)
From:   Kun-Chuan Hsieh <jetswayss@gmail.com>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, jolsa@kernel.org, andrii@kernel.org,
        Kun-Chuan Hsieh <jetswayss@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] tools/resolve_btfids: Fix build error with older host toolchains
Date:   Tue, 23 Feb 2021 01:20:01 +0000
Message-Id: <20210223012001.1452676-1-jetswayss@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Older versions of libelf cannot recognize the compressed section.
However, it's only required to fix the compressed section info when
compiling with CONFIG_DEBUG_INFO_COMPRESSED flag is set.

Only compile the compressed_section_fix function when necessary will make
it easier to enable the BTF function. Since the tool resolve_btfids is
compiled with host toolchain. The host toolchain might be older than the
cross compile toolchain.

Cc: stable@vger.kernel.org
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

