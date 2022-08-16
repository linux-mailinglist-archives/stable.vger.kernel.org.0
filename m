Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7D5952ED
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiHPGr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHPGrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:47:32 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F999C4819
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 18:50:26 -0700 (PDT)
Received: from sequoia.corp.microsoft.com (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id D58BA213B654;
        Mon, 15 Aug 2022 18:50:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D58BA213B654
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1660614626;
        bh=W6ykBZjjAv67rq+J1DUzPprWj6pkWoaXMWMr4QZUNd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7RsIWt0gjFO/RrRcCiJhQAJXDL5Ms8G71FVtzPr7KPzNQdmTCd0mfjVI8pyBYadG
         7dZV9BF87WmViUA/okT94/yzRP8j62CUig3c66/gxIzd7Tu4QY3h74q0qYcrnQPpGx
         heQ+pDWr9IiH3q//P0ogdCvpkYyNQ5c3CDI+TtTU=
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     gregkh@linuxfoundation.org
Cc:     asmadeus@codewreck.org, linux_oss@crudebyte.com,
        stable@vger.kernel.org
Subject: [PATCH 5.10 5.4 4.19] net/9p: Initialize the iounit field during fid creation
Date:   Mon, 15 Aug 2022 20:49:25 -0500
Message-Id: <20220816014925.336922-1-tyhicks@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1660564171201106@kroah.com>
References: <1660564171201106@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit aa7aeee169480e98cf41d83c01290a37e569be6d ]

Ensure that the fid's iounit field is set to zero when a new fid is
created. Certain 9P operations, such as OPEN and CREATE, allow the
server to reply with an iounit size which the client code assigns to the
p9_fid struct shortly after the fid is created by p9_fid_create(). On
the other hand, an XATTRWALK operation doesn't allow for the server to
specify an iounit value. The iounit field of the newly allocated p9_fid
struct remained uninitialized in that case. Depending on allocation
patterns, the iounit value could have been something reasonable that was
carried over from previously freed fids or, in the worst case, could
have been arbitrary values from non-fid related usages of the memory
location.

The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
after the uninitialized iounit field resulted in the typical sequence of
two getxattr(2) syscalls, one to get the size of an xattr and another
after allocating a sufficiently sized buffer to fit the xattr value, to
hit an unexpected ERANGE error in the second call to getxattr(2). An
uninitialized iounit field would sometimes force rsize to be smaller
than the xattr value size in p9_client_read_once() and the 9P server in
WSL refused to chunk up the READ on the attr_fid and, instead, returned
ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
the READ and this problem goes undetected there.

Link: https://lkml.kernel.org/r/20220710141402.803295-1-tyhicks@linux.microsoft.com
Fixes: ebf46264a004 ("fs/9p: Add support user. xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
[tyhicks: Adjusted context due to:
 - Lack of fid refcounting introduced in v5.11 commit 6636b6dcc3db ("9p:
   add refcount to p9_fid struct")
 - Difference in how buffer sizes are specified v5.16 commit
   6e195b0f7c8e ("9p: fix a bunch of checkpatch warnings")]
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
---

Tested on top of v5.10.136. Verified to apply to v5.4 and v4.19 and the
resulting code was read for correctness.

Tyler

 net/9p/client.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index bf6ed00d7c37..e8862cd4f91b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -893,16 +893,13 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	struct p9_fid *fid;
 
 	p9_debug(P9_DEBUG_FID, "clnt %p\n", clnt);
-	fid = kmalloc(sizeof(struct p9_fid), GFP_KERNEL);
+	fid = kzalloc(sizeof(struct p9_fid), GFP_KERNEL);
 	if (!fid)
 		return NULL;
 
-	memset(&fid->qid, 0, sizeof(struct p9_qid));
 	fid->mode = -1;
 	fid->uid = current_fsuid();
 	fid->clnt = clnt;
-	fid->rdir = NULL;
-	fid->fid = 0;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&clnt->lock);
-- 
2.25.1

