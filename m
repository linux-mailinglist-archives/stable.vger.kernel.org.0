Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0769767E273
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 12:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbjA0LAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 06:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbjA0K7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:59:47 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4344BEB5B
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:59:42 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R8xG1x000898
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:59:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=SFHN2U2WIAI6nW3KlEx2htg7L7yaTcuHQiYYjVO6IS0=;
 b=KoiwDmB9/VUV+ch0S3JWRGjP86nd3iBEYTTPxXYXUnMUjf/auEww73baELTU8X2gnkvL
 TDPao7jatyvM5J6slVL3h3K1MWDe9HDsSkXWpEpoIWJXGUfGsggWCZGjDH0VQgcZ8QR4
 Z0KmJLUWede963RP6rNILgXHojj9CHehW4Z4OHmT+dfxp3qHuAg87Ss1q3glJT5iwB0P
 PKRClnUJE6PAesWM6tGmNMFgnenV1KaVNbjgCJO0jW2D6XYD9cWauBPLcLfc+OXA4NJ0
 r/NpoAO+iJ1QUDF7arNalxk0clNhnoYJnAruMdGGW0Mvclu3GwFkGt/PE9qs/QrSXJIg Sg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbvft6k8p-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:59:41 -0800
Received: from twshared5320.05.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 02:59:29 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 5BC63E9FEC07; Fri, 27 Jan 2023 02:59:15 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@meta.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] io_uring: always prep_async for drain requests
Date:   Fri, 27 Jan 2023 02:59:11 -0800
Message-ID: <20230127105911.2420061-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 05E2abBexjwoJWOeFeC0AHHidEbWFwO2
X-Proofpoint-GUID: 05E2abBexjwoJWOeFeC0AHHidEbWFwO2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_06,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drain requests all go through io_drain_req, which has a quick exit in cas=
e
there is nothing pending (ie the drain is not useful). In that case it ca=
n
run the issue the request immediately.

However for safety it queues it through task work.
The problem is that in this case the request is run asynchronously, but
the async work has not been prepared through io_req_prep_async.

This has not been a problem up to now, as the task work always would run
before returning to userspace, and so the user would not have a chance to
race with it.

However - with IORING_SETUP_DEFER_TASKRUN - this is no longer the case an=
d
the work might be defered, giving userspace a chance to change data being
referred to in the request.

Instead _always_ prep_async for drain requests, which is simpler anyway
and removes this issue.

Cc: stable@vger.kernel.org
Fixes: c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---

Hi,

Worth pointing out in discussion with Pavel that we considered just
removing the fast path in io_drain_req. That felt like more of an invasiv=
e
change as it can add an extra kmalloc + io_prep_async_link(), but perhaps
you feel that is a better approach.

I'll send out a liburing test shortly.

Dylan


 io_uring/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0a4efada9b3c..db623b3185c8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1765,17 +1765,12 @@ static __cold void io_drain_req(struct io_kiocb *=
req)
 	}
 	spin_unlock(&ctx->completion_lock);
=20
-	ret =3D io_req_prep_async(req);
-	if (ret) {
-fail:
-		io_req_defer_failed(req, ret);
-		return;
-	}
 	io_prep_async_link(req);
 	de =3D kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de) {
 		ret =3D -ENOMEM;
-		goto fail;
+		io_req_defer_failed(req, ret);
+		return;
 	}
=20
 	spin_lock(&ctx->completion_lock);
@@ -2048,13 +2043,16 @@ static void io_queue_sqe_fallback(struct io_kiocb=
 *req)
 		req->flags &=3D ~REQ_F_HARDLINK;
 		req->flags |=3D REQ_F_LINK;
 		io_req_defer_failed(req, req->cqe.res);
-	} else if (unlikely(req->ctx->drain_active)) {
-		io_drain_req(req);
 	} else {
 		int ret =3D io_req_prep_async(req);
=20
-		if (unlikely(ret))
+		if (unlikely(ret)) {
 			io_req_defer_failed(req, ret);
+			return;
+		}
+
+		if (unlikely(req->ctx->drain_active))
+			io_drain_req(req);
 		else
 			io_queue_iowq(req, NULL);
 	}

base-commit: b00c51ef8f72ced0965d021a291b98ff822c5337
--=20
2.30.2

