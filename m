Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120094BDF7A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355221AbiBUKkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:40:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355168AbiBUKkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 05:40:00 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED90E93
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:01:53 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id r13so8783168ejd.5
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dh0eRL7BT5Z1WXEJ64jweV7rcRpasXXUz8D11sbvc0I=;
        b=YnpgJPXijyMPrUn7c/EJsqvlXyk4GTtwAiyOIOTTgb01KHqxFhDWFzAkTkXA376Y4x
         q3YVB2MJg6VRstKKsfjN3DuIqt60cABLan2nUanZhtcKCmV8YJ370jJfoJjPj9vZUnJH
         QVEeZFbJgLg7X/Q+PQdgCAh7IMIIqpHh0vLqSw2nNxQfdZOKE6QIV9XI4jvcgkdCzjW3
         aYHpzmCC262+sGyTSER9Zqfq2xSq1c5NKtorlfJ0/YBy4O8Hp+CfmQdIKEGg/6WBPS26
         g4Em9mxeuoglR6yZzTQOCY+d+DD2brXLQT3WfFDWVToC0T9Nv1WMPmnTo4duavSBg1RL
         tQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dh0eRL7BT5Z1WXEJ64jweV7rcRpasXXUz8D11sbvc0I=;
        b=17aLmWdmVdmUI+W18Bg2EaDEHKWANeAM3MMAb8IqYxDlH/oiOMiowPT17IKaWv28hu
         wT6xUoVkGnXgpr9mdEpRxpiFQcWrbC4g1AFzKGPt3xxwM/SDhyPqW+0PELJ0hADCg2yA
         WLLHPGOgvivPFdL1qz2h+AY9jCcO6OOtnHMjLkMdyujnmJIQ9Iajlgz1uc90PscjvNKT
         ryNZW9dWtuiOX7/9QAxAI+ZlEExJeJwqAeJva+pO6DLIu+QxF2y8HNPaYFf7LhkLEqd4
         piMtb56bd50yUTNhT/RA0nuqySH4aQGHLa5uRijk6y8MMSxYUWZiWPtuy9craGGEG4pw
         JMIQ==
X-Gm-Message-State: AOAM5318ux656Jd7VHPhPaTRacL6xJo+gntygHj8MCL2Fps1MCRLQrAI
        JjoRvXq1kZz7z+Au3bl2ClhOBw==
X-Google-Smtp-Source: ABdhPJxjfjUvk4Kw5PROMYo3UPMgfwRz3QAJsrlYwN1tykpyIv+2RPEZzz8bYcUEAB0RYPnfCJPkEQ==
X-Received: by 2002:a17:906:1645:b0:6ce:de9:6eb1 with SMTP id n5-20020a170906164500b006ce0de96eb1mr14913120ejd.616.1645437711911;
        Mon, 21 Feb 2022 02:01:51 -0800 (PST)
Received: from heron.intern.cm-ag (p200300dc6f260d000000000000000fd2.dip0.t-ipconnect.de. [2003:dc:6f26:d00::fd2])
        by smtp.gmail.com with ESMTPSA id b2sm5476885edr.44.2022.02.21.02.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 02:01:51 -0800 (PST)
From:   Max Kellermann <max.kellermann@ionos.com>
To:     max@blarg.de
Cc:     Max Kellermann <max.kellermann@ionos.com>, stable@vger.kernel.org
Subject: [PATCH] lib/iov_iter: initialize "flags" in new pipe_buffer
Date:   Mon, 21 Feb 2022 11:01:51 +0100
Message-Id: <20220221100151.1504381-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The functions copy_page_to_iter_pipe() and push_pipe() can both
allocate a new pipe_buffer, but the "flags" member initializer is
missing.

Fixes: 241699cd72a8 ("new iov_iter flavour: pipe-backed")
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 lib/iov_iter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index b0e0acdf96c1..6dd5330f7a99 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -414,6 +414,7 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
 		return 0;
 
 	buf->ops = &page_cache_pipe_buf_ops;
+	buf->flags = 0;
 	get_page(page);
 	buf->page = page;
 	buf->offset = offset;
@@ -577,6 +578,7 @@ static size_t push_pipe(struct iov_iter *i, size_t size,
 			break;
 
 		buf->ops = &default_pipe_buf_ops;
+		buf->flags = 0;
 		buf->page = page;
 		buf->offset = 0;
 		buf->len = min_t(ssize_t, left, PAGE_SIZE);
-- 
2.34.0

