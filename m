Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2CE67DE74
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjA0HXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjA0HXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:23:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7810C4FADA;
        Thu, 26 Jan 2023 23:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF39AB81FAB;
        Fri, 27 Jan 2023 07:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04640C433EF;
        Fri, 27 Jan 2023 07:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804189;
        bh=gAw5rbdFnQhdRes3YYkMRa7SMi5flLfIe+oTP1Jv9Ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oc2OvVx71VUCwmAaD7jG5dufv0NZShl/0soHMSl4gJ8j+D5XYR6ov+jHFAqBzjhFC
         6btLEVumRQGjQ/n2Vk2FG7/UqnZnObzJr9RKUnhFrXfoB0n/l8UeL+jrEa3SDQlPiE
         RK/0Mydd8DVQuMSch96lrm4n78DtVTj5Lf5ssFeo=
Date:   Fri, 27 Jan 2023 08:23:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Do not return host topology information
 from KVM_GET_SUPPORTED_CPUID
Message-ID: <Y9N72sE4eEOYDKzG@kroah.com>
References: <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com>
 <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
 <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com>
 <CALMp9eRKp_4j_Q0j1HYP2itT2+z3pRotQK8LwScMsaGF5FpARA@mail.gmail.com>
 <dec8c012-885a-6ed8-534e-4a5f0a435025@redhat.com>
 <CALMp9eSyVWGS2HQVwwwViE6S_uweiOiFucqa3keuoUjNz9rKqA@mail.gmail.com>
 <f322cce0-f83a-16d9-9738-f47f265b41d8@redhat.com>
 <CALMp9eTpbwQP3QsqpOBsDb0soLpsv9FZA=ivZUmf2GJgBxhfmw@mail.gmail.com>
 <b3820c5c-370b-44f1-7dac-544e504bc61a@redhat.com>
 <CALMp9eQe__xPe9JjgpN_jq-zB2UUqBKYrrMpGvJOjohT=gK2=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQe__xPe9JjgpN_jq-zB2UUqBKYrrMpGvJOjohT=gK2=Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 12:45:58PM -0800, Jim Mattson wrote:
> On Thu, Jan 26, 2023 at 9:47 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 1/26/23 17:06, Jim Mattson wrote:
> > >>> Sadly, there isn't a single kernel involved. People running our VMM on
> > >>> their desktops are going to be impacted as soon as this patch hits
> > >>> that distro. (I don't know if I can say which distro that is.) So, now
> > >>> we have to get the VMM folks to urgently accommodate this change and
> > >>> get a new distribution out.
> > >>
> > >> Ok, this is what is needed to make a more informed choice.  To be clear,
> > >> this is _still_ not public (for example it's not ChromeOS), so there is
> > >> at least some control on what version of the VMM they use?  Would it
> > >> make sense to buy you a few months by deferring this patch to Linux 6.3-6.5?
> > >
> > > Mainline isn't a problem. I'm more worried about 5.19 LTS.
> >
> > 5.19 is not LTS, is it?  This patch is only in 6.1.7 and 6.1.8 as far as
> > stable kernels is concerned, should I ask Greg to revert it there?
> 
> It came to my attention when commit 196c6f0c3e21 ("KVM: x86: Do not
> return host topology information from KVM_GET_SUPPORTED_CPUID") broke
> some of our tests under 5.10 LTS.
> 
> If it isn't bound for linux-5.19-y, then we have some breathing room.

5.19 is long end-of-life, it dropped off of being maintained back in
October of last year.

You can always use the front page of kernel.org to determine what is
still being maintained.

thanks,

greg k-h
