Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9FF246C21
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgHQQKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388556AbgHQQKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 633582245C;
        Mon, 17 Aug 2020 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680634;
        bh=KtlD/dHbQX6e0yXtT9SBli8K4ds5ERxe2N5v+WXJC4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn3855n/aEBIAY7Ksnmb/C0A7ykB+Xt+GablstQFLLLno6N5NqVo+oYSRvF73t0yt
         smTnEDLKSuTUjmDpt81C2TEjpQ1WZ+7tQdYLLU+O/s6wb2LXaopYJoHFe9NgBo0fNu
         KXHTNkeePCziInbXI9lY7eRmnZGGhITvKnrC+4dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 258/270] crypto: qat - fix double free in qat_uclo_create_batch_init_list
Date:   Mon, 17 Aug 2020 17:17:39 +0200
Message-Id: <20200817143808.672444506@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit c06c76602e03bde24ee69a2022a829127e504202 upstream.

clang static analysis flags this error

qat_uclo.c:297:3: warning: Attempt to free released memory
  [unix.Malloc]
                kfree(*init_tab_base);
                ^~~~~~~~~~~~~~~~~~~~~

When input *init_tab_base is null, the function allocates memory for
the head of the list.  When there is problem allocating other list
elements the list is unwound and freed.  Then a check is made if the
list head was allocated and is also freed.

Keeping track of the what may need to be freed is the variable 'tail_old'.
The unwinding/freeing block is

	while (tail_old) {
		mem_init = tail_old->next;
		kfree(tail_old);
		tail_old = mem_init;
	}

The problem is that the first element of tail_old is also what was
allocated for the list head

		init_header = kzalloc(sizeof(*init_header), GFP_KERNEL);
		...
		*init_tab_base = init_header;
		flag = 1;
	}
	tail_old = init_header;

So *init_tab_base/init_header are freed twice.

There is another problem.
When the input *init_tab_base is non null the tail_old is calculated by
traveling down the list to first non null entry.

	tail_old = init_header;
	while (tail_old->next)
		tail_old = tail_old->next;

When the unwinding free happens, the last entry of the input list will
be freed.

So the freeing needs a general changed.
If locally allocated the first element of tail_old is freed, else it
is skipped.  As a bit of cleanup, reset *init_tab_base if it came in
as null.

Fixes: b4b7e67c917f ("crypto: qat - Intel(R) QAT ucode part of fw loader")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/qat/qat_common/qat_uclo.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -332,13 +332,18 @@ static int qat_uclo_create_batch_init_li
 	}
 	return 0;
 out_err:
+	/* Do not free the list head unless we allocated it. */
+	tail_old = tail_old->next;
+	if (flag) {
+		kfree(*init_tab_base);
+		*init_tab_base = NULL;
+	}
+
 	while (tail_old) {
 		mem_init = tail_old->next;
 		kfree(tail_old);
 		tail_old = mem_init;
 	}
-	if (flag)
-		kfree(*init_tab_base);
 	return -ENOMEM;
 }
 


