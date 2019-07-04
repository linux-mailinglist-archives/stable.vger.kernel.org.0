Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2D95F8B1
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 15:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGDNAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 09:00:06 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37448 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfGDNAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 09:00:06 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so5366035eds.4;
        Thu, 04 Jul 2019 06:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W3YX4qyiQ8io0QlAlJhhQ1BpPb12I9CxfxqXtbQ0TLk=;
        b=E3JZ9ogcwZlSvahnLgdA879/a0BsQcwPHH8vTp1K3ZWV/6I7UECgSepeJxMFSdGRtg
         gKLM/46akrIUDBGrhZvZyVB9uCmyyK53zrTd2seYk7/zWRwSesJl3dD2cor46695IDfd
         sk6F0r8vJ2WiV53oqyU0ecCX6mh8yaCMltvd+oMts+ccs/hHClYdLKBWKBhBRZ6dv+Y1
         sK23uPIZUQ0jPFIyUIicscj90bg8F70bxeuaugKdC1vC/WrOM79YujMTmmBlp5bqVVQS
         0dnbKogj+GCwz60Ok3miQDyMjnm9n49s58WLI7UrJ71L25mrumXbsypWphmqfP6vGxDq
         arJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W3YX4qyiQ8io0QlAlJhhQ1BpPb12I9CxfxqXtbQ0TLk=;
        b=IHecRWqpT5hR+6xIMwQVYt2qE/BfmkN4gAL0YWXAqW9UQpGAi4qhj5MpPAXSgamYxd
         71N+9384YrfZEktzsXW+lKsc9VnupGZ6EJqoCNWvCLU3JXj9DZwEj1ZYdn30b9gwZzQv
         HlLV7pdnZBSVZ+g/tD+8P+QZBKtGx5pMTSgO397UGz8kuJwcDMruF3V7OVMJ3TewFqjQ
         dMAPfleZQjp6oP1CLf/S1FyDBycusIVjIeoGGRLH3OYU5/dxRTf1OjuZQqaNur09xNyc
         doQ9jwS9krpRgizhIE6+6cZgMdM4OZLNeHyoAhHh8vS5i5pZOE120xzZlZN3PAK7GGqX
         mIKQ==
X-Gm-Message-State: APjAAAV02hFbq12S5906KxadORsp/v58TLNOzjwOgdTQW7pNC8DrJRy8
        HX/Mf2DSJcX0d6U9Y2j8s3nK4Jl4
X-Google-Smtp-Source: APXvYqx/xDpW63P0DtWVWg5EHGUMTzL2ZtFT2OlGJ9vaEeS2E3Ny8vNG//RYrRCWQ9JPOE/XXajuDQ==
X-Received: by 2002:a17:906:d7ab:: with SMTP id pk11mr39519655ejb.216.1562245204270;
        Thu, 04 Jul 2019 06:00:04 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.211.18])
        by smtp.gmail.com with ESMTPSA id z12sm1595238edq.57.2019.07.04.06.00.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 06:00:03 -0700 (PDT)
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
To:     Matthew Wilcox <willy@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
From:   Boaz Harrosh <openosd@gmail.com>
Message-ID: <f23a1c71-d1b1-b279-c922-ce0f48cb4448@gmail.com>
Date:   Thu, 4 Jul 2019 16:00:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190704032728.GK1729@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/07/2019 06:27, Matthew Wilcox wrote:
> On Wed, Jul 03, 2019 at 02:28:41PM -0700, Dan Williams wrote:
<>
>>> +#ifdef CONFIG_XARRAY_MULTI
>>> +       unsigned int sibs = xas->xa_sibs;
>>> +
>>> +       while (sibs) {
>>> +               order++;
>>> +               sibs /= 2;
>>> +       }
>>
>> Use ilog2() here?
> 
> Thought about it.  sibs is never going to be more than 31, so I don't
> know that it's worth eliminating 5 add/shift pairs in favour of whatever
> the ilog2 instruction is on a given CPU.  In practice, on x86, sibs is
> going to be either 0 (PTEs) or 7 (PMDs).  We could also avoid even having
> this function by passing PMD_ORDER or PTE_ORDER into get_unlocked_entry().
> 
> It's probably never going to be noticable in this scenario because it's
> the very last thing checked before we put ourselves on a waitqueue and
> go to sleep.
> 

Matthew you must be kidding an ilog2 in binary is zero clocks
(Return the highest bit or something like that)

In any way. It took me 5 minutes to understand what you are doing
here. And I only fully got it when Dan gave his comment. So please for
the sake of stupid guys like me could you please make it ilog2() so
to make it easier to understand?
(And please don't do the compiler's job. If in some arch the loop
 is the fastest let the compiler decide?)

Thanks
Boaz
