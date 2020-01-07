Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B07132E61
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgAGS06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:26:58 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50899 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbgAGS06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 13:26:58 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so148736pjb.0
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 10:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=iPf4qra/muasIK1duzZIdiAfGOJJTt4Vyjsnx+8hrNk=;
        b=dXMZnviil/kd//jWTCubaJJ3XY3pePPyUsjEra91/I6gjemQ4QboUIBti4VYWfxbo3
         7Al3DGDUvflX1fH+4rT6tQKwL2Kd7DcEO/YI/WfOliaWOUAr8FznTi3oOlGpFZon0fsL
         4aXtouOpvQB0QW2hbjjwz76UY7kYuLBnmCDuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=iPf4qra/muasIK1duzZIdiAfGOJJTt4Vyjsnx+8hrNk=;
        b=SvkkZYs9C0im7/UUPjNpBIIlphK6pLXXAY1WZzVSlw3ZbOF8YRZ7Gn1zmt3A7PtX6q
         OrYJzjF0/uCLuJc4h9ytP5+OkSxPYurqbGRYsxsDRuuZmf2R71KbO1KnElp+z112CbIh
         uBTmi68ggdZHMsrWjuTQSIqyU9ldI9PSKeOEiYeF1YzCPPLnrheWMf79af4CdvGmioTB
         f0u24JD+M0Kw5ClJCNAWkQjiI078fWevUxtdc7EKoT75Yk4aJe1oUZ6LjbQM9wnadTNV
         YAmW1rVV4e5lTRMFZgKf4ggTi1p0sL/rtTOG2A/oWhMZKFfW/FRDJRGjS/uyMSza7R/q
         evXA==
X-Gm-Message-State: APjAAAW3DHbtr1ZASsOSRC0Y5HD0k1ivJ1E/LvF/7tCXd+H13EE6QeGJ
        F+1rEqi2tars6xZbXoHRvel3t02y5/o=
X-Google-Smtp-Source: APXvYqxb+pf6IkTVbSwJdoejgUIJV8V1VfBpMog5fo9w5/t22sDUU4v8sI0kM5/cpYMFndQNxlfhXA==
X-Received: by 2002:a17:902:5a85:: with SMTP id r5mr1055528pli.222.1578421617661;
        Tue, 07 Jan 2020 10:26:57 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i127sm256573pfe.54.2020.01.07.10.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 10:26:56 -0800 (PST)
Date:   Tue, 7 Jan 2020 10:26:55 -0800
From:   Kees Cook <keescook@chromium.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Aleksandr Yashkin <a.yashkin@inango-systems.com>
Subject: [PATCH v4.4.z] pstore/ram: Write new dumps to start of recycled zones
Message-ID: <202001071026.8E63B38@keescook>
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
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ram.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 59d93acc29c7..fa0e89edb62d 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -319,6 +319,17 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 
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
