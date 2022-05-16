Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51822528C38
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344348AbiEPRmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiEPRmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:42:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C1737038
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:42:43 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so520pju.1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lm/q1Gqm1HsV9H33yf52RdsHQedEeeYZq3uFVzTvb3c=;
        b=PqptGi3rkOn4qRvNvz2Epa83/qpOSjYuiDkHBVrzJE/v7wizQGDWZ/Jz0YULI1CGEY
         KzaSFBzsFgiR/lK9obqCcZ+zQrO76nSYTAeKdayGv2RHdsRU8xUTaxxfPH4Xcn6oGZTA
         K4Q3PvV8YmDuKjuHj9B463LkBYRXoXqh4zgqP1P3NtPwBAe87YoAbkchTLo/zVcWqV1S
         2VVWjZqSlWW4noXVM6GW8iWF8BYerJUAPhMnKwiK3EcOXjGkDG6FyafzrLDQ6dWCUypg
         X4WxrQPR5dxGONUEnUaNSrvcF/MucQeJzxzeuxixKvU2ZzQ+gPUEwtFH8fwgqHHmMY4F
         7HAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lm/q1Gqm1HsV9H33yf52RdsHQedEeeYZq3uFVzTvb3c=;
        b=Poi66oP2Qja4JyJ0pZTkrgmbLVwYG7V5VsudhH1duRCR5tqSjCX95KSMrw5E69Jxud
         ffud29Yjy0Rl0Vw1PBjkkBnd1QTi3a1QVmmbOHJRZExCGWOEPGol67qc+3iprOLrYwOM
         tVY15en3WkpjwxZcIl0AYptbcSTLBk7lAB+2tYwn3wZueveqBko9ZWOiUFpr+FqcKxsx
         QBbCbvSEjO0NBG16WVb0vON65hWfRS8v4hNPze9+jmCCWIp+uJIj4uj5DC5OyCa0hk5z
         i6RhImp6H1Qn9cnlXhw8WXp+h1iwmAnCh8R+A8N0BInLvyLozjGpi4IwLpheKeZBRSpt
         z55g==
X-Gm-Message-State: AOAM5306wc2kNxxYpRtU8nWbhfjy7jNimqVS/0JGpwnOVsm+0jgejGD5
        PwMJ8KnmMOimUwlBgHIYy33Hgg==
X-Google-Smtp-Source: ABdhPJzqeggs3aXlZCt4SG3SjF6+VTnMWbCINpwcjkxLtbDibvbRCp+kmP+PANbGW91HQu006bNM2w==
X-Received: by 2002:a17:902:eb87:b0:15e:be95:a3f3 with SMTP id q7-20020a170902eb8700b0015ebe95a3f3mr18357590plg.38.1652722962868;
        Mon, 16 May 2022 10:42:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a17090a5d0a00b001df2538c61dsm4102030pji.23.2022.05.16.10.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 10:42:42 -0700 (PDT)
Date:   Mon, 16 May 2022 17:42:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        "Allen, John" <John.Allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Message-ID: <YoKNDoiXKGbBhuIk@google.com>
References: <20220516154512.259759-1-john.allen@amd.com>
 <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
 <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6q7kTGS5QgZRq9xc0HaEYyntmj3GRWehr-3Sb4y2eQ=HQ@mail.gmail.com>
 <SN6PR12MB2767B4A3919E38C7F429CC2D8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB2767B4A3919E38C7F429CC2D8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022, Kalra, Ashish wrote:
> > >Would it be safer to memset @data here to all zeros too?
> >
> > It will be, but this command/function is safe as firmware will fill in the
> > whole buffer here with the PLATFORM STATUS data retuned to the user.
> 
> > That does seem safe for now but I thought we decided it would be prudent to
> > not trust the PSPs implementation here and clear all the buffers that
> > eventually get sent to userspace?
> 
> Yes, but the issue is when the user programs a buffer size larger the one
> filled in by the firmware. In this case firmware is always going to fill up
> the whole buffer with PLATFORM_STATUS data, so it will be always be safe. The
> issue is mainly with the kernel side doing a copy_to_user() based on user
> programmed length instead of the firmware returned buffer length.

Peter's point is that it costs the kernel very little to be paranoid and not make
assumptions about whether or not the PSP will fill an entire struct as expected.

I agree it feels a bit silly since all fields are output, but on the other hand the
PSP spec just says:

  The following data structure is written to memory at STATUS_PADDR

and the data structure has several reserved fields.  I don't love assuming that the
PSP will always write zeros for the reserved fields and not do something like:

	if (rmp_initialized)
		data[3] |= IS_RMP_INIT;
	else
		data[3] &= ~IS_RMP_INIT;

Given that zeroing @data in the kernel is easy and this is not a hot patch, I
prefer the paranoid approach unless the PSP spec is much more explicit in saying
that it writes all bits and bytes on success.
