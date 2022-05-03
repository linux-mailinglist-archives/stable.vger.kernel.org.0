Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741C3518EE2
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 22:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiECUjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 16:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiECUjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 16:39:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E71822511
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651610148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9WL0f505i8Pp1YtLZ1Tq4Pg7kENHqa7dCqxxwEudp7o=;
        b=ZziI5oS0FfB9NsNccZXHkoQ15g3sOpCbMwWzcgkDBQbKA8OwY3v61dLbcFV//Pv01W7Cqg
        0J7M8F37g1UrqUKJxuWnyf9V5V5VJcv8zDeTWdBTuQOb4tgN0SQj6BBtEs/xCahzdrgUr4
        /Q8xC9szwTyZnJl2BIKU/pQWk4e2ayQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-wpgLQa1GOV2RdNpNCMvw_Q-1; Tue, 03 May 2022 16:35:46 -0400
X-MC-Unique: wpgLQa1GOV2RdNpNCMvw_Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2E2B8D9A2D;
        Tue,  3 May 2022 20:35:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB3EF54CAF3;
        Tue,  3 May 2022 20:35:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 243KZjRr011586;
        Tue, 3 May 2022 16:35:45 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 243KZj6w011582;
        Tue, 3 May 2022 16:35:45 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 3 May 2022 16:35:44 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH v4.9] dm: interlock pending dm_io and
 dm_wait_for_bios_completion
Message-ID: <alpine.LRH.2.02.2205031634520.11434@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport of the patch 9f6dc6337610 ("dm: interlock pending dm_io
and dm_wait_for_bios_completion") for the kernel 4.9.

The bugs fixed by this patch can cause random crashing when reloading dm
table, so it is eligible for stable backport.

Note that the kernel 4.9 uses md->pending to count the number of
in-progress I/Os and md->pending is decremented after dm_stats_account_io,
so the race condition doesn't really exist there (except for missing
smp_rmb()).

The percpu variable md->pending_io is not needed in the stable kernels,
because md->pending counts the same value, so it is not backported.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>

---
 drivers/md/dm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2022-04-30 19:03:08.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2022-04-30 19:03:46.000000000 +0200
@@ -2027,6 +2027,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb(); /* paired with atomic_dec_return in end_io_acct */
+
 	return r;
 }
 

