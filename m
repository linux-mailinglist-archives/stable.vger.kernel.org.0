Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233283DD975
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhHBOAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234854AbhHBN65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:58:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1242C61102;
        Mon,  2 Aug 2021 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912524;
        bh=yosduxXD2clLVed6Vwmw2V0gfLWlIOHxG7KM7qRW608=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khX/bFCkTEudaGXxgC2MxFmvQaUCMhrs/+v4K380ZL6UNjUOAmtjWMlhBjuWgusLe
         d+k9fykGPLpZRNwJswOZW8YnVmVD5VKOiVQsTXGhdsKxBZDSHhY4MG1Sfw2R9LN/kw
         Wi98lSIGJEYvoxNexzXWiwx+H3S+LlHYj9geeF40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Ebner <f.ebner@proxmox.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 032/104] io_uring: dont block level reissue off completion path
Date:   Mon,  2 Aug 2021 15:44:29 +0200
Message-Id: <20210802134345.073963914@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit ef04688871f3386b6d40ade8f5c664290420f819 upstream.

Some setups, like SCSI, can throw spurious -EAGAIN off the softirq
completion path. Normally we expect this to happen inline as part
of submission, but apparently SCSI has a weird corner case where it
can happen as part of normal completions.

This should be solved by having the -EAGAIN bubble back up the stack
as part of submission, but previous attempts at this failed and we're
not just quite there yet. Instead we currently use REQ_F_REISSUE to
handle this case.

For now, catch it in io_rw_should_reissue() and prevent a reissue
from a bogus path.

Cc: stable@vger.kernel.org
Reported-by: Fabian Ebner <f.ebner@proxmox.com>
Tested-by: Fabian Ebner <f.ebner@proxmox.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2457,6 +2457,12 @@ static bool io_rw_should_reissue(struct
 	 */
 	if (percpu_ref_is_dying(&ctx->refs))
 		return false;
+	/*
+	 * Play it safe and assume not safe to re-import and reissue if we're
+	 * not in the original thread group (or in task context).
+	 */
+	if (!same_thread_group(req->task, current) || !in_task())
+		return false;
 	return true;
 }
 #else


