Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0954D131F
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 10:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242742AbiCHJQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 04:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiCHJQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 04:16:27 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B034091D
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 01:15:31 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u1so27352460wrg.11
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 01:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=A67AlhskYiiSCgOgMfxOM8VtIq/AZbd8NuTpwj7+O9E=;
        b=ru0ZMHr+H3SzWxJ5c6z+akoloC2eYUtrZZDP/bO0aM7LsTlONsVtFwFb/M0zFfOyf8
         ElYyllP0vUy0v0lbdXhcPYe4WzX7ped6as7iO4g3cCmAJaWF+VZOQBy9ug42T440YpRF
         GUNi+yilLEuh339WAnK2G0QLo/WGwWiiz6vZ/8lCD4bCmK0TFsJdNrkLS30iJ3WFSL83
         SnRbArDjmbspkK6+UFofwFDjTRmpVBG0W/hwgBdGn/4koeWXQAPzHE106Pho9SQPGPFW
         5I7zM7fAiaC+9DyvnsQWd0h5V5zBpL4P1Hkpp1YpcllRm9Tk5tHYCkPE7/0BSdXqV9ip
         lg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=A67AlhskYiiSCgOgMfxOM8VtIq/AZbd8NuTpwj7+O9E=;
        b=EM0UBqFnycdasbt4dMCgW2tPxywaztRJ1ejtVny2+oTr7uxRF9E5kOvhfx/mQ9550Z
         XARAqfapI69B51KHCn2ag4/1WyqZfrv1DiDXhw7gJ0rYdH1FFg2Vews4eOYk4q2vFp0N
         RCv5hje98tQI8J7WhxHqOlcDe8EapSct4nt+0EZhM6yO12rCNql+EMONfx8pAXRR1zFM
         7YdylCuBLE3/Vw5McJKlylqQ5v78M/9WU4gmWtiF+sE5GbS1HCFB23cC+HC0sdmUnyzz
         ayQLOvZi1QsU56jL+4UPDviZD6zTH20ZMdm9vnexn25C0T8YxvmaZikSaRcpjU3BBRXq
         jc6A==
X-Gm-Message-State: AOAM531awk8oDjsg4RQ+KhJCBNYYXo20sGvuRZcCwy3Nfd1aEj7tfSPC
        STDONz6S3tvIB8EHsCT1kDDoGA==
X-Google-Smtp-Source: ABdhPJy9FjH8HkL7B/j6ELLmslkDBEpsnA6isr76dWseTv/sIBWInh7Ka7q7NHwbZ1Go3z4nK7Q0BQ==
X-Received: by 2002:adf:e448:0:b0:1ea:c7b6:782 with SMTP id t8-20020adfe448000000b001eac7b60782mr11302842wrm.29.1646730930092;
        Tue, 08 Mar 2022 01:15:30 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id h13-20020adff18d000000b001f1de9f930esm15425518wro.81.2022.03.08.01.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 01:15:29 -0800 (PST)
Date:   Tue, 8 Mar 2022 09:15:27 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yicer3yGg5rrdSIs@google.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yicalf1I6oBytbse@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Mar 2022, Greg KH wrote:

> On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> > On Mon, 07 Mar 2022, Greg KH wrote:
> > 
> > > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > 
> > > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > > capture possible future race conditions which may pop up over time.
> > > > 
> > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > 
> > > > Cc: <stable@vger.kernel.org>
> > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/vhost/vhost.c | 10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > > 
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >  	int i;
> > > >  
> > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > +		/* No workers should run here by design. However, races have
> > > > +		 * previously occurred where drivers have been unable to flush
> > > > +		 * all work properly prior to clean-up.  Without a successful
> > > > +		 * flush the guest will malfunction, but avoiding host memory
> > > > +		 * corruption in those cases does seem preferable.
> > > > +		 */
> > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > 
> > > So you are trading one syzbot triggered issue for another one in the
> > > future?  :)
> > > 
> > > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > > you want that to happen?
> > 
> > No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> 
> Has it changed?  Last I looked, it did trigger on WARN_* calls, which
> has resulted in a huge number of kernel fixes because of that.

Everything is customisable in syzkaller, so maybe there are specific
builds which panic_on_warn enabled, but none that I'm involved with
do.

Here follows a topical example.  The report above in the Link: tag
comes with a crashlog [0].  In there you can see the WARN() at the
bottom of vhost_dev_cleanup() trigger many times due to a populated
(non-flushed) worker list, before finally tripping the BUG() which
triggers the report:

[0] https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000

> > > And what happens if the mutex is locked _RIGHT_ after you checked it?
> > > You still have a race...
> > 
> > No, we miss a warning that one time.  Memory is still protected.
> 
> Then don't warn on something that doesn't matter.  This line can be
> dropped as there's nothing anyone can do about it, right?

You'll have to take that point up with Michael.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
