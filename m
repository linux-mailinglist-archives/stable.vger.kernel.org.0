Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DA5132E52
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgAGSZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:25:19 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41989 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgAGSZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 13:25:19 -0500
Received: by mail-pl1-f193.google.com with SMTP id p9so40620plk.9
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 10:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=b4dOcZpTE0VSAarRT3U/+EWYVusudk2xJAKDsqQkdeI=;
        b=hZIw7B45tLCk+IQrCWHa1ROf6wgdBMhcSivbfdMk865dZC+3Zr68hsoBq4qlNeLeue
         aaME2NQRCUyrqXA011kXX180tBN+y0m30aBAQfy5k/pRxiFS2HOvRl+sXb4CJmGZT525
         a2Oo77vChC6puw7NgOIEFo/aVV3rlxiYiKt5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=b4dOcZpTE0VSAarRT3U/+EWYVusudk2xJAKDsqQkdeI=;
        b=NONwlcAU3wZ7L/rDdUrwfGyc6FdBo/YWKvhoH3xyQJ0I7kkloEquyScqRTvlCCl2KA
         LtI7/+nTbHLEe9E+5mXO48Jo7+oJLHWRTkuxIRheXdR04tb32QL+qn4+U+X+f6FNc6NL
         gIJpt710mTzFnLHJBBsEg6N9peX054VC8ziBzeZux8Dx2wc1qNITkz3f2aLHnc6lBjAw
         XF8I8NJRmNsP+TCMJ8tvSeCO79urdidgnwU7fhqQDI6e+laltd7osW8HvWizVk0BTU8S
         j3LlQHhWCzaaqxu8vZoXpylw3hxem9reahiKyS7CXQYSBpMSu9JY0CodFO7JyhElLcjA
         88hQ==
X-Gm-Message-State: APjAAAVDBi0ZkVi9PYDM9ZzfSE6qpXzZdUjGV/uGrAUbPk8KVi39A15y
        PFPsGKmPPt306+wnDDHMQWdM5Roze2U=
X-Google-Smtp-Source: APXvYqz8BdAeTBkyvtf88PMKCZs7ZEU9/VlmKKk//XvZg27UJGMtTtNmEYLPptlRlP+iJYBqYwPFNA==
X-Received: by 2002:a17:90a:1a0d:: with SMTP id 13mr1123590pjk.129.1578421518721;
        Tue, 07 Jan 2020 10:25:18 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u2sm450491pgc.19.2020.01.07.10.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 10:25:17 -0800 (PST)
Date:   Tue, 7 Jan 2020 10:25:16 -0800
From:   Kees Cook <keescook@chromium.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Aleksandr Yashkin <a.yashkin@inango-systems.com>
Subject: [PATCH v4.9.z] pstore/ram: Write new dumps to start of recycled zones
Message-ID: <202001071023.9BFD4C51@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Yashkin <a.yashkin@inango-systems.com>

[ Upstream commit 9e5f1c19800b808a37fb9815a26d382132c26c3d ]

The ram_core.c routines treat przs as circular buffers. When writing a
new crash dump, the old buffer needs to be cleared so that the new dump
doesn't end up in the wrong place (i.e. at the end).

The solution to this problem is to reset the circular buffer state before
writing a new Oops dump.

Signed-off-by: Aleksandr Yashkin <a.yashkin@inango-systems.com>
Signed-off-by: Nikolay Merinov <n.merinov@inango-systems.com>
Signed-off-by: Ariel Gilman <a.gilman@inango-systems.com>
Link: https://lore.kernel.org/r/20191223133816.28155-1-n.merinov@inango-systems.com
Fixes: 896fc1f0c4c6 ("pstore/ram: Switch to persistent_ram routines")
[kees: backport to v4.9]
Link: https://lore.kernel.org/stable/157831399811194@kroah.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ram.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 8b09271e5d66..a73959e6ae32 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -321,6 +321,17 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 
 	prz = cxt->przs[cxt->dump_write_cnt];
 
+	/*
+	 * Since this is a new crash dump, we need to reset the buffer in
+	 * case it still has an old dump present. Without this, the new dump
+	 * will get appended, which would seriously confuse anything trying
+	 * to check dump file contents. Specifically, ramoops_read_kmsg_hdr()
+	 * expects to find a dump header in the beginning of buffer data, so
+	 * we must to reset the buffer values, in order to ensure that the
+	 * header will be written to the beginning of the buffer.
+	 */
+	persistent_ram_zap(prz);
+
 	hlen = ramoops_write_kmsg_hdr(prz, compressed);
 	if (size + hlen > prz->buffer_size)
 		size = prz->buffer_size - hlen;
-- 
2.20.1


-- 
Kees Cook
