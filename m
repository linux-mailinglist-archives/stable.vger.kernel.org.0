Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224E7209844
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 03:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388984AbgFYBoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 21:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388930AbgFYBoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 21:44:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5D92077D;
        Thu, 25 Jun 2020 01:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593049444;
        bh=xWGXXbhoYuVLr6v0DfSjRMA4tC4cAG9LKaccLui8rW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ejKRohTYSgCRtY8wLGmMxZ7M/r0o2PyHnAK6Z2dSyjQP0+Fyhi/bRJ7lCSuixtlMu
         /OFIGOZuVjsCXsEMoWhVWI/RfE2fSZtzsKK5ogGueiHvLQUJloX/tqU3P90HC/OpiI
         6rEtwKjiLesu6ZIKJWmYWLlg0LRGmOXLASrsHn1M=
Date:   Wed, 24 Jun 2020 21:44:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     stable@vger.kernel.org, songliubraving@fb.com, neilb@suse.de,
        guoqing.jiang@cloud.ionos.com
Subject: Re: Please backport 33f2c35a54df to kernels containing c84a1372df92
 for raid0 compatibility
Message-ID: <20200625014403.GG1931@sasha-vm>
References: <20200624164931.GA15350@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200624164931.GA15350@windriver.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 12:49:31PM -0400, Paul Gortmaker wrote:
>Hi all,
>
>I'm recommending backporting commit 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c
>("md: add feature flag MD_FEATURE_RAID0_LAYOUT") to any stable kernels with
>commit c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0
>data corruption due to layout confusion.")
>
>Here is why.  As part of the various recommended mitigation pages out
>there, we'll see instructions indicating that using a newer mdadm can
>allow one to avoid using the raid0.layout= boot argument.
>
>However, if one does that on a kernel that does *not* contain 33f2c,
>then such an older kernel will be "locked out" from mounting the volume
>because this test will fail:
>
>	(le32_to_cpu(sb->feature_map) & ~MD_FEATURE_ALL) != 0)
>
>...since the on-disk sb now has MD_FEATURE_RAID0_LAYOUT but the older
>kernel knows nothing about it and you get EINVAL (-22) during mount.
>
>I ran into the above situation on a v5.2 kernel, and backporting the
>33f2c resolved the locked out issue, and then the bootarg was no longer
>required, as documented by the updated mdadm man page.

33f2c35a54df ("md: add feature flag MD_FEATURE_RAID0_LAYOUT") was queued
for the 4.19 and 4.14 branches, thank you!

-- 
Thanks,
Sasha
