Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3597970A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390875AbfG2T5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404020AbfG2Ty0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134C82054F;
        Mon, 29 Jul 2019 19:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430065;
        bh=+HbxcW2LTONTYqsfB4l18CKET5zvsNbmTcxRty83vN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3+IHtLKj9Fj0u7ibIUkqDPfldybPKIvD5iqSrVMSxRGboktH0t8o1RP0bmVwaR9o
         rCo/ksZWxtLGQ8HcWKURXpiqloOITrXHWlgS+wILWjglYoXaJ8NdDV5pnWkpk8a/St
         3q/0VILvjfOfG5jPF6yjt90PmAmK5gAPQH5R8pZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Martijn Coenen <maco@android.com>
Subject: [PATCH 5.2 184/215] binder: Set end of SG buffer area properly.
Date:   Mon, 29 Jul 2019 21:23:00 +0200
Message-Id: <20190729190812.095573430@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martijn Coenen <maco@android.com>

commit a56587065094fd96eb4c2b5ad65571daad32156d upstream.

In case the target node requests a security context, the
extra_buffers_size is increased with the size of the security context.
But, that size is not available for use by regular scatter-gather
buffers; make sure the ending of that buffer is marked correctly.

Acked-by: Todd Kjos <tkjos@google.com>
Fixes: ec74136ded79 ("binder: create node flag to request sender's security context")
Signed-off-by: Martijn Coenen <maco@android.com>
Cc: stable@vger.kernel.org # 5.1+
Link: https://lore.kernel.org/r/20190709110923.220736-1-maco@android.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3239,7 +3239,8 @@ static void binder_transaction(struct bi
 	buffer_offset = off_start_offset;
 	off_end_offset = off_start_offset + tr->offsets_size;
 	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
-	sg_buf_end_offset = sg_buf_offset + extra_buffers_size;
+	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
+		ALIGN(secctx_sz, sizeof(u64));
 	off_min = 0;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {


