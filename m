Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15A322EFD9
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgG0OTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731406AbgG0OTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F8F020FC3;
        Mon, 27 Jul 2020 14:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859587;
        bh=iUh9dnBwToXwhWtzVBeJCBPtLhp603IQ6o4UTkg+7LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8H4A4CHjrZbL7xjtZwXELLsozo3S5vXe2P/PcG7E1MuA7TizuRRV+8eYFhjtJHYJ
         q9QCnpyHJShu29UCr01roK2LAW8SouFAHYkRzY4BQWWfSFkIdgnY4hgAtd38I00+16
         aC46uZbWTccDN5F/4hQMykndixBlXTB97iLD2x5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeongseok Kim <hyeongseok@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7 029/179] exfat: fix wrong size update of stream entry by typo
Date:   Mon, 27 Jul 2020 16:03:24 +0200
Message-Id: <20200727134934.084625370@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeongseok Kim <hyeongseok@gmail.com>

commit 41e3928f8c58184fcf0bb22e822af39a436370c7 upstream.

The stream.size field is updated to the value of create timestamp
of the file entry. Fix this to use correct stream entry pointer.

Fixes: 29bbb14bfc80 ("exfat: fix incorrect update of stream entry in __exfat_truncate()")
Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exfat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -175,7 +175,7 @@ int __exfat_truncate(struct inode *inode
 			ep2->dentry.stream.size = 0;
 		} else {
 			ep2->dentry.stream.valid_size = cpu_to_le64(new_size);
-			ep2->dentry.stream.size = ep->dentry.stream.valid_size;
+			ep2->dentry.stream.size = ep2->dentry.stream.valid_size;
 		}
 
 		if (new_size == 0) {


