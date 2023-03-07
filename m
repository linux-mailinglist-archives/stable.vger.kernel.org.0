Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464E66AEEB9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjCGSPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjCGSOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C63A2F38
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678212581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WEG7LK8/i2z3AIJVT1QZkgOj1XRs+jwFgAHmXlUhdhk=;
        b=gskw0mOfmGo+cw98SabzgyGtCetWvJOrjp0WEW8NG7vng6iILBSRzP5PQDab7JVnOagx07
        SkvuwbG3WjBE7XM1PFR5FfTN3hef6rBjgNdSRn5Mf2ICJYF3rv+JT14EUm72DIbF+knlU7
        GZ8Q82g6XD6upR7FxsTnb5e5KvEAJ34=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-OVLekdcZOfGQyjzLxgF2DA-1; Tue, 07 Mar 2023 13:09:40 -0500
X-MC-Unique: OVLekdcZOfGQyjzLxgF2DA-1
Received: by mail-wm1-f69.google.com with SMTP id l20-20020a05600c1d1400b003e10d3e1c23so8600189wms.1
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 10:09:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678212578;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WEG7LK8/i2z3AIJVT1QZkgOj1XRs+jwFgAHmXlUhdhk=;
        b=yJ0pb1tz2u/S6aCtx1mllw4+s4IsRcpWqt6OsUdJVPwgKWEqHoHne93CyoVs0MGJTP
         WfXsmKvq0uDqlFpYyGIBn9sVHew0UgLniNAxgDNeJ2elkgkvD+mH9/tSwVXUBwyps3E4
         yeMbmVxFDYrRp6glHxysZJvlZRH65snfhCJuun6vujzEaRZQb5odORzw0chBmS1U9fIa
         G/BGptjE9eZjTodA54zIKASmP6Utw9cc99+MXhMDSR8YXpPIWsl2j6aeschpDZl76pnL
         h7nmpmyeiKI4sO+iE+XN9YUj3WtgN3Xq6/LzEY4ESptkDQ5uN1/5P3F794lPlYNULi05
         iLZw==
X-Gm-Message-State: AO0yUKUZzLQsO0GaBSr6nYhSdbxsNXgwGRZfyrYm8lpd5NE6TvhkjO96
        HsIA/pnfx+MdFXLmq6Yu28PCZ5tKZYg25X8PAHCTQ1fX7kiloEfQbvJbuj9KNkhRcGxQhNC+jfQ
        djWdbxvL/zKbXrLXU1DRZVfWhRVUEJFWtU8zkP6+tqjuxaouSjEoEyrMjnqBxzhrBxcueOEoM0c
        Vx
X-Received: by 2002:a5d:4847:0:b0:2c7:832:8ccf with SMTP id n7-20020a5d4847000000b002c708328ccfmr9549309wrs.53.1678212578271;
        Tue, 07 Mar 2023 10:09:38 -0800 (PST)
X-Google-Smtp-Source: AK7set+YnjzX5tQscF+boxtAs/CWcUsgScgsVrMFQQNMK8rK3JbwlB0UpTVMo9rJfn1aW6mzfPUECA==
X-Received: by 2002:a5d:4847:0:b0:2c7:832:8ccf with SMTP id n7-20020a5d4847000000b002c708328ccfmr9549279wrs.53.1678212577908;
        Tue, 07 Mar 2023 10:09:37 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c308900b003dfe5190376sm13425825wmn.35.2023.03.07.10.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:09:37 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wenyang.linux@foxmail.com
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Baoquan He <bhe@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Juri Lelli <jlelli@redhat.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 3/3] panic, kexec: make __crash_kexec() NMI safe
In-Reply-To: <ZAIXghGzIN/JXN9a@kroah.com>
References: <20230301162502.120413-1-wenyang.linux@foxmail.com>
 <tencent_23D2059843FC3C9F09AAC6A8678272270109@qq.com>
 <ZAIXghGzIN/JXN9a@kroah.com>
Date:   Tue, 07 Mar 2023 18:09:34 +0000
Message-ID: <xhsmhjzzso2ld.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/03/23 16:51, Greg Kroah-Hartman wrote:
> On Thu, Mar 02, 2023 at 12:25:02AM +0800, wenyang.linux@foxmail.com wrote:
>> From: Valentin Schneider <vschneid@redhat.com>
>>
>> commit 811d581194f7412eda97acc03d17fc77824b561f upstream.
>
> No it is not :(
>
> Also, why is this needed for 5.10.y?  PREEMPT_RT is not in 5.10, right?
>

The mutex_unlock() might end up waking a waiter, and wake_up_process()
really isn't NMI safe (regardless of PREEMPT_RT - the PREEMPT_RT warning
just highlighted the issue).

> thanks,
>
> greg k-h

