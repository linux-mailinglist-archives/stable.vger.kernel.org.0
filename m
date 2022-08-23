Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BD259D602
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242148AbiHWIhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347090AbiHWIgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:36:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4205176940;
        Tue, 23 Aug 2022 01:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AEC061284;
        Tue, 23 Aug 2022 08:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1525BC433C1;
        Tue, 23 Aug 2022 08:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242633;
        bh=w0p436ssZfj/lQdy31bDOBkJyI06WCHkjyGiFQ8EqOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhQUzDCSI8NHgikEqAPOxpK4HJ/ntaP0z4EvBo+DtcoI8AmNrJFManzBtL+hzjmTj
         kNEx/eqcYI8olIG+j7IcNBDAXmYWIiRwfzn2Ucx1k0aDZ3c1geaXp2WRBwcg148xwT
         tNFPITBNfCuSZImdheQ47AcAA230BQDK92XpGAD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.19 149/365] xen/xenbus: fix return type in xenbus_file_read()
Date:   Tue, 23 Aug 2022 10:00:50 +0200
Message-Id: <20220823080124.456944321@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 32ad11127b95236dfc52375f3707853194a7f4b4 upstream.

This code tries to store -EFAULT in an unsigned int.  The
xenbus_file_read() function returns type ssize_t so the negative value
is returned as a positive value to the user.

This change forces another change to the min() macro.  Originally, the
min() macro used "unsigned" type which checkpatch complains about.  Also
unsigned type would break if "len" were not capped at MAX_RW_COUNT.  Use
size_t for the min().  (No effect on runtime for the min_t() change).

Fixes: 2fb3683e7b16 ("xen: Add xenbus device driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Link: https://lore.kernel.org/r/YutxJUaUYRG/VLVc@kili
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenbus/xenbus_dev_frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -128,7 +128,7 @@ static ssize_t xenbus_file_read(struct f
 {
 	struct xenbus_file_priv *u = filp->private_data;
 	struct read_buffer *rb;
-	unsigned i;
+	ssize_t i;
 	int ret;
 
 	mutex_lock(&u->reply_mutex);
@@ -148,7 +148,7 @@ again:
 	rb = list_entry(u->read_buffers.next, struct read_buffer, list);
 	i = 0;
 	while (i < len) {
-		unsigned sz = min((unsigned)len - i, rb->len - rb->cons);
+		size_t sz = min_t(size_t, len - i, rb->len - rb->cons);
 
 		ret = copy_to_user(ubuf + i, &rb->msg[rb->cons], sz);
 


