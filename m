Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B6F87C0D
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406791AbfHINtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHINp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:45:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61EFA214C6;
        Fri,  9 Aug 2019 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358355;
        bh=rl5wtz7GbhbAJkl9Cr5yaGsccTUkoDUHnyJBgaxuCjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HmXPEJT1CuxlzhT+cjArIqk2hya+pV8k77pW+n/x/QUbAQOSzfwSe995H6RAB+r/
         Ho6LnG0zynGQ0d83WF+44e+nc8JKk6f05TQT0HOPh7wJtCnDIMjBYiUyUZNLKBdkXl
         3uoIQ/iBxR27CRl+xfQT/CLN4nS8/K297hG+MIOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        xiao jin <jin.xiao@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.4 14/21] block: blk_init_allocated_queue() set q->fq as NULL in the fail case
Date:   Fri,  9 Aug 2019 15:45:18 +0200
Message-Id: <20190809134242.158162001@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>

commit 54648cf1ec2d7f4b6a71767799c45676a138ca24 upstream.

We find the memory use-after-free issue in __blk_drain_queue()
on the kernel 4.14. After read the latest kernel 4.18-rc6 we
think it has the same problem.

Memory is allocated for q->fq in the blk_init_allocated_queue().
If the elevator init function called with error return, it will
run into the fail case to free the q->fq.

Then the __blk_drain_queue() uses the same memory after the free
of the q->fq, it will lead to the unpredictable event.

The patch is to set q->fq as NULL in the fail case of
blk_init_allocated_queue().

Fixes: commit 7c94e1c157a2 ("block: introduce blk_flush_queue to drive flush machinery")
Cc: <stable@vger.kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: xiao jin <jin.xiao@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[groeck: backport to v4.4.y/v4.9.y (context change)]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -870,6 +870,7 @@ blk_init_allocated_queue(struct request_
 
 fail:
 	blk_free_flush_queue(q->fq);
+	q->fq = NULL;
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);


