Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EACB5EA4DE
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiIZL4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238364AbiIZLx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:53:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8EE1F636;
        Mon, 26 Sep 2022 03:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD395B80976;
        Mon, 26 Sep 2022 10:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3CFC433C1;
        Mon, 26 Sep 2022 10:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189355;
        bh=e0dN7MrU8TIdgGaJFqTE0O157ZpkWC3tkGGG1Eoh4NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/zoiy62DIHaoDdTcyjEDngzyNrYa+d6D3dn8UmzEcJ1VPyEBYqPLH2ChXmjvpkKp
         zAYARpqcfBcZgNG9VrHbGw/+S03X4ogJSgj0iabJDylsKlze/9blm/vT0Bof/7nN9v
         7vFXIM8yFkZwkqE4WIv+lGqddCIK3GaxcCFNdjwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Homin Rhee <hominlab@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 159/207] io_uring: ensure that cached task references are always put on exit
Date:   Mon, 26 Sep 2022 12:12:28 +0200
Message-Id: <20220926100813.774193328@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit e775f93f2ab976a2cdb4a7b53063cbe890904f73 upstream.

io_uring caches task references to avoid doing atomics for each of them
per request. If a request is put from the same task that allocated it,
then we can maintain a per-ctx cache of them. This obviously relies
on io_uring always pruning caches in a reliable way, and there's
currently a case off io_uring fd release where we can miss that.

One example is a ring setup with IOPOLL, which relies on the task
polling for completions, which will free them. However, if such a task
submits a request and then exits or closes the ring without reaping
the completion, then ring release will reap and put. If release happens
from that very same task, the completed request task refs will get
put back into the cache pool. This is problematic, as we're now beyond
the point of pruning caches.

Manually drop these caches after doing an IOPOLL reap. This releases
references from the current task, which is enough. If another task
happens to be doing the release, then the caching will not be
triggered and there's no issue.

Cc: stable@vger.kernel.org
Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
Reported-by: Homin Rhee <hominlab@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -10951,6 +10951,9 @@ static __cold void io_ring_ctx_wait_and_
 		io_poll_remove_all(ctx, NULL, true);
 		/* if we failed setting up the ctx, we might not have any rings */
 		io_iopoll_try_reap_events(ctx);
+		/* drop cached put refs after potentially doing completions */
+		if (current->io_uring)
+			io_uring_drop_tctx_refs(current);
 	}
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);


