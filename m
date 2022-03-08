Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FD54D15AF
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 12:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiCHLIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 06:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbiCHLIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 06:08:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 020CCBF6F
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 03:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pn0Gp2y98eJDXuA8y7deIirBU9DlxAAqoNDwwNiF2I=;
        b=jNLX3zOFYtAmTk2HxDEePZb4j5tVMW/cNKAOpX4bHnV521qfEHllqQyGRFxJn53xNOW8L8
        c932YASnc5qQm98Kw/dspveJ6sn+3mtm//IMzc6Ia5bW5HhHFn8Cfw9vBGDe9czuRjzl74
        lIEWtGBCZxb4GtKen7ftFNR4qYu8S48=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-IMGkNxfwNWyQwlNiGLa-rA-1; Tue, 08 Mar 2022 06:07:32 -0500
X-MC-Unique: IMGkNxfwNWyQwlNiGLa-rA-1
Received: by mail-ej1-f71.google.com with SMTP id go11-20020a1709070d8b00b006cf0d933739so8492633ejc.5
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 03:07:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+pn0Gp2y98eJDXuA8y7deIirBU9DlxAAqoNDwwNiF2I=;
        b=MVaIVdOD8h+ZhGnGJ01dxuR+nocXis9SiUs2aH7aUyYe6zN1z2KZWHY6pvKyxYy0hq
         QiA2AXd1eVF2i1aomCyrehwHE7jCkG1GEvSXrQl3ERoJgqUFbB7c98ugkbGJVbKhXFz4
         ZevSViQcIJLwarXOQDVP1pDjH8KMrtn91vIwb7sn8yygVWjuK+0OeySX8aCssxdzCtMX
         AoeWHh5pYn3yKKZJuwWHH+7htFBot7HgUoQRZ2thlMK2km9fMtbbnOK1TE1OdFBOHZT0
         5LhYCJT/CdYIumh0MmOPvfwkYEJ8Vze3Ersu/siRgF43d4stzDzny3g3LozQOFogAdzd
         RtGg==
X-Gm-Message-State: AOAM532zxLNj5+Mwho4EIY+DUnamIO7ANa8a9zf96W6WyCmq36BTb1DK
        jUMAUM4jELOq43WIl60T8YI8LfSYe3cy2Ty/hm+QBcfEp7NGqQJdgtd6pbTvMNx5cnMp8ZztiiL
        BVsjwguSSczMCqutF
X-Received: by 2002:a17:907:6d1d:b0:6d8:9fc8:b1e1 with SMTP id sa29-20020a1709076d1d00b006d89fc8b1e1mr12410556ejc.466.1646737650942;
        Tue, 08 Mar 2022 03:07:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxesTWxnr9yva5EqLXO5ZOYMLukOGg2mvmb/yiXq/BaIek5yrIlr+WBV842eb0PxoGVnYMIYQ==
X-Received: by 2002:a17:907:6d1d:b0:6d8:9fc8:b1e1 with SMTP id sa29-20020a1709076d1d00b006d89fc8b1e1mr12410534ejc.466.1646737650745;
        Tue, 08 Mar 2022 03:07:30 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id e12-20020a056402190c00b0041615cd434csm5336300edz.60.2022.03.08.03.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 03:07:30 -0800 (PST)
Date:   Tue, 8 Mar 2022 06:07:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220308060705-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <20220307173439-mutt-send-email-mst@kernel.org>
 <YicNXOlH8al/Rlk3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YicNXOlH8al/Rlk3@google.com>
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

On Tue, Mar 08, 2022 at 08:01:32AM +0000, Lee Jones wrote:
> On Mon, 07 Mar 2022, Michael S. Tsirkin wrote:
> 
> > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Pls just basically copy the code comment here. this is just confuses.
> > 
> > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > capture possible future race conditions which may pop up over time.
> > > 
> > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > 
> > And this is a bug we already fixed, right?
> 
> Well, this was the bug I set out to fix.
> 
> I didn't know your patch was in flight at the time.
> 
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > 
> > not really applicable anymore ...
> 
> I can remove these if it helps.

yes let's do that pls.

> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog

