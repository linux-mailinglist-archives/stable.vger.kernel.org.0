Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3B81D84D6
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgERR7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732078AbgERR7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5197207C4;
        Mon, 18 May 2020 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824777;
        bh=kO+SsJqBdZfucKebNnlQENHm68BrbLM3Hu7Tcq2nX+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPPIR6QJxMx+kp62J9Jg7DHW+NIYmD56Wa+554zZzD1jLEktR0kBkR3oB90yDgXDj
         gSg9o9812n/ovFv00amLDoxjgFT+IFkxZNEX1Ub4Phry4unsKjL9R0jDD3a2Uepa4y
         C3k26wwLixTGVDqJ5ovYZiePmhNir16xCEjVaZkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam McCoy <adam@forsedomani.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.4 120/147] cifs: fix leaked reference on requeued write
Date:   Mon, 18 May 2020 19:37:23 +0200
Message-Id: <20200518173527.940033931@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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
@@ -2135,8 +2135,8 @@ cifs_writev_requeue(struct cifs_writedat
 			}
 		}
 
+		kref_put(&wdata2->refcount, cifs_writedata_release);
 		if (rc) {
-			kref_put(&wdata2->refcount, cifs_writedata_release);
 			if (is_retryable_error(rc))
 				continue;
 			i += nr_pages;


