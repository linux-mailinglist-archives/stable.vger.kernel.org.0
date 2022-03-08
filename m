Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485E54D1540
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 11:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346036AbiCHK5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 05:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346020AbiCHK5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 05:57:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38522434B3
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 02:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646736966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=THPXJELvuxW6inJpizACi6yZwtZMXDw05fIwiYKfyWA=;
        b=AFna5OAhbefrPrIvyAMsS21MiXx8SjxetTLlJtO9bI72xmqWqMaI5b79ZM33+jUljvqC1M
        pBbMg9X99dgSA9iIaMFF/rKXC1npNbs8kj8fF3ELqZfXoE0XB6N7V4C+xZdp6txXAMUub7
        ikLDpw6rKqt7PnnPSKX2THJnKeDDcao=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-7LC5Kw1HNjmKXjdJLS8OUw-1; Tue, 08 Mar 2022 05:56:05 -0500
X-MC-Unique: 7LC5Kw1HNjmKXjdJLS8OUw-1
Received: by mail-ej1-f72.google.com with SMTP id i14-20020a17090639ce00b006dabe6a112fso4724955eje.13
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 02:56:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=THPXJELvuxW6inJpizACi6yZwtZMXDw05fIwiYKfyWA=;
        b=B4ltueXqMI/CLsdgwPSf8O9S0sqtOC/dc4jBqkkHz+jSvGFkdMrtFgssNSRR4OLTEq
         F9Em0PcSb1JlD7Hs0q+lpRThpHvvsC4sLIYIL9X9eKGd6Mb7JHDKgETA7hQwxafZrWNZ
         on09WWKfSJHEKjM7ELVb3mzsO5KCOJm3K/Jr8nD63rAVoqqmO0PALoSDkJAAolgU9Qmk
         i5zwJQJq+ZKF9HH05phEfyjA3ExGx5N/YmbH0rCLQM7iVizVjrTa8RllYdFWcrrWod/w
         hi5jqdZUuhXKKwpanbj/cTnPvd0cZcsIAp60QU0D1cSE+q6oxOi29EEdSLWBWZV7XZpV
         BilQ==
X-Gm-Message-State: AOAM533Alsf6pg5syfHQiGREJJwh7CcamPPtd51i1fqE3vD0yYrEWsL4
        ZEOv2nB/s9gdckBOe4VKNjZH15VBlR8EJSaWlbCYWVm8nrYM/03TTgvXIsDXPRjjgNewj7RB7XA
        jkHgtWjt9lJUBWLDC
X-Received: by 2002:a17:907:6096:b0:6da:68d2:327f with SMTP id ht22-20020a170907609600b006da68d2327fmr12817791ejc.761.1646736962914;
        Tue, 08 Mar 2022 02:56:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKGG3Z63udeaeH1lPhQJidMdNIksYDzx/dSa/Eol2gRlzn6bu5TRgyUjAEl+sdkcHMtg9aTg==
X-Received: by 2002:a17:907:6096:b0:6da:68d2:327f with SMTP id ht22-20020a170907609600b006da68d2327fmr12817773ejc.761.1646736962624;
        Tue, 08 Mar 2022 02:56:02 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id u5-20020a170906b10500b006ce6fa4f510sm5668769ejy.165.2022.03.08.02.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 02:56:02 -0800 (PST)
Date:   Tue, 8 Mar 2022 05:55:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220308055003-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
 <Yicer3yGg5rrdSIs@google.com>
 <YicolvcbY9VT6AKc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YicolvcbY9VT6AKc@kroah.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 10:57:42AM +0100, Greg KH wrote:
> On Tue, Mar 08, 2022 at 09:15:27AM +0000, Lee Jones wrote:
> > On Tue, 08 Mar 2022, Greg KH wrote:
> > 
> > > On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> > > > On Mon, 07 Mar 2022, Greg KH wrote:
> > > > 
> > > > > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > > 
> > > > > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > > > > capture possible future race conditions which may pop up over time.
> > > > > > 
> > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > > 
> > > > > > Cc: <stable@vger.kernel.org>
> > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > ---
> > > > > >  drivers/vhost/vhost.c | 10 ++++++++++
> > > > > >  1 file changed, 10 insertions(+)
> > > > > > 
> > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > > > > --- a/drivers/vhost/vhost.c
> > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > >  	int i;
> > > > > >  
> > > > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > > > +		/* No workers should run here by design. However, races have
> > > > > > +		 * previously occurred where drivers have been unable to flush
> > > > > > +		 * all work properly prior to clean-up.  Without a successful
> > > > > > +		 * flush the guest will malfunction, but avoiding host memory
> > > > > > +		 * corruption in those cases does seem preferable.
> > > > > > +		 */
> > > > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > > > 
> > > > > So you are trading one syzbot triggered issue for another one in the
> > > > > future?  :)
> > > > > 
> > > > > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > > > > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > > > > you want that to happen?
> > > > 
> > > > No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> > > 
> > > Has it changed?  Last I looked, it did trigger on WARN_* calls, which
> > > has resulted in a huge number of kernel fixes because of that.
> > 
> > Everything is customisable in syzkaller, so maybe there are specific
> > builds which panic_on_warn enabled, but none that I'm involved with
> > do.
> 
> Many systems run with panic-on-warn (i.e. the cloud), as they want to
> drop a box and restart it if anything goes wrong.
> 
> That's why syzbot reports on WARN_* calls.  They should never be
> reachable by userspace actions.
> 
> > Here follows a topical example.  The report above in the Link: tag
> > comes with a crashlog [0].  In there you can see the WARN() at the
> > bottom of vhost_dev_cleanup() trigger many times due to a populated
> > (non-flushed) worker list, before finally tripping the BUG() which
> > triggers the report:
> > 
> > [0] https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000
> 
> Ok, so both happens here.  But don't add a warning for something that
> can't happen.  Just handle it and move on.  It looks like you are
> handling it in this code, so please drop the WARN_ON().
> 
> thanks,
> 
> greg k-h

Hmm. Well this will mean if we ever reintroduce the bug then
syzkaller will not catch it for us :( And the bug is there,
it just results in a hard to reproduce error for userspace.

Not sure what to do here. Export panic_on_warn flag to modules
and check it here?


-- 
MST

