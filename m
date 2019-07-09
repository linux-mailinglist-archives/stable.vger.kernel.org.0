Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBDB634C1
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 13:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfGILJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 07:09:51 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33935 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGILJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 07:09:50 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so17402480edb.1
        for <stable@vger.kernel.org>; Tue, 09 Jul 2019 04:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gehOANnmao3oV9pvw/seZIFQrg9raLUC+jG0ZPx31LY=;
        b=if2Hz2BqVzUt4QQgiVKhPFAHrTuSwx++ynxvI9kucQ/hCQ4NKAdcr3h0NAqK0eo5un
         G/Zuzdg1MF00I42wSwHPQzZyeIZTe6WwKyWUwAWshEQpNeKym5rVtg8DtE+Tjxjrnvt4
         0vF1LQDXFN4uzZ0zRtlCqwXhHErUGFemvAS+gIQf00lfJ6Dxs2Q+fJ8X7gL2lFurldC/
         Aqmx1/AhtP2Mrps0BxvJrKCkO6EaEkXTNnTdMn3JC+Gm9fhnAdtOFMS1s9RS9nl43mPH
         PGHNFdBqklG3CP02tCEGBpnXCPX7Y8SeBIIdgCiUG8TvG/UdKjyQpi/eTgzgwZdxhgd9
         sT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gehOANnmao3oV9pvw/seZIFQrg9raLUC+jG0ZPx31LY=;
        b=K6YjoU8xflakys26FMCq/+mv4NbrQLzKsP6noGOKfFwVKZwUlMLjBas1eBYxs+WWo6
         ubs7uh2o69XkqdSLhhlH7UPijv1p3vLQPTakOF5QS7ks4+fkc1uuzB+W17Nd66pNsskv
         e9jcZXLzkXz8jj3PAyt9y/ZYkcADSSO+lAttj9gM6qICF+yvaShWPpZgOQVuidxR11xL
         zt+wZWRR9e23kcHxPLmxTB/PsN7baxvwz+Id5OmDzIM2Z95so4MvwJW9XI4FMfiBdRo1
         JHjv8XZxrx4cnomLwvv2yJK/DkV63DclioDYw0+Wu/D8H0fn8/L/kiwWcBxkpKqTfG9z
         jGHA==
X-Gm-Message-State: APjAAAXuQ7q3+tboCQW/fnW2uRsBW4GXG9z/mN366nuzGAdfxmF3Ulko
        idb7q3vhLL568yWkUQZbSJVQ0Q==
X-Google-Smtp-Source: APXvYqwXkn8xyad1jqyqlkrPyOu0b8MAuKCEqbDbhML8lngOBJTEn5Yb2Bt3BRofTOjHR1UNC8MRJQ==
X-Received: by 2002:a17:906:f91:: with SMTP id q17mr21051364ejj.297.1562670589083;
        Tue, 09 Jul 2019 04:09:49 -0700 (PDT)
Received: from maco2.ams.corp.google.com (a83-162-234-235.adsl.xs4all.nl. [83.162.234.235])
        by smtp.gmail.com with ESMTPSA id o21sm4494788edt.26.2019.07.09.04.09.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 04:09:48 -0700 (PDT)
From:   Martijn Coenen <maco@android.com>
To:     gregkh@linuxfoundation.org, john.stultz@linaro.org,
        tkjos@google.com, arve@android.com, amit.pundir@linaro.org
Cc:     linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        maco@google.com, stable@vger.kernel.org,
        Martijn Coenen <maco@android.com>
Subject: [PATCH] binder: Set end of SG buffer area properly.
Date:   Tue,  9 Jul 2019 13:09:23 +0200
Message-Id: <20190709110923.220736-1-maco@android.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case the target node requests a security context, the
extra_buffers_size is increased with the size of the security context.
But, that size is not available for use by regular scatter-gather
buffers; make sure the ending of that buffer is marked correctly.

Acked-by: Todd Kjos <tkjos@google.com>
Fixes: ec74136ded79 ("binder: create node flag to request sender's
security context")
Signed-off-by: Martijn Coenen <maco@android.com>
Cc: stable@vger.kernel.org # 5.1+
---
 drivers/android/binder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 38a59a630cd4c..5bde08603fbc2 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3239,7 +3239,8 @@ static void binder_transaction(struct binder_proc *proc,
 	buffer_offset = off_start_offset;
 	off_end_offset = off_start_offset + tr->offsets_size;
 	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
-	sg_buf_end_offset = sg_buf_offset + extra_buffers_size;
+	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
+		ALIGN(secctx_sz, sizeof(u64));
 	off_min = 0;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
-- 
2.22.0.410.gd8fdbe21b5-goog

