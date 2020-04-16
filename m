Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5551AC770
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbgDPOzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441805AbgDPN4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:56:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1649A20786;
        Thu, 16 Apr 2020 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045393;
        bh=s/3kHi8il/W5VDn7fjf0NkJJm/Hn4ruaFDq8kuwR8lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=In0sonq0goaPJfUgC+cBAIESVZXRXBE1NIVMLgQmMDukE8NCr+ZFKRJ/B3chtjl5p
         0jvJpgSNb5X7c5ugKRY7wb47s/8BWqaHWif4Xk8YxbrBd20GJj6Q8ippm1pT/Dqf1c
         Wyi+L9BPlyyyb4MIXmuNQtPdbydy9Rr/2F5rk6rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 116/254] io_uring: remove bogus RLIMIT_NOFILE check in file registration
Date:   Thu, 16 Apr 2020 15:23:25 +0200
Message-Id: <20200416131340.746421182@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c336e992cb1cb1db9ee608dfb30342ae781057ab upstream.

We already checked this limit when the file was opened, and we keep it
open in the file table. Hence when we added unit_inflight to the count
we want to register, we're doubly accounting these files. This results
in -EMFILE for file registration, if we're at half the limit.

Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5426,13 +5426,6 @@ static int __io_sqe_files_scm(struct io_
 	struct sk_buff *skb;
 	int i, nr_files;
 
-	if (!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
-		unsigned long inflight = ctx->user->unix_inflight + nr;
-
-		if (inflight > task_rlimit(current, RLIMIT_NOFILE))
-			return -EMFILE;
-	}
-
 	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
 	if (!fpl)
 		return -ENOMEM;


