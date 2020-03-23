Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BB618F9FB
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 17:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgCWQgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 12:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727578AbgCWQgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 12:36:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A43420658;
        Mon, 23 Mar 2020 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584981404;
        bh=ngNM2CIQcrJ6fe2f0x37FK2PPQMXCUCpRWbsttQMPWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tBxmqhryD0cCQd/I0nPoSfX4C65jvFizfQW6GAcWHND9hxeJSNpjvS3kAwhSO9aW2
         IPokouewH25nDpP/iQZHyZU5gP0NI5Fc9wW6Vea0qOZEMKXQaFyiHmmT/PFsv3USJb
         yDpbSvsDeDIg5j08qdezFCqEfkawZ2XK416tG7RM=
Date:   Mon, 23 Mar 2020 12:36:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     gregkh@linuxfoundation.org, masahiroy@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kbuild: Disable -Wpointer-to-enum-cast"
 failed to apply to 4.19-stable tree
Message-ID: <20200323163643.GW4189@sasha-vm>
References: <15849737281461@kroah.com>
 <20200323153427.GA40380@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200323153427.GA40380@ubuntu-m2-xlarge-x86>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 08:34:27AM -0700, Nathan Chancellor wrote:
>On Mon, Mar 23, 2020 at 03:28:48PM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 82f2bc2fcc0160d6f82dd1ac64518ae0a4dd183f Mon Sep 17 00:00:00 2001
>> From: Nathan Chancellor <natechancellor@gmail.com>
>> Date: Wed, 11 Mar 2020 12:41:21 -0700
>> Subject: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
>>
>> Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
>> casting to enums. The kernel does this in certain places, such as device
>> tree matches to set the version of the device being used, which allows
>> the kernel to avoid using a gigantic union.
>>
>> https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
>> https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
>> https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264
>>
>> To avoid a ton of false positive warnings, disable this particular part
>> of the warning, which has been split off into a separate diagnostic so
>> that the entire warning does not need to be turned off for clang. It
>> will be visible under W=1 in case people want to go about fixing these
>> easily and enabling the warning treewide.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://github.com/ClangBuiltLinux/linux/issues/887
>> Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>>
>> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
>> index ecddf83ac142..ca08f2fe7c34 100644
>> --- a/scripts/Makefile.extrawarn
>> +++ b/scripts/Makefile.extrawarn
>> @@ -48,6 +48,7 @@ KBUILD_CFLAGS += -Wno-initializer-overrides
>>  KBUILD_CFLAGS += -Wno-format
>>  KBUILD_CFLAGS += -Wno-sign-compare
>>  KBUILD_CFLAGS += -Wno-format-zero-length
>> +KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
>>  endif
>>
>>  endif
>>
>
>Attached is a backport that should work for 4.4 through 4.19.

Queued up, thanks!

-- 
Thanks,
Sasha
