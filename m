Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0771D8430
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732773AbgERSJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733123AbgERSGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:06:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1AD62087D;
        Mon, 18 May 2020 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825170;
        bh=O+15IHTHinbKwCpP8DrhT0xXUmz7VokApZ3tUFMr470=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzIqi1UH/vVNLHFP557F6epjaLuBBvACf6ZGjgSFLit2rsYeDpzYMUrn8znJP7JIQ
         8T7N1xUzkgmZpjj7FMx8Itv7lYe20kIcjGsC5hL/whkif1r96q3PRPx8UT6irzuRmh
         DAVqFJSwikS0QuuJCl//i1yJ+9YgTWsEbqseMJKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam McCoy <adam@forsedomani.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.6 156/194] cifs: fix leaked reference on requeued write
Date:   Mon, 18 May 2020 19:37:26 +0200
Message-Id: <20200518173544.207122094@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam McCoy <adam@forsedomani.com>

commit a48137996063d22ffba77e077425f49873856ca5 upstream.

Failed async writes that are requeued may not clean up a refcount
on the file, which can result in a leaked open. This scenario arises
very reliably when using persistent handles and a reconnect occurs
while writing.

cifs_writev_requeue only releases the reference if the write fails
(rc != 0). The server->ops->async_writev operation will take its own
reference, so the initial reference can always be released.

Signed-off-by: Adam McCoy <adam@forsedomani.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifssmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2138,8 +2138,8 @@ cifs_writev_requeue(struct cifs_writedat
 			}
 		}
 
+		kref_put(&wdata2->refcount, cifs_writedata_release);
 		if (rc) {
-			kref_put(&wdata2->refcount, cifs_writedata_release);
 			if (is_retryable_error(rc))
 				continue;
 			i += nr_pages;


