Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F4C514777
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345729AbiD2KsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358004AbiD2KsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:48:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9B7CA0CE;
        Fri, 29 Apr 2022 03:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 77EE6CE31B0;
        Fri, 29 Apr 2022 10:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A53C385AD;
        Fri, 29 Apr 2022 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228999;
        bh=EtH3uLb0oVcU5ZA8jXax1Kcu+FfvZi13RlPITGQ6mQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VX0F8I2C95c21cXJkanT+xOGGwAeOluP8RWBlzh1AxWl8WRQ9x8Z1zRObZHdXvlKN
         R6a/UV9BpPDxI9OqPWCZfB7+TQHNn20NZfqjoa4T1bE4n4IEtBrynZCUVBUkI6/NIm
         sqA8WWwOTeDXQBYukOAalFH2R4XH4ABKNN1pS33A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 25/33] iomap: Support partial direct I/O on user copy failures
Date:   Fri, 29 Apr 2022 12:42:12 +0200
Message-Id: <20220429104053.068440240@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 97308f8b0d867e9ef59528cd97f0db55ffdf5651 upstream

In iomap_dio_rw, when iomap_apply returns an -EFAULT error and the
IOMAP_DIO_PARTIAL flag is set, complete the request synchronously and
return a partial result.  This allows the caller to deal with the page
fault and retry the remainder of the request.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/direct-io.c  |    6 ++++++
 include/linux/iomap.h |    7 +++++++
 2 files changed, 13 insertions(+)

--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -581,6 +581,12 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 	if (iov_iter_rw(iter) == READ && iomi.pos >= dio->i_size)
 		iov_iter_revert(iter, iomi.pos - dio->i_size);
 
+	if (ret == -EFAULT && dio->size && (dio_flags & IOMAP_DIO_PARTIAL)) {
+		if (!(iocb->ki_flags & IOCB_NOWAIT))
+			wait_for_completion = true;
+		ret = 0;
+	}
+
 	/* magic error code to fall back to buffered I/O */
 	if (ret == -ENOTBLK) {
 		wait_for_completion = true;
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -330,6 +330,13 @@ struct iomap_dio_ops {
   */
 #define IOMAP_DIO_OVERWRITE_ONLY	(1 << 1)
 
+/*
+ * When a page fault occurs, return a partial synchronous result and allow
+ * the caller to retry the rest of the operation after dealing with the page
+ * fault.
+ */
+#define IOMAP_DIO_PARTIAL		(1 << 2)
+
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags);


