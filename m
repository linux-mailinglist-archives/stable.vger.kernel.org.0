Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0BB518F0B
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 22:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiECUlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 16:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiECUlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 16:41:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFB8722511
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651610268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=NsLNAM8p1zbNymJVXW/N1RfIhmN1FizvTgfEAqRjhHA=;
        b=TtiQVqVj0/NyrDohB7tv4mIBh8oIUUqXMrOajjgnragQhUPxIV1rzoeqF35DvcpJ67+MfP
        YpblUR20bHuq6bwUOZV6V+kGHE0iStCS4W+2NYZuVVO54UljECv6ZVxwLwkhZHs7+iS28J
        cklj7Z/cyeMP2HYFEC1RPjgMZqNqrbI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-9j9TrYmxNxaa0ZTX0aXAhw-1; Tue, 03 May 2022 16:37:46 -0400
X-MC-Unique: 9j9TrYmxNxaa0ZTX0aXAhw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05F1210187E0;
        Tue,  3 May 2022 20:37:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F31AC551E99;
        Tue,  3 May 2022 20:37:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 243Kbjv6011673;
        Tue, 3 May 2022 16:37:45 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 243Kbjx4011669;
        Tue, 3 May 2022 16:37:45 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 3 May 2022 16:37:45 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH v4.14] dm: interlock pending dm_io and
 dm_wait_for_bios_completion
Message-ID: <alpine.LRH.2.02.2205031635530.11434@file01.intranet.prod.int.rdu2.redhat.com>
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
and dm_wait_for_bios_completion") for the kernel 4.14.

The bugs fixed by this patch can cause random crashing when reloading dm
table, so it is eligible for stable backport.

Note that the kernel 4.14 uses md->pending to count the number of
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
--- linux-stable.orig/drivers/md/dm.c	2022-04-30 19:16:55.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2022-04-30 19:16:55.000000000 +0200
@@ -2230,6 +2230,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb(); /* paired with atomic_dec_return in end_io_acct */
+
 	return r;
 }
 

