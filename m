Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11597188188
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgCQLEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgCQLEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79726206EC;
        Tue, 17 Mar 2020 11:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443059;
        bh=jKQaUfpQcMm0yosTefLi57T/N5a+Oc6PT7XK/yITYZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8QbhetYwgdPJavJa7gWIE/T5L66MFnU5yS0NYczireB/Iu7AYMguPt1ptrz7UtF6
         bF67+3tTKEUFegdZ+cwt+aJOlxSwOU1Yr5eRs5R3xUQK91+peNsoGNSr4snM5EMXEj
         OUxj/cDLcjALMWXgZBaR71+s7A0UrLB0u5yQzANw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 083/123] blk-iocost: fix incorrect vtime comparison in iocg_is_idle()
Date:   Tue, 17 Mar 2020 11:55:10 +0100
Message-Id: <20200317103316.366842551@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit dcd6589b11d3b1e71f516a87a7b9646ed356b4c0 upstream.

vtimes may wrap and time_before/after64() should be used to determine
whether a given vtime is before or after another. iocg_is_idle() was
incorrectly using plain "<" comparison do determine whether done_vtime
is before vtime. Here, the only thing we're interested in is whether
done_vtime matches vtime which indicates that there's nothing in
flight. Let's test for inequality instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-iocost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1318,7 +1318,7 @@ static bool iocg_is_idle(struct ioc_gq *
 		return false;
 
 	/* is something in flight? */
-	if (atomic64_read(&iocg->done_vtime) < atomic64_read(&iocg->vtime))
+	if (atomic64_read(&iocg->done_vtime) != atomic64_read(&iocg->vtime))
 		return false;
 
 	return true;


