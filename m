Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFA9669D51
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 17:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjAMQKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 11:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjAMQKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 11:10:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185B76A0C4
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 08:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673625763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OaB1tuR7bl+tjb/8nrjisj8jrifsB6lEaiL62y6xQOE=;
        b=cx0Neg/p2y50k42WzPqZXg2hUFwvY96dj4WOp2BTJB+mH6EXwRUW275OxReKTq+8CJTYmg
        TKrocPEyW3s+sZjkcWLmOQpZyvrvh0MRP35lHUl4zWzpuhHOZS6OJZeridghJBKYEwSQjp
        nMvhQ8MMZG9W13N1Tsrr9GacOVBUfGI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-eMkQ1jAROdmWllm4vK-TgA-1; Fri, 13 Jan 2023 11:02:35 -0500
X-MC-Unique: eMkQ1jAROdmWllm4vK-TgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E28D01C29D51;
        Fri, 13 Jan 2023 16:02:34 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E0442026D76;
        Fri, 13 Jan 2023 16:02:34 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Benjamin LaHaise <bcrl@kvack.org>
Cc:     Seth Jenkins <sethjenkins@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: fix mremap after fork null-deref
References: <20221104212519.538108-1-sethjenkins@google.com>
        <x49tu0wlv0c.fsf@segfault.boston.devel.redhat.com>
        <CALxfFW5d05H-nFuDdUDS4xVDKMgkV1vvEBAmw10h3-jMVb-PZw@mail.gmail.com>
        <x49ilhbl9qd.fsf@segfault.boston.devel.redhat.com>
        <20230112220939.GO19133@kvack.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Fri, 13 Jan 2023 11:06:31 -0500
In-Reply-To: <20230112220939.GO19133@kvack.org> (Benjamin LaHaise's message of
        "Thu, 12 Jan 2023 17:09:39 -0500")
Message-ID: <x49edryl8qg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Ben,

Thanks for taking the time to chime in.

Benjamin LaHaise <bcrl@kvack.org> writes:

> On Thu, Jan 12, 2023 at 04:32:42PM -0500, Jeff Moyer wrote:
>> With the patch I proposed (flagging the ring buffer with VM_DONTCOPY),
>> the child process would still be unable to submit and reap I/Os via the
>> aio system calls.  What changes is that the child process would now be
>> unable to reap completions via the shared ring buffer.  In fact, because
>> the ring is no longer mapped in the child process, any attempt to access
>> that memory would result in a segmentation fault.  However, I would be
>> very surprised if the interface was being used in this way.
>> 
>> > If we're okay with this change though, I think it makes sense.
>> 
>> My preference is to make the interface consistent.  I think setting
>> VM_DONTCOPY on the mapping is the right way forward.  I'd welcome other
>> opinions on whether the potential risk is worth it.
>
> VM_DONTCOPY makes sense, but a SEGV is a pretty bad failure mode.  Any
> process reaping events in the child after fork() isn't going to be
> consistent in behaviour, and is able to see partial completion of an I/O
> and other inconsistencies, so they're going to be subtly broken at best.
>
> Unfortunately, we have no way of knowing if this behaviour is exercised
> anywhere without changing it and waiting for someone to holler.

OK, so it sounds like you would rather err on the side of caution.
That's fine with me.

Seth, I'll go back and review your patch.

Thanks!
Jeff

