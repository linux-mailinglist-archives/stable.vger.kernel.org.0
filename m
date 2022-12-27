Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7203265684F
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 09:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiL0IRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 03:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiL0IQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 03:16:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0952F2606
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 00:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672128975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ljg5NU43DDRYF7vGHKsQzw7qYWtLIbrheA8Q3DkBSgg=;
        b=AFD3UWPOetQ2phXrCdNdQRNkz7FNxKcyc+3rYsupIZwS4LBPLFaEG1AFw/94M5kEuJvgwA
        urzUVgblsFIzuH4qs6OXevSRIlsACvQnGe8oEzWzvKS0FYqaW0t5f17iBa+7U7GByi+Mw5
        3v9VrV47LOj1okdQSdl5YR6GXVoMD8g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-EkbfqwXUPfGAI6qwWpJCRw-1; Tue, 27 Dec 2022 03:16:09 -0500
X-MC-Unique: EkbfqwXUPfGAI6qwWpJCRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57A011C0A582;
        Tue, 27 Dec 2022 08:16:09 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 528F8140EBF6;
        Tue, 27 Dec 2022 08:16:05 +0000 (UTC)
Date:   Tue, 27 Dec 2022 16:16:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Changhui Zhong <czhong@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org
Subject: Re: [bug report] Unable to handle kernel NULL pointer dereference at
 virtual address 0000000000000058
Message-ID: <Y6qpwYaPOxgsZjp9@T590>
References: <CAGVVp+WS5aHiF2Odc-C+fO56qKyV7vPsPRz35v9eWsPJDNj=ng@mail.gmail.com>
 <Y6qmJT7H14Dfhn5y@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6qmJT7H14Dfhn5y@T590>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Dec 27, 2022 at 04:00:37PM +0800, Ming Lei wrote:
> Hi Changhui,
> 
> On Mon, Dec 26, 2022 at 11:11:44AM +0800, Changhui Zhong wrote:
> > Hello,
> > Below issue was triggered with ( v6.0.15-996-g988abd970566), pls help check it
> 
> There isn't commit 988abd970566 in linux-6.0.y, so I guess the above
> build must integrate other patches not in 6.0.y
> 
> From the source code in cki build[1], looks commit 80bd4a7aab4c ("blk-mq: move
> the srcu_struct used for quiescing to the tagset") is included, but
> commit 8537380bb988 ("blk-mq: skip non-mq queues in blk_mq_quiesce_queue")
> is missed, that is why this panic is triggered.

I just found that patch of blk-mq-move-the-srcu_struct-used-for-quiescing-to-th.patch
is queued in stable-queue/queue-6.0, but that patch depends on
commit 8537380bb988 ("blk-mq: skip non-mq queues in blk_mq_quiesce_queue").
which needs to be added to queue-6.0 too.


Thanks,
Ming

