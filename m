Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48627188223
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgCQLYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgCQLYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:24:43 -0400
Received: from linux-8ccs (p5B2812F9.dip0.t-ipconnect.de [91.40.18.249])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CA72051A;
        Tue, 17 Mar 2020 11:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584444283;
        bh=GaGdl8pgY44OKNN30+xVpu/sgpjCpuysfuKAf9fBIcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rzUIlzSBBTaX4YeDLXeOTa6YgyRsPvHnbJZEalAynpP5TXlqAl1HnGORO6bY4p3NX
         cq6cTOHPm6xTkN+JyxDKkzORj+v4mg8Fvedr45/hHt/jB/2VjWA5r4o8P8nP/qvqX1
         C3xWWl7fozzau6Yg4s/f/b/lhvGeiUqBF54DWjI0=
Date:   Tue, 17 Mar 2020 12:24:39 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] modpost: move the namespace field in Module.symvers
 last
Message-ID: <20200317112439.GB6841@linux-8ccs>
References: <20200311170120.12641-1-jeyu@kernel.org>
 <CAK7LNAT-xdMZbK5UeVvm6S-WNimMMKO3b=jkJsU29z6ULPjs_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK7LNAT-xdMZbK5UeVvm6S-WNimMMKO3b=jkJsU29z6ULPjs_Q@mail.gmail.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ Masahiro Yamada [14/03/20 11:11 +0900]:
>On Thu, Mar 12, 2020 at 2:02 AM Jessica Yu <jeyu@kernel.org> wrote:
>>
>> In order to preserve backwards compatability with kmod tools, we have to
>> move the namespace field in Module.symvers last, as the depmod -e -E
>> option looks at the first three fields in Module.symvers to check symbol
>> versions (and it's expected they stay in the original order of crc,
>> symbol, module).
>>
>> In addition, update an ancient comment above read_dump() in modpost that
>> suggested that the export type field in Module.symvers was optional. I
>> suspect that there were historical reasons behind that comment that are
>> no longer accurate. We have been unconditionally printing the export
>> type since 2.6.18 (commit bd5cbcedf44), which is over a decade ago now.
>>
>> Fix up read_dump() to treat each field as non-optional. I suspect the
>> original read_dump() code treated the export field as optional in order
>> to support pre <= 2.6.18 Module.symvers (which did not have the export
>> type field). Note that although symbol namespaces are optional, the
>> field will not be omitted from Module.symvers if a symbol does not have
>> a namespace. In this case, the field will simply be empty and the next
>> delimiter or end of line will follow.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: cb9b55d21fe0 ("modpost: add support for symbol namespaces")
>> Tested-by: Matthias Maennich <maennich@google.com>
>> Reviewed-by: Matthias Maennich <maennich@google.com>
>> Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
>> Signed-off-by: Jessica Yu <jeyu@kernel.org>
>
>
>While I am not opposed to this fix,
>I did not even notice Module.symvers was official interface.
>
>Kbuild invokes scripts/depmod.sh to finalize
>the 'make modules_install', but I do not see the -E
>option being used there.
>
>I do not see Module.symvers installed in
>/lib/modules/$(uname -r)/.

While that's true, distros typically package Module.symvers in their
linux-headers/kernel-devel (or equivalent) packages to support
external module builds. The -E option is usually used to do symbol
versioning/kabi checks with the Module.symvers file. Considering the
options, I think it will cause the least headaches down the line to
make this fix upstream and maintain backwards compatibility with kmod
rather than to patch kmod and remind distros to repackage because old
depmod versions don't work with the new Module.symvers anymore..

Thank you!

Jessica
