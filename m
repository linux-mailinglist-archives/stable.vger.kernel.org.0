Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0EB44A42F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhKIBv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237655AbhKIBv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:51:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EA4E61105;
        Tue,  9 Nov 2021 01:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636422521;
        bh=kIA6Eokj76BQmMANJNXcdbCP8CCrVGLB+Dzn7QmgJik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LAwQrXi2J7WKAd6EfjqVxJOHxSdCvCDLtjxf5hTjB11OEHaCuhr/EpbffbgWd/ATL
         OH01or7BPZ/iyPfuX9kMceDA7SVc86ppadMmQMwTNvCmw5IZYsEQV4143cX8DcdGqd
         OniH/BJzoPy5D6rXTmU6PUGGhAqQXSQSnTUDU6rom54gncY1OQL7mkFU6obleQaSG5
         HW+v0KomxGE0pqJHUZnPFxLwFBLzE2Mjqmy0yyR82KWCRujBVZueXkfldNlbaeu5zQ
         ShSg8vi6OBsM3sicwax1erEOodN0A8RSiAprDBv1DuIixy5iRLncAncsGUYtRVPP+v
         tQjSllh56QEUQ==
Date:   Mon, 8 Nov 2021 17:48:40 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>, tytso@mit.edu,
        jaegeuk@kernel.org, corbet@lwn.net, linux-fscrypt@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 021/101] fscrypt: allow 256-bit master keys
 with AES-256-XTS
Message-ID: <YYnTeBCwn6fd/kVU@gmail.com>
References: <20211108174832.1189312-1-sashal@kernel.org>
 <20211108174832.1189312-21-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108174832.1189312-21-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 08, 2021 at 12:47:11PM -0500, Sasha Levin wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> [ Upstream commit 7f595d6a6cdc336834552069a2e0a4f6d4756ddf ]
> 
> fscrypt currently requires a 512-bit master key when AES-256-XTS is
> used, since AES-256-XTS keys are 512-bit and fscrypt requires that the
> master key be at least as long any key that will be derived from it.
> 
> However, this is overly strict because AES-256-XTS doesn't actually have
> a 512-bit security strength, but rather 256-bit.  The fact that XTS
> takes twice the expected key size is a quirk of the XTS mode.  It is
> sufficient to use 256 bits of entropy for AES-256-XTS, provided that it
> is first properly expanded into a 512-bit key, which HKDF-SHA512 does.
> 
> Therefore, relax the check of the master key size to use the security
> strength of the derived key rather than the size of the derived key
> (except for v1 encryption policies, which don't use HKDF).
> 
> Besides making things more flexible for userspace, this is needed in
> order for the use of a KDF which only takes a 256-bit key to be
> introduced into the fscrypt key hierarchy.  This will happen with
> hardware-wrapped keys support, as all known hardware which supports that
> feature uses an SP800-108 KDF using AES-256-CMAC, so the wrapped keys
> are wrapped 256-bit AES keys.  Moreover, there is interest in fscrypt
> supporting the same type of AES-256-CMAC based KDF in software as an
> alternative to HKDF-SHA512.  There is no security problem with such
> features, so fix the key length check to work properly with them.
> 
> Reviewed-by: Paul Crowley <paulcrowley@google.com>
> Link: https://lore.kernel.org/r/20210921030303.5598-1-ebiggers@kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't expect any problem with backporting this, but I don't see how this
follows the stable kernel rules (Documentation/process/stable-kernel-rules.rst).
I don't see what distinguishes this patch from ones that don't get picked up by
AUTOSEL; it seems pretty arbitrary to me.

- Eric
