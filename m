Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FDB2E7BBD
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 19:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgL3SCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 13:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726337AbgL3SCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 13:02:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE9C22287;
        Wed, 30 Dec 2020 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609351317;
        bh=1EEHMEPXKBgaCrorRSDRdGyZ2w5tbvnf1YgxY5j8NVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tU8Q28xTgSvY0NTPdbWeODcyYzhRYoozlDWcxAqqbcfrDDo+bkO2k5j8Yop0iJNHD
         CBOZd1nQ++IXpbg5/9ToK/BF85rVtqXkDdtJr6yIVrlEXu2ionquerG8HWPrG+VskS
         UJfJIOPERNA2d3MvGbAiQiPDYMYiKrbOP4ec/GIl6Ct4yxy9pvYLiDyocMDRV6NL22
         mwoqQ1HLmnk/5lmxvqIQrDVv0P7b8pU1XqiBMEfPMMDGe6cuCfB6D7bbjmiNWqx862
         ssbWWVyU9ClV29V3lco8LoVnH2AeO6T2aYPsuNUdlx/dXnGJZcLuXPrOFPzY1Runzr
         rYOkr93Wo7wcg==
Date:   Wed, 30 Dec 2020 10:01:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [f2fs-dev] [PATCH AUTOSEL 5.10 10/31] f2fs: Handle casefolding
 with Encryption
Message-ID: <X+zAlEu+0JSvXaMu@sol.localdomain>
References: <20201230130314.3636961-1-sashal@kernel.org>
 <20201230130314.3636961-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230130314.3636961-10-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 08:02:52AM -0500, Sasha Levin wrote:
> From: Daniel Rosenberg <drosen@google.com>
> 
> [ Upstream commit 7ad08a58bf67594057362e45cbddd3e27e53e557 ]
> 
> Expand f2fs's casefolding support to include encrypted directories.  To
> index casefolded+encrypted directories, we use the SipHash of the
> casefolded name, keyed by a key derived from the directory's fscrypt
> master key.  This ensures that the dirhash doesn't leak information
> about the plaintext filenames.
> 
> Encryption keys are unavailable during roll-forward recovery, so we
> can't compute the dirhash when recovering a new dentry in an encrypted +
> casefolded directory.  To avoid having to force a checkpoint when a new
> file is fsync'ed, store the dirhash on-disk appended to i_name.
> 
> This patch incorporates work by Eric Biggers <ebiggers@google.com>
> and Jaegeuk Kim <jaegeuk@kernel.org>.
> 
> Co-developed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please don't backport this to the LTS kernels.  This is a new feature, not a
fix, and you missed prerequisite patches...

- Eric
