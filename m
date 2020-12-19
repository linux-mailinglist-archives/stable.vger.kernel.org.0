Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457E92DECD7
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 04:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgLSDTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 22:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgLSDTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 22:19:51 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C93C0617B0;
        Fri, 18 Dec 2020 19:19:11 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m5so4958047wrx.9;
        Fri, 18 Dec 2020 19:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzB/G9osVpwHRgeX/d/yfB3pndK06WGhL0qV6bNktdA=;
        b=acd56EZLznU9yGFGDmfLuKk1F8GpXaMdtCESy/KbZozWL4sJgwwY+8EsrcrnTrLkw1
         ASUmW1f4cMslNfCOePryamIwakeMgpYjUJA65l+EeVmY2iJS8yIGm4JAKjQ0RNlKzSfv
         eh4fJJ4cmKjE59ts7189IjbrYGXzxuhmGMUaFBn/Esh/2uXmAIvUR0S+lfOVYpoR+cIY
         AKArTzsg3VUelj33/F9lrcot96gcMSaOU7zp4Dzim6HimlVNas8DqZcJvWUUuktt97uX
         tF0KirFRV445Ez78N3QJVAjsRc4WW/w37nIxiYSclLmllg9mFWy9pWooFO8jtEsdUsFX
         u1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzB/G9osVpwHRgeX/d/yfB3pndK06WGhL0qV6bNktdA=;
        b=ThRpYmN+QSmu2lMGyOpGD6GcrKqaMI1ZDHtApjnJ34P10FsRDVJNVMN5q2ocvLhynb
         MZ4MpuVhaj+3verhXlFfhf7eca+TZR1m5FF11AhRdLZVYXzKnKpzYQbyDTmbETGwgeU8
         tT5/Z2Yo5pcFqM7PI9QjgZjb4MmCidFbTpW4JZUDpTBVu8apQhT9qoiNuW+pmL0EaWQ0
         i723LI8UBqfN4Y6tayMQPHhmW4ANvKu3ZR9vBLDOFZMs0L11EMYYPT9yco6DdMkU2giz
         Op4gopsmvgKYZLT7MZgjj0NvQ/VdixscdtZgxsnVIYoHzop45DJAJ0JTOx1xOhkxsoEH
         qvcw==
X-Gm-Message-State: AOAM5323d2CxqRkQgEH+KREvwx1QIF4cgDKzQtP3bUF6wztsWFPag04D
        +ItxcMamV5bjerq9PwSQyVZtXNXSj1c=
X-Google-Smtp-Source: ABdhPJzBwCGEtMWMz3C8+eMa6eJUWipYzx7lUUve3ft6RR0w/jtnKmXTPnxUo52X7lJSehf/ME7g/A==
X-Received: by 2002:adf:fb49:: with SMTP id c9mr7485318wrs.72.1608347949857;
        Fri, 18 Dec 2020 19:19:09 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id g11sm16570978wrq.7.2020.12.18.19.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 19:19:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] io_uring: fix 0-iov read buffer select
Date:   Sat, 19 Dec 2020 03:15:43 +0000
Message-Id: <cdc2fad4b752b14b6be240a3cd9e5a342271625a.1608347693.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Doing vectored buf-select read with 0 iovec passed is meaningless and
utterly broken, forbid it.

Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b74957856e68..f3690dfdd564 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3125,9 +3125,7 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 		iov[0].iov_len = kbuf->len;
 		return 0;
 	}
-	if (!req->rw.len)
-		return 0;
-	else if (req->rw.len > 1)
+	if (req->rw.len != 1)
 		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
-- 
2.24.0

