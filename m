Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE3C5F4525
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 16:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJDOHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 10:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJDOHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 10:07:53 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EA15F9A4;
        Tue,  4 Oct 2022 07:07:51 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id e20so8031612qts.1;
        Tue, 04 Oct 2022 07:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CwtCVo4E0uHMxh/oXIFSsuUlrvJUZN6evy9/L7XgMRM=;
        b=ttKKC7oHwP8uhQwfkxVW6CYBu0fscWmPa4jbF4aHqFzvAh/tonDvyuV6wQaDGq8GNB
         ekrd+8S0dHqiQiFjk/QvD6uR52L+VO52U4DUhNuwqecsNV4kEK7NnNdwrKiTzsOmKGAC
         5ql91aYaIZJLKkAf+9X3pj8twN2KzVTqmIGz95qBX0S7sM9y1zAgc66kyRyOpXGVG0/3
         LyRTnHNQbBw1OeLfgHP8cYSIgYczS49E0ZK6Z6lWF9aUTMB/ok6dfLIayeKZ1LR3mdlt
         XLN9XVCCH17NuN25tcoOSG/6QU6EImCpMNdRfUANbTfvQAMy3uozfixoH/WGaTtdayOr
         WFCg==
X-Gm-Message-State: ACrzQf2iEHo/SL8lYIbEwsq3/BHqr/bVDiFNvWZjvxu0qSUIomWBNZuP
        VnbtcXTABgp2OGSG2lLiBrKskInogqAu1beoYjg=
X-Google-Smtp-Source: AMsMyM7XjpNPG7D4U+SwcBGLfHr5S0WNoNxy/EiVr4rwQ/ujw60PsGjVRTB6XGOAzzIOsRR02GBL/zCEsTGnnD05Jao=
X-Received: by 2002:a05:622a:1a08:b0:35c:d9b5:144b with SMTP id
 f8-20020a05622a1a0800b0035cd9b5144bmr19566667qtb.27.1664892469614; Tue, 04
 Oct 2022 07:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com> <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com> <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com> <SJ1PR11MB60830CBCB42CFF552A2B6CF0FC559@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f09e6aee-5d7f-62c2-8a6e-d721d8b22699@linux.alibaba.com> <SJ1PR11MB60837ABF899B5CF1F01D68D1FC579@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <0f23cee8-9139-742c-a9d1-01674b16d05c@linux.alibaba.com> <SJ1PR11MB6083F02E240B6E8B8CEE1EAFFC569@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6083F02E240B6E8B8CEE1EAFFC569@SJ1PR11MB6083.namprd11.prod.outlook.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 4 Oct 2022 16:07:38 +0200
Message-ID: <CAJZ5v0gU9=-9cD0endsyGZUJ7WnOUqWBYoLCHayqhEDkfEHNvQ@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
To:     "Luck, Tony" <tony.luck@intel.com>,
        Shuai Xue <xueshuai@linux.alibaba.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        James Morse <james.morse@arm.com>,
        "baicar@os.amperecomputing.com" <baicar@os.amperecomputing.com>,
        Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 5:52 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> > Yes, the error is actually handled in workqueue. I think the point is that the
> > synchronous exception signaled by synchronous external abort must be handled
> > synchronously, otherwise, it will be signaled again.
>
> Ok. Got it now. Thanks.
>
> For Rafael:
>
> Reviewed-by: Tony Luck <tony.luck@intel.com>

Applied as 6.1-rc material, thanks!
