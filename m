Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F0E4BB077
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 05:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiBREAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 23:00:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiBREA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 23:00:29 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C41E13D22
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 20:00:14 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 132so6773796pga.5
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 20:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ihLiOYcLhTMPKpJLMj5Tcvek92eXFj8sFzSo0F05Ymk=;
        b=pIPoApkrX30YDDBNdGp6eV2JElpXwud6oNJVeUlD9IznP9aVydbOdq3Sy0g44hueuM
         qUoj39ctB90j7EhecKSVUicUETtlDD73hcbAunuP6Q3FiBYE3njACWQFnK7c5nNhFiEF
         lUUoYxGK8bsGf8CBQpJIQbYD9M3XY2vA6qmBvlyWX0exlrKOHrPhL1RawXIB//MahZY4
         OHF7j5WUkkHgvfzRACkBcTLCVGlHCPNNJCRXET4lUK2g8rDTRdq1WphzK/DyfakWMz1b
         RuiMNnkLjC2yCptt1mhTH6iiCcbcQ49BxIPuS/DzzxT0EJNXRExJQCC6dqVsE2YH/7KK
         2Vww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ihLiOYcLhTMPKpJLMj5Tcvek92eXFj8sFzSo0F05Ymk=;
        b=GY7AOYpurSlxddaO6SnWMJHWKjyJXv7aCbKBglkVHPnsoDeu/pYMoOkhPyyS75TmRO
         yVdKywVMs51jeVne59DwymvN2FUCYo/YX8Le9cwtsjvAS6ODYfZ9wWJ8bMefuiXPtkxK
         cf/5TjSi2KEoremTch6yfkbBoN47tTtJDRog66meZZB2KrFLCnCeNTgzwIyg6q+NbmW0
         E6fEywOwaZC69NJDosmBiUXq1iVD7f/4fKSnCDlr8DFxv8lMiH/2TUEecaDR1xo4PdEF
         JtUE29RdLGZitTs7b1u8mQWhz9bRqpWaym/U3D012qCk0O8QW0R5JwNT2qcq8Z+Ybu6j
         qd2Q==
X-Gm-Message-State: AOAM532AGVVD5FI/nUfQVPUyOrbzxNUHh6Z352FudQ17A6lBcafu34IU
        tmM/T3d66pAyrScPCotWMs4=
X-Google-Smtp-Source: ABdhPJxYyypJbNOuwt4vgDz1vftdsFnrY5uV4Gx1bPJS93SxoDwfJYv2PSpBNGU+FrRdcMOeeJgVzw==
X-Received: by 2002:a05:6a00:189d:b0:4e1:dc82:eded with SMTP id x29-20020a056a00189d00b004e1dc82ededmr4041440pfh.27.1645156813835;
        Thu, 17 Feb 2022 20:00:13 -0800 (PST)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id z27sm9228192pgk.78.2022.02.17.20.00.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Feb 2022 20:00:13 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
Date:   Thu, 17 Feb 2022 20:00:12 -0800
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
References: <20220217211602.2769-1-namit@vmware.com>
 <Yg79WMuYLS1sxASL@xz-m1.local>
 <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Feb 17, 2022, at 6:23 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> PS: I always think here the VM_SOFTDIRTY check is wrong, IMHO it =
should be:
>>=20
>>       if (dirty_accountable && pte_dirty(ptent) &&
>>                       (pte_soft_dirty(ptent) ||
>>                       (vma->vm_flags & VM_SOFTDIRTY))) {
>>               ptent =3D pte_mkwrite(ptent);
>>       }

I know it is off-topic (not directly related to my patch), but
I tried to understand the logic - both of the existing code and of
your suggested change - and I failed.

IIUC dirty_accountable (whose value is taken from
vma_wants_writenotify()) means that the writes *should* be tracked,
and therefore the page should remain read-only.

So basically the condition should have been based on
!dirty_accountable, i.e. the inverted value of dirty_accountable.

The problem is that dirty_accountable also reflects VM_SOFTDIRTY
considerations, so looking on the PTE does not tell you whether
the PTE should remain write-protected even if it is dirty.

Am I missing something?

