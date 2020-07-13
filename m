Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5507B21D7CA
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgGMOGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:06:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54957 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729695AbgGMOGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 10:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594649206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=cVAnTWhIdLYJKO73w7wojsiljd9+XyaexVrW7ZP7+wg=;
        b=OdxBOQVf5G2D2UVYUWKL8fOso0/qFcpnRDd3WHu0/pFpyYIjMijKP86h6AVCEV5rKwzTLn
        xbe9wu+tGdfFphT0T/cqwn1QZ4nAHHTiZYGE4IwyQniIxYao/vrKuC/GnprHKWoKNBbOGr
        Lb0/rUauAXokEUgsxjm7zJs7w35GtfQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-hMR2qr5lPwSFO4qpGE10Lw-1; Mon, 13 Jul 2020 10:06:44 -0400
X-MC-Unique: hMR2qr5lPwSFO4qpGE10Lw-1
Received: by mail-qv1-f69.google.com with SMTP id r19so7465072qvz.7
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 07:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cVAnTWhIdLYJKO73w7wojsiljd9+XyaexVrW7ZP7+wg=;
        b=oDtC9y0wgOCcR81p7Q+OlZT9YSgg2EFzL8QWPenMnUxAShoARqmcNlU7D8n6gYAA8H
         YowKO0rMTLFCmVHz0aRavo8cyJhZ4mE+hpNTc18qyZdgpTRvF3TyFJ3rv/rOgesOBcIc
         uo/c1fsTZg9P2UpSunLf7IhXM7odHc02yYIylwVgFPog9iSHRj/awnYh1UdGXgRhIBzl
         B/RJHhK1rD1fBkj/JTKtj1f3pwx64CiiVZXzqn/5O3qZgR9056n/02aiaJp/3KL2JhKr
         Du9bOrzoP/vThuWoAt1tSHXTYYbg2jUqERF8EktjszFogXIts1kPXYgQ0eAeo1EOrIbg
         /yhQ==
X-Gm-Message-State: AOAM530ZuDcpuOk146WhAEWilgAUhQgvmS3Qs2uA1wVA92AuvTdaWwJD
        EuoO8BEIxZmUJGu4BL+EftbYczgdlYFBPZdgyIngEQDFadGCTD+XVn8DlM0GFZCALkXhSA/D3ew
        KOykvzmL7M5GnEUn/
X-Received: by 2002:ad4:57c3:: with SMTP id y3mr61518417qvx.38.1594649203770;
        Mon, 13 Jul 2020 07:06:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc2v24kRRcIx9iU41389LXjIqZiB59Sm2o0YB8K6V71/qbHAgcbnd4J0M72wpearx39vRRHA==
X-Received: by 2002:ad4:57c3:: with SMTP id y3mr61518386qvx.38.1594649203525;
        Mon, 13 Jul 2020 07:06:43 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id m4sm20218627qtf.43.2020.07.13.07.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:06:42 -0700 (PDT)
From:   trix@redhat.com
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, wojciech.ziemba@intel.com,
        karen.xiang@intel.com, bruce.w.allan@intel.com, bo.cui@intel.com,
        pingchaox.yang@intel.com
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: qat: fix double free in qat_uclo_create_batch_init_list
Date:   Mon, 13 Jul 2020 07:06:34 -0700
Message-Id: <20200713140634.14730-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

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

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 4cc1f436b075..bff759e2f811 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -288,13 +288,18 @@ static int qat_uclo_create_batch_init_list(struct icp_qat_fw_loader_handle
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
 
-- 
2.18.1

