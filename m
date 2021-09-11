Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1794D4078D6
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 16:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhIKOiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 10:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhIKOiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 10:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B931360FDC;
        Sat, 11 Sep 2021 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631371021;
        bh=NJTwYsU03StmH7ohgYXkew3rLLbSnP8LffhzbLdHNCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WHplxU7EKjzhUXrF+mEV5n/Csi4cmY+OUsbBp9KH5VdRRkIzRfVabLU1NjzrK4sM3
         I4Es3BQyI5SrMx+hUJTq+zI9TwAZkvYA/1eHQLDdbkU1oxOSgaBVKE2ZhPHrnElTwH
         /XFejfIVHaO2zH4v5D9hI0HHvyx7crz7iLMs4xZqP9sLI8oPxhwOuCiF9XB/V1vVLt
         WTzLRDQZEGW1oM/7Z2JRUY3dXWZHFTKdsliI7Ua6zbZF3sa10eBnNRNfbTDI1Ee4jS
         QtgpTNSEN2AzSVdsN30GQ4SN70dYGv/JuBCsZb87O/OahHGDP4oOdcy1Qe9Djeqz9Y
         hWQ1FRD20nYUw==
Date:   Sat, 11 Sep 2021 10:36:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.14 46/99] ovl: copy up sync/noatime fileattr
 flags
Message-ID: <YTy/C7/nqGEs5svi@sashalap>
References: <20210910001558.173296-1-sashal@kernel.org>
 <20210910001558.173296-46-sashal@kernel.org>
 <CAOQ4uxi8Ae8Pk1bUDNmQgCvEn_SoXXeW4HsNV5k2+ceejevrLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi8Ae8Pk1bUDNmQgCvEn_SoXXeW4HsNV5k2+ceejevrLQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 08:35:41AM +0300, Amir Goldstein wrote:
>On Fri, Sep 10, 2021 at 3:17 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Amir Goldstein <amir73il@gmail.com>
>>
>> [ Upstream commit 72db82115d2bdfbfba8b15a92d91872cfe1b40c6 ]
>>
>> When a lower file has sync/noatime fileattr flags, the behavior of
>> overlayfs post copy up is inconsistent.
>>
>> Immediately after copy up, ovl inode still has the S_SYNC/S_NOATIME
>> inode flags copied from lower inode, so vfs code still treats the ovl
>> inode as sync/noatime.  After ovl inode evict or mount cycle,
>> the ovl inode does not have these inode flags anymore.
>>
>> To fix this inconsistency, try to copy the fileattr flags on copy up
>> if the upper fs supports the fileattr_set() method.
>>
>> This gives consistent behavior post copy up regardless of inode eviction
>> from cache.
>>
>> We cannot copy up the immutable/append-only inode flags in a similar
>> manner, because immutable/append-only inodes cannot be linked and because
>> overlayfs will not be able to set overlay.* xattr on the upper inodes.
>>
>> Those flags will be addressed by a followup patch.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>Sasha,
>
>I do not recommend applying this patch to stable.
>The value/risk ratio is not worth it IMO.
>
>I don't know of anyone who ever complained about not copying
>the NOATIME/SYNC fileattrs specifically.
>
>This patch is more of a complimentary patch to the IMMUTABLE/
>APPEND fileattr patch, which is not appropriate for stable either.

Thanks! I'll drop it.

>OTOH, ovl-update-5.15 has this patch that was not included in the
>AUTOSEL batch, even though it has a Fixes tag, CC stable and
>very strong hints in the subject:
>52d5a0c6bd8a ("ovl: fix BUG_ON() in may_delete() when called from
>ovl_cleanup()")
>
>I suppose AUTOSEL leaves these sorts of patches to Greg's scripts?

That's correct. If it has a stable tag AUTOSEL won't look at it (why
should it? :) ).

-- 
Thanks,
Sasha
