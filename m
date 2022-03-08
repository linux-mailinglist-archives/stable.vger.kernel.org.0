Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA474D15A0
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 12:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245454AbiCHLGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 06:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346206AbiCHLG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 06:06:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7AD341FBA
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 03:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FCTl0NyGnslmoDNlbPArwT49YkiFqe8KOOW4Ouvu6mc=;
        b=JApNF+vwIE2ehjQ9htzt2cDu97al+gWoWP+6uworga1DVOOu1HmRXFHgIHa/KlgeQrLhvX
        q1ZxbAsyWn9fM4/J6e0vwpCCKidbG7Dp+XGWx8bRUT4OHZLD2L/3tz+3Udy0X5gi/BOPAz
        MJhsw16nAf7pGNXBXHzzWKfyh9j1MMY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-yOgRoAmsMf2cHg5JoLSo5g-1; Tue, 08 Mar 2022 06:05:30 -0500
X-MC-Unique: yOgRoAmsMf2cHg5JoLSo5g-1
Received: by mail-ej1-f72.google.com with SMTP id qf24-20020a1709077f1800b006ce8c140d3dso8508729ejc.18
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 03:05:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FCTl0NyGnslmoDNlbPArwT49YkiFqe8KOOW4Ouvu6mc=;
        b=iOOmCqIb/sB9dJ2QRtWwL4ylxuUbgtsluEVUJU4yH/WDCNmo8JLS0H9mVcRTcSbuxP
         4SCBeqZEwSRC2gIkr+yMrw8I95/clNlwZlpuF5kBxgYhwjzDc3uEG9s1qu4X281rWN05
         Hnlj9sbXm5B7arq4fglMRgMzfBRjM/hdfJiz9dEOIfg2sHQ1kcTjwaK5Yg1BRS2K8VLQ
         65a/h5TnKo2RET8UK55MgXObhnxIYHVpa853Nygpwpd3oQIS576WggtayFtewGjTnd3b
         1s0E/3dJlxiP01EvLBu9icjVG4SPC0XV4SqMKWZkjxDL6Q5j5lbC4gBOpfaugGL3n+4A
         WBtg==
X-Gm-Message-State: AOAM5306hGLGaBJR3jXmTZaxkDxionqfhZ3a321g3ahbn9UYymNED6sq
        yYx8g4KKuLt3iNalX48PXln0pJuqvCsvfO082GC5Mg2/CdSgO7RZQ1u3I2iTV2J+HgQVd6zKIUT
        q+BiotlIZL5EHOg4b
X-Received: by 2002:a17:907:2d22:b0:6da:91fe:15a5 with SMTP id gs34-20020a1709072d2200b006da91fe15a5mr13286734ejc.448.1646737528835;
        Tue, 08 Mar 2022 03:05:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgv7cglanKYuGFfnW0Rf0VAUYwA4cx1PX1P0MLrG9UedzvWygSn4/xGLczSKDMdkoHZTSdZQ==
X-Received: by 2002:a17:907:2d22:b0:6da:91fe:15a5 with SMTP id gs34-20020a1709072d2200b006da91fe15a5mr13286713ejc.448.1646737528603;
        Tue, 08 Mar 2022 03:05:28 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id y12-20020a50eb8c000000b00410f02e577esm7525742edr.7.2022.03.08.03.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 03:05:28 -0800 (PST)
Date:   Tue, 8 Mar 2022 06:05:24 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220308060210-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yicalf1I6oBytbse@kroah.com>
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

On Tue, Mar 08, 2022 at 09:57:57AM +0100, Greg KH wrote:
> > > And what happens if the mutex is locked _RIGHT_ after you checked it?
> > > You still have a race...
> > 
> > No, we miss a warning that one time.  Memory is still protected.
> 
> Then don't warn on something that doesn't matter.  This line can be
> dropped as there's nothing anyone can do about it, right?

I mean, the reason I wanted the warning is because there's a kernel
bug, and it will break userspace. warning is just telling us this.
is the bug reacheable from userspace? if we knew that we won't
need the lock ...

-- 
MST

