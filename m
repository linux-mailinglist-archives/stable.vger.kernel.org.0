Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4F600385
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 23:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJPVpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 17:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJPVpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 17:45:15 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4095133858
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s30so13585514eds.1
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaT+EXAKcVwREw4Wv15v8mANvVTDJkxzzJb0OU/mI/I=;
        b=oGHqqwl0Kl8HwmBR/i5boMf/rpKRYP+tOCQi/26POr+JZr1asY0PXPV/gws80H73fs
         BtG3cVqB3eUZokyGrufckttdN3Xw9Zw9gxI035f3ftVtCr1ex12nGoFjgM0RP/Zmw31X
         J6D+EuL4AjFAAygzLuvw77HaWsFJ+hAqlqTaGo+C8kxcnbr8nyjhJkFnV2Qt1KhtZNj5
         jyIYWQl2SpXl9GPKQJ2dXj+ZXN0sG7M7avKa22Y9vd9CtpwrR6zH0auBGXsoR9W6dkBa
         v9DI2rEtgxGnFxVwki07UhCAHML6CaBBnCR5UzWM6IE/1DBkqcgDSo10nbajMLp7xy9x
         Dw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BaT+EXAKcVwREw4Wv15v8mANvVTDJkxzzJb0OU/mI/I=;
        b=wA2HnEMyQQbCOIEroQJpFzF7wkc1GNC3BCocrzYJYU7zyeP1133kgrLN2loDey6e1x
         DK2WBJU2wkGGyVR28tbuEKXbjUUl66vEsuxmMpTy2lzSp1C5j09Wt1N7lxSVvfNly3ds
         0TmctE/T3Rlyex93mK3u3H2j+k60CjxnjKyY3oQZ4+zCnSLUbBchIfP3FUDtGd6yRD4q
         erlqCqWRtyu1K79vT/AyYG2HtysYwb64efOiXZJ+uHw4jL9XwaQq1aTVh3Hl4NNAu/Gv
         8j49hMJRy3a5OYsZC/8eOrq9q1oRzJU2bzb5qskniawYrHh670cmzpBd8cRaPq1SnGw0
         jivA==
X-Gm-Message-State: ACrzQf1oXGNX8KIFXqaVfl/PDnaNG7x4IY0W5n5amu7c0AudJJuikw9w
        WvUWPbbqwKR60+dZPz5GtvrbP7w2gW8=
X-Google-Smtp-Source: AMsMyM7kWnBl7WLl7O+ARLL8rWGkhzHzltUb/SE0YCdlJCH+SN3h5luJkjxJtbpDwImGqPjKcc37JQ==
X-Received: by 2002:a05:6402:448c:b0:457:52eb:b57e with SMTP id er12-20020a056402448c00b0045752ebb57emr7724288edb.178.1665956712443;
        Sun, 16 Oct 2022 14:45:12 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090676c600b0078c47463277sm5177331ejn.96.2022.10.16.14.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 14:45:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 5/5] io_uring/rw: fix unexpected link breakage
Date:   Sun, 16 Oct 2022 22:42:58 +0100
Message-Id: <1b05243cdfa8135866a6ccc115e491df8d725d16.1665954636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665954636.git.asml.silence@gmail.com>
References: <cover.1665954636.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit bf68b5b34311ee57ed40749a1257a30b46127556 ]

req->cqe.res is set in io_read() to the amount of bytes left to be done,
which is used to figure out whether to fail a read or not. However,
io_read() may do another without returning, and we stash the previous
value into ->bytes_done but forget to update cqe.res. Then we ask a read
to do strictly less than cqe.res but expect the return to be exactly
cqe.res.

Fix the bug by updating cqe.res for retries.

Cc: stable@vger.kernel.org
Reported-and-Tested-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3a1088440c7be98e5800267af922a67da0ef9f13.1664235732.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f667197c8bb9..837dd96228b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3606,6 +3606,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 
+		req->result = iov_iter_count(iter);
 		/*
 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
 		 * we get -EIOCBQUEUED, then we'll get a notification when the
-- 
2.38.0

