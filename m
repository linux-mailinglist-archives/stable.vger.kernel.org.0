Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CB66CF169
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjC2RtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 13:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjC2RtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 13:49:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D901711
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680112101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=UmIysVrI04rvgk7uJd7fYLLoG0ebzzndVqA4pTb91XXfYEV+RwatoNBmnYHZQ//qKWOeKJ
        9eJmp13nC5fD7a2FzdsQyLMpXOrEP0/WIprGEDIgbfBX6A/yqqrlPjwYWu4k4MnO/eOSmV
        mYHu0Gt2aBvBDqHCVf2gkK1QA+rY+0Q=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-yYaCwCvGNsqAroM2sXlnKw-1; Wed, 29 Mar 2023 13:48:20 -0400
X-MC-Unique: yYaCwCvGNsqAroM2sXlnKw-1
Received: by mail-qv1-f69.google.com with SMTP id oo15-20020a056214450f00b005a228adfcefso7026818qvb.2
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=EVtxT7EmuIz9dedY+AE9bbXaCqgfund+AfUX0gjGGmvKS+E8xBtsk3O/98+Ti+pWND
         YeHrEZxqp2hSV6XP8ANE65tGQpDkgWZdXI3GLupe8iVaPs9kEts2TvdA9bCLztV/Bzt9
         dheTeRo7Pav31lVVtvAY6zV96SiCoRbt5T8mo07yJDae66016ULjPlMSRlhb99lh5eBu
         Bcfesz9kZq6pnKXShvsgyFRiH9w8LfcRhmQ3HxjG/R2HAJjCgwdh+gZurYh0H84jdoXe
         SJaIB07qrbEZniYBwTRVut0aBUsfv4rM1zw+hWkTzmfuSNTfZzRz9YxZ43rzRnKK7OOs
         nieQ==
X-Gm-Message-State: AO0yUKVM+qsxfM5DbZSmDAWh0GunKcWepynw84DGLac3WaSMlrND1Vty
        kIZm8vqsaqjzeA4f4GoXdVae9xtACdVOMmUMWT1SGmw4UfydxaXT8xI+OivJgKOoXsJcVF67V6i
        cEfFmYRynWjRJnK+KT/Fs8Fl2
X-Received: by 2002:a05:622a:c4:b0:3b8:6a20:675e with SMTP id p4-20020a05622a00c400b003b86a20675emr26808659qtw.29.1680112099151;
        Wed, 29 Mar 2023 10:48:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set/RuEFaBncS1XZKU6gjxIY1BwiyEPHuyqMb56XvK0jO+KAKN56Wfax/73/7/MdVMdg0ASOZWQ==
X-Received: by 2002:a05:622a:c4:b0:3b8:6a20:675e with SMTP id p4-20020a05622a00c400b003b86a20675emr26808638qtw.29.1680112098922;
        Wed, 29 Mar 2023 10:48:18 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id 66-20020a370b45000000b0071eddd3bebbsm10492274qkl.81.2023.03.29.10.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 10:48:18 -0700 (PDT)
Date:   Wed, 29 Mar 2023 13:48:16 -0400
From:   Adrien Thierry <athierry@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 6.1 117/224] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCR54GpXqZFNET9z@fedora>
References: <20230328142617.205414124@linuxfoundation.org>
 <20230328142622.233084877@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142622.233084877@linuxfoundation.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A possible regression was found with this patch [1]

[1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Best,

Adrien

