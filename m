Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2EA2E9717
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhADOV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbhADOV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 09:21:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51C0D20784;
        Mon,  4 Jan 2021 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609770046;
        bh=cx/RKMatwM2OwlH8Re5yHYBI7WUVFqOnWvP2MtRW//k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V3cf50d1aagCZotHVA4dgXCUvfplv6p4sVhPX/lNJZRn7xQbmygnAB6FqEuHWu0H/
         GL3Y0iI1g9+n/xvf3N9UtEe6Nug2Nw46OOalfV/5lmTZh93EJXmttiSnwIPH8tqElR
         yyoSzPeRy4nIKkcaTzHBPm6cly6gcaYpRjgu+HnO9zr5doEnr8vIS1c5nrqbZk0a/Q
         Pm2hWT1qtw6au4gaV2hJBF9Vbyny2YfPdSzYvyzIg0daWWt81st+1DiDyesFoMfudw
         4tckZ7ZiuyZEvEpF7QYRO3x51oeapjPOgk39HcmjMOJ2xtY6sYAL8iNhxe2W3D7GHZ
         8qf10EUgaYHWg==
Date:   Mon, 4 Jan 2021 09:20:44 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [f2fs-dev] [PATCH AUTOSEL 5.10 10/31] f2fs: Handle casefolding
 with Encryption
Message-ID: <20210104142044.GA3665355@sasha-vm>
References: <20201230130314.3636961-1-sashal@kernel.org>
 <20201230130314.3636961-10-sashal@kernel.org>
 <X+zAlEu+0JSvXaMu@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <X+zAlEu+0JSvXaMu@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 10:01:56AM -0800, Eric Biggers wrote:
>On Wed, Dec 30, 2020 at 08:02:52AM -0500, Sasha Levin wrote:
>> From: Daniel Rosenberg <drosen@google.com>
>>
>> [ Upstream commit 7ad08a58bf67594057362e45cbddd3e27e53e557 ]
>>
>> Expand f2fs's casefolding support to include encrypted directories.  To
>> index casefolded+encrypted directories, we use the SipHash of the
>> casefolded name, keyed by a key derived from the directory's fscrypt
>> master key.  This ensures that the dirhash doesn't leak information
>> about the plaintext filenames.
>>
>> Encryption keys are unavailable during roll-forward recovery, so we
>> can't compute the dirhash when recovering a new dentry in an encrypted +
>> casefolded directory.  To avoid having to force a checkpoint when a new
>> file is fsync'ed, store the dirhash on-disk appended to i_name.
>>
>> This patch incorporates work by Eric Biggers <ebiggers@google.com>
>> and Jaegeuk Kim <jaegeuk@kernel.org>.
>>
>> Co-developed-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Daniel Rosenberg <drosen@google.com>
>> Reviewed-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please don't backport this to the LTS kernels.  This is a new feature, not a
>fix, and you missed prerequisite patches...

Sure, I'l drop it. Thanks!

-- 
Thanks,
Sasha
