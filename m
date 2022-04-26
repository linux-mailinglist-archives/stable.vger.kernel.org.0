Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAA951003B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbiDZOVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237465AbiDZOVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10E241BE89
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650982683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bfm5h1PBNVBIKlOUTEv2QDkar3XSs2YfbRFWDvobYk=;
        b=HZLp0MoNPKjAWTIdOUy1ItFiyc7G8Aky0+YDRxMEBHJgf+UWWxFK69OR2DpT5dMvhgXsx3
        YUByEf0DbDYlHDGnELYpDMQybdqw93oXMmJktzTrPScTxSeNUiulvQZHKREXrvc2cBmbIw
        jrVIkJcNVW/0c175GZOmRQ+icwmP5w8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-xBXP6_WwOZ2VNKf5_EmBGg-1; Tue, 26 Apr 2022 10:18:01 -0400
X-MC-Unique: xBXP6_WwOZ2VNKf5_EmBGg-1
Received: by mail-wr1-f69.google.com with SMTP id v29-20020adfa1dd000000b0020ad932b7c0so1967770wrv.0
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0bfm5h1PBNVBIKlOUTEv2QDkar3XSs2YfbRFWDvobYk=;
        b=fU5Smbs6LiahbEj07s2YkwSWH7tjiBiYRSMhtvmyIkjsvSz+e///tPw1zp9G/92HKB
         0w4V0F7o9Dss/WRULtIEWp1XmFZm4UXv6tVMnlFCx/4kOwkao9NQt+QgDeBiZQih3ucN
         r3EfBWUilzaNZ+qKd5lOT3nBXHX2tAzQUyYJtnga+kJC8XULrGWemFenOFJnvkpGWysN
         9BUIf3GHRtlDWm8sytc43ILxc32J2acaRxpyYUajlUyGFSdWteZrwaHtvUsHZ1hGzdx8
         TG1AWKvAuwEG1bYjZX1M2cGTkPBDZ7D/tLmn4GTHKwGgdwp7mPHeMGHBhJs0jDVzn0Jw
         oaNA==
X-Gm-Message-State: AOAM531lfBCqIFn4vfThC2LzT2q9kjpwRmOxmk8MmefNADVYMGiPUfSL
        aWDLHq/b3PopRU8QGjHDUqbzsYNNVFrkQIXKK2y/FPSrJ4BNsvcBT6lspDaJo6HN7+oCgCSNj9Y
        fHV9OhPDGo8YwYV04
X-Received: by 2002:a05:6000:1f09:b0:20a:c427:c7c with SMTP id bv9-20020a0560001f0900b0020ac4270c7cmr18187858wrb.337.1650982680093;
        Tue, 26 Apr 2022 07:18:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtAUrMnWTRbmK7Qx0YAas5R6NoJQ1P/w8NxcBFdYW8Wq3VDiSAkUB68cbM1Pwbudll5xPJcg==
X-Received: by 2002:a05:6000:1f09:b0:20a:c427:c7c with SMTP id bv9-20020a0560001f0900b0020ac4270c7cmr18187840wrb.337.1650982679865;
        Tue, 26 Apr 2022 07:17:59 -0700 (PDT)
Received: from redhat.com ([2.53.22.137])
        by smtp.gmail.com with ESMTPSA id l3-20020a05600002a300b0020aad7fd63bsm13613932wry.61.2022.04.26.07.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:17:59 -0700 (PDT)
Date:   Tue, 26 Apr 2022 10:17:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Message-ID: <20220426101640-mutt-send-email-mst@kernel.org>
References: <20220426073656.229-1-xieyongji@bytedance.com>
 <YmeoSuMfsdVxuGlf@kroah.com>
 <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com>
 <YmfIv2YuARnPe97k@kroah.com>
 <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
 <YmfpKGZB06Ix5WPu@kroah.com>
 <CACycT3vD9o+_uLaevCZ=W==YRA_WJP8UJ6czHTtsUny8Rwgd0A@mail.gmail.com>
 <Ymf03l+Ag8ZBSGm2@kroah.com>
 <CACycT3vmN0z=in1hcT7XuW4p-vzq9SAgPJNGGkooc+C+qftWjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3vmN0z=in1hcT7XuW4p-vzq9SAgPJNGGkooc+C+qftWjw@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:02:02PM +0800, Yongji Xie wrote:
> > This should not be needed, when your module is unloaded, all devices it
> > handled should be properly removed by it.
> >
> 
> I see. But it's not easy to achieve that currently. Maybe we need
> something like DEVICE_NEEDS_RESET support in virtio core.

Not sure what the connection is.

-- 
MST

