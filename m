Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B5DBE2AD
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 18:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391896AbfIYQlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 12:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfIYQlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 12:41:52 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77552C01D36C
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 16:41:51 +0000 (UTC)
Received: by mail-io1-f70.google.com with SMTP id r5so540604iop.2
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 09:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=zugf//ewV+Jw24YzObP86wfqOVJcB6V6OI1o/yrHlEY=;
        b=YKw0U4bmWeYxR31vNj5+a9z/rId7HpN9cLJXyZj6e8xSME9XbD5BjNvaA+S0W1WgSi
         CtlQzdjUhDBX6EQaQL/uNzkNYRCUMbdE535BWH0pKIh1Q6zrL7an4+VKxEsdRjgh1art
         I9pFyttfK1dX6V9cvEyplmNQsGTsYcbwtW5J/KMyB2bYr81E/yvsbtcRcgAjLtHJRzF0
         Fw/MA8Z4s8wrU7bTq1HWLrq/wgK8d73m6FG1oN/rYn3ozLmS1g/dqmxaL7EuG0fEWVkM
         PCYDjMKIaH3qQJTZz9KO36w6uAoBkM3eLT0LVxufbj6yxi4aOvMVF3S7Xhja2iLhrl6c
         brOw==
X-Gm-Message-State: APjAAAU6vuSiwi8DvCEaKT2l8Oco9jR3/zT3uI6uIV5WRhvX4NUzLfff
        I2wEcoQneQb8kEuBSFTWNGp2W9Mc9/5zwm76EZrFZ63IMFYHRKz8UBU4xzlOHwLDWVT47pmy0NK
        bH1w7EUTpDwIr0Wkj
X-Received: by 2002:a92:4648:: with SMTP id t69mr1134273ila.282.1569429710841;
        Wed, 25 Sep 2019 09:41:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz3k+VJoIZBpJcMr4uiRsUW3+00NWKVfMoehoDepoQvH5UxKHKV1XUTS9DES9bMTghkTTPc5Q==
X-Received: by 2002:a92:4648:: with SMTP id t69mr1134255ila.282.1569429710588;
        Wed, 25 Sep 2019 09:41:50 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id c6sm52396iom.34.2019.09.25.09.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:41:49 -0700 (PDT)
Date:   Wed, 25 Sep 2019 09:41:33 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] efi+tpm: Don't access event->count when it isn't
 mapped.
Message-ID: <20190925164133.nmzzhwgagpqvwclu@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
 <CAKv+Gu9xLXWj8e70rs6Oy3aT_+qvemMJqtOETQG+7z==Nf_RcQ@mail.gmail.com>
 <20190925145011.GC23867@linux.intel.com>
 <20190925151616.3glkehdrmuwtosn3@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190925151616.3glkehdrmuwtosn3@cantor>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed Sep 25 19, Jerry Snitselaar wrote:
>On Wed Sep 25 19, Jarkko Sakkinen wrote:
>>On Wed, Sep 25, 2019 at 12:25:05PM +0200, Ard Biesheuvel wrote:
>>>On Wed, 25 Sep 2019 at 12:16, Jarkko Sakkinen
>>><jarkko.sakkinen@linux.intel.com> wrote:
>>>>
>>>> From: Peter Jones <pjones@redhat.com>
>>>>
>>>> Some machines generate a lot of event log entries.  When we're
>>>> iterating over them, the code removes the old mapping and adds a
>>>> new one, so once we cross the page boundary we're unmapping the page
>>>> with the count on it.  Hilarity ensues.
>>>>
>>>> This patch keeps the info from the header in local variables so we don't
>>>> need to access that page again or keep track of if it's mapped.
>>>>
>>>> Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
>>>> Cc: linux-efi@vger.kernel.org
>>>> Cc: linux-integrity@vger.kernel.org
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Peter Jones <pjones@redhat.com>
>>>> Tested-by: Lyude Paul <lyude@redhat.com>
>>>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>> Acked-by: Matthew Garrett <mjg59@google.com>
>>>> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>
>>>Thanks Jarkko.
>>>
>>>Shall I take these through the EFI tree?
>>
>>Would be great, if you could because I already sent one PR with fixes for
>>v5.4-rc1 yesterday.
>>
>>/Jarkko
>
>My patch collides with this, so I will submit a v3 that applies on top of
>these once I've run a test with all 3 applied on this t480s.

Tested with Peter's patches, and that was the root cause on this 480s.

I think there should still be a check for tbl_size to make sure we
aren't sticking -1 into efi_tpm_final_log_size though, which will be
the case right now if it fails to parse an event.
