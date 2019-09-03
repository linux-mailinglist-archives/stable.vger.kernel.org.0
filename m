Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78451A73D4
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfICTnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfICTnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 15:43:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 701C02087E;
        Tue,  3 Sep 2019 19:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567539816;
        bh=siTmQhPkETqtbp5xDiGVSXlWmbm3jkAo5QqPaZswdwk=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ftd/sdeH/M6lJzdqOq62eLGH9vEdeGeIY6gCxaTCsad8bcSKQ3l6DcvwdyyGereNS
         iveyAkOm/u8ZHgtLYM3G6eewK6WQ6XJnNU9T2SYEJ2cgRrUlagtGYQK3K/aj2PcpFm
         bgmmvk0tLXnQpZCOGb7YsMYOyuvl33mfNlTR0MtE=
Date:   Tue, 3 Sep 2019 15:43:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Doug Anderson <dianders@chromium.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        linux-integrity@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH AUTOSEL 4.19 126/167] tpm: Fix TPM 1.2 Shutdown sequence
 to prevent future TPM operations
Message-ID: <20190903194335.GG5281@sasha-vm>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-126-sashal@kernel.org>
 <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
 <20190903165346.hwqlrin77cmzjiti@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190903165346.hwqlrin77cmzjiti@cantor>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 09:53:46AM -0700, Jerry Snitselaar wrote:
>On Tue Sep 03 19, Doug Anderson wrote:
>>Hi,
>>
>>On Tue, Sep 3, 2019 at 9:28 AM Sasha Levin <sashal@kernel.org> wrote:
>>>
>>>From: Vadim Sukhomlinov <sukhomlinov@google.com>
>>>
>>>[ Upstream commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 ]
>>>
>>>TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
>>>future TPM operations. TPM 1.2 behavior was different, future TPM
>>>operations weren't disabled, causing rare issues. This patch ensures
>>>that future TPM operations are disabled.
>>>
>>>Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
>>>Cc: stable@vger.kernel.org
>>>Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
>>>[dianders: resolved merge conflicts with mainline]
>>>Signed-off-by: Douglas Anderson <dianders@chromium.org>
>>>Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>---
>>> drivers/char/tpm/tpm-chip.c | 5 +++--
>>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>
>>Jarkko: did you deal with the issues that came up in response to my
>>post?  Are you happy with this going into 4.19 stable at this point?
>>I notice this has your Signed-off-by so maybe?
>>
>
>I think that is just the signed-off-by chain coming from the upstream patch.
>Jarkko mentioned getting to the backports after Linux Plumbers, which is next week.

Right. I gave a go at backporting a few patches and this happens to be
one of them. It will be a while before it goes in a stable tree
(probably way after after LPC).

--
Thanks,
Sasha
