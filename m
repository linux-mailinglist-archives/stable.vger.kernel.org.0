Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47617745B7
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405198AbfGYFp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405187AbfGYFp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA66022BEB;
        Thu, 25 Jul 2019 05:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033528;
        bh=90uT0hQzl2ry1AVARiOZO395TTaUxfa8Y/uH8XxG6uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmBxkW/n0ABkOnfTgu1ot+W5PhXsAli7xskcomXQXTLe7Lnoxqhx+XLaSkb+fBGAf
         PNAFMqSDVO2MNBRrvUi6RvBNHUFK9SmzArPGuHB0S5GNI2iMnOBZYIK9cx6D1MpqcQ
         drKZTdVg2LT7mQklUQlSDrP5j0M5yX5d5/cOCf2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 212/271] media: videobuf2-dma-sg: Prevent size from overflowing
Date:   Wed, 24 Jul 2019 21:21:21 +0200
Message-Id: <20190724191713.256429890@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 14f28f5cea9e3998442de87846d1907a531b6748 upstream.

buf->size is an unsigned long; casting that to int will lead to an
overflow if buf->size exceeds INT_MAX.

Fix this by changing the type to unsigned long instead. This is possible
as the buf->size is always aligned to PAGE_SIZE, and therefore the size
will never have values lesser than 0.

Note on backporting to stable: the file used to be under
drivers/media/v4l2-core, it was moved to the current location after 4.14.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -59,7 +59,7 @@ static int vb2_dma_sg_alloc_compacted(st
 		gfp_t gfp_flags)
 {
 	unsigned int last_page = 0;
-	int size = buf->size;
+	unsigned long size = buf->size;
 
 	while (size > 0) {
 		struct page *pages;


