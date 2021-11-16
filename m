Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656A245317D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 12:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhKPL4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 06:56:25 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:57888 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbhKPLz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 06:55:56 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BF6611FD26;
        Tue, 16 Nov 2021 11:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637063572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pHocy3m1eJUtZ+QU7U0ItcnNOi9rY0WR9oDDl1Ki4U=;
        b=AGfVoCsjrGdl1/CAyKLYV7SOSmakMCifeVslBvKKttI0c7igZcq64ZBfRsFdn9sfhlc0lg
        ScuZvxSGvfFiDC7KdycFzRocQmn6Q4uFaaBSSRVvYCnE9onIbaoV4uCYZxCoIRa1hzdkZA
        AZ5owxG16KAhApfBRv0SlN9UNqWmaCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637063572;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pHocy3m1eJUtZ+QU7U0ItcnNOi9rY0WR9oDDl1Ki4U=;
        b=5gYzeYQsd4GX1d0oAQie7hNQqxiYxTymoeMTz/CO7Ygk6gjgGsfThXDopMoD6xUtCVG+0d
        J2KUY+QeIBUTmAAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AC6E213C0C;
        Tue, 16 Nov 2021 11:52:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5IMLKpSbk2FdTwAAMHmgww
        (envelope-from <bp@suse.de>); Tue, 16 Nov 2021 11:52:52 +0000
Date:   Tue, 16 Nov 2021 12:52:44 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/sev: Make the #VC exception stacks
 part of the default" failed to apply to 5.15-stable tree
Message-ID: <YZObjPyuhsHmREd7@zn.tnic>
References: <1637060086211132@kroah.com>
 <YZORuI1FLTO39Xt7@zn.tnic>
 <YZOU0ViYGD24/Al0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZOU0ViYGD24/Al0@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 12:24:01PM +0100, Greg KH wrote:
> Nope, planning ahead:
> 	$ ~/linux/stable/commit_tree/id_found_in 7fae4c24a2b8
> 	5.16-rc1 queue-4.4 queue-4.9 queue-4.14 queue-4.19 queue-5.4 queue-5.10 queue-5.14 queue-5.15
> 
> That commit is in the current -rc releases right now.

Bah, there's stuff in-flight.

> The problem with this commit is that the cc_platform_has() function is
> not present.  I thought about backporting it as well, but that seemed
> odd as I do not think that feature is in the 5.15 and older kernels,
> right?

The cc_platform_has() was a small set:

https://lore.kernel.org/r/YX%2B5ekjTbK3rhX%2BY@zn.tnic

which wants to keep all those checks confidential guests are going to do
around the code, sane. So you don't really need it but...

> Or is it ok to take the cc_platform_has() function?

... it will simplify all those backports which use it in the future. And
we will use cc_platform_has() from now on in common code.

In any case, we're going to backport it into SLE just for that reason -
so that it can ease backports and there's no kABI nightmares.

HTH.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
