Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1552636969
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbiKWTAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbiKWTAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:00:15 -0500
Received: from wedge010.net.lu.se (wedge010.net.lu.se [130.235.56.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2988FE5C;
        Wed, 23 Nov 2022 11:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; d=control.lth.se; s=edge;
        c=relaxed/relaxed; t=1669230010; h=from:subject:to:date:message-id;
        bh=kSHuC6LXb+PE+chwjpVMprQcFyficGssjG266e/qJ7w=;
        b=dxrq+8mrvfFC7sKa9pReD2C66KhbInKE4TwtMIIxK+y+jRqGRJrBlY3QT8jS96tCiBqklzrK1+Z
        G91MHAYJXosSpsLN3cY4ghFYj6Ko/rSDUAy8s6ub3oZ/YiE0L1XGUbYp6IjJpLolfnM104ciFCf2A
        Yo06wq4YH+t9Lt8I/5oiuAzpvAl6Rcj8wsYZibxOGuGfbl7kUpvaw6rkZrFcEr8rl8a3Cg3e/IZG4
        oJ/dbiZnPKtL31IfCXfOpnHOx9YLY/9yvBWK0tihE61U+QNAhHCcPlmrUyOgJfZ5iT/EtsNgxrqMc
        z4Xanr0d/fXLo8SN41XRz7uxO+G+U5KtywkA==
Received: from wexc007.uw.lu.se (130.235.59.251) by mail.lu.se
 (130.235.56.200) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256) id 15.1.2507.13; Wed, 23
 Nov 2022 20:00:09 +0100
Received: from [130.235.83.196] (130.235.139.100) by wexc007.uw.lu.se
 (130.235.59.251) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.13; Wed, 23
 Nov 2022 20:00:10 +0100
Message-ID: <9e45fed2-f9e9-8c5e-3c33-993de330f11e@control.lth.se>
Date:   Wed, 23 Nov 2022 20:00:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
From:   Anders Blomdell <anders.blomdell@control.lth.se>
Subject: [PATCH v2 1/1] Make nfsd_splice_actor work with reads with a non-zero
 offset that doesn't end on a page boundary
To:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
CC:     <linux-nfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [130.235.139.100]
X-ClientProxiedBy: wexc012.uw.lu.se (130.235.59.234) To wexc007.uw.lu.se
 (130.235.59.251)
X-CrossPremisesHeadersFilteredBySendConnector: wexc007.uw.lu.se
X-OrganizationHeadersPreserved: wexc007.uw.lu.se
Received-SPF: Pass (wedge010.net.lu.se: domain of
 anders.blomdell@control.lth.se designates 130.235.59.251 as permitted sender)
 receiver=wedge010.net.lu.se; client-ip=130.235.59.251; helo=wexc007.uw.lu.se;
X-CrossPremisesHeadersFilteredBySendConnector: wedge010.net.lu.se
X-OrganizationHeadersPreserved: wedge010.net.lu.se
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make nfsd_splice_actor work with reads with a non-zero offset that doesn't end on a page boundary.

This was found when virtual machines with nfs-mounted qcow2 disks failed to boot properly (originally found
on v6.0.5, fix also needed and tested on v6.0.9 and v6.1-rc6).

Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2142132
Fixes: bfbfb6182ad1 "nfsd_splice_actor(): handle compound pages"
Cc: stable@vger.kernel.org # v6.0+

-- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -869,12 +869,13 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
  		  struct splice_desc *sd)
  {
  	struct svc_rqst *rqstp = sd->u.data;
-	struct page *page = buf->page;	// may be a compound one
+	// buf->page may be a compound one
  	unsigned offset = buf->offset;
+	struct page *first = buf->page + offset / PAGE_SIZE;
+	struct page *last = buf->page + (offset + sd->len - 1) / PAGE_SIZE;

-	page += offset / PAGE_SIZE;
-	for (int i = sd->len; i > 0; i -= PAGE_SIZE)
-		svc_rqst_replace_page(rqstp, page++);
+	for (struct page *page = first; page <= last; page++)
+		svc_rqst_replace_page(rqstp, page);
  	if (rqstp->rq_res.page_len == 0)	// first call
  		rqstp->rq_res.page_base = offset % PAGE_SIZE;
  	rqstp->rq_res.page_len += sd->len;

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118
SE-221 00 Lund, Sweden
