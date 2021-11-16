Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503CF452FF1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 12:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhKPLNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 06:13:55 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:48860 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbhKPLNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 06:13:54 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3A83D218A4;
        Tue, 16 Nov 2021 11:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637061057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ww8zVKu6WaxX7aRdyksWEN/olgXu38JE92zBruf0Q9A=;
        b=HMiQzpDFiTw51iadojzG8HM2HtLYC/Ho0RW0Bwdm4EkKLQ2kivwUyLsxx4mrB1FgmW3l9G
        jtc9SxkcGY6clCHqvMasKch6nDEhoZpQAIyO/2PzJASWjRJ3dGPY2mF/jo4ezABY6jVAiE
        ZtFULl0DR0ROdKW4HLx08/p2ZHt3cXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637061057;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ww8zVKu6WaxX7aRdyksWEN/olgXu38JE92zBruf0Q9A=;
        b=rVlYLbJAQkLMrYsphzsmZS2OdV2ylzpvK1KKhGZX+hH44JpECPxZqXL1sTNCKOKbD1I1Uz
        8GeWamZ63Qg1whBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 049C913C06;
        Tue, 16 Nov 2021 11:10:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D5UcAcGRk2GIPAAAMHmgww
        (envelope-from <bp@suse.de>); Tue, 16 Nov 2021 11:10:57 +0000
Date:   Tue, 16 Nov 2021 12:10:48 +0100
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/sev: Make the #VC exception stacks
 part of the default" failed to apply to 5.15-stable tree
Message-ID: <YZORuI1FLTO39Xt7@zn.tnic>
References: <1637060086211132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1637060086211132@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 11:54:46AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 541ac97186d9ea88491961a46284de3603c914fd Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Fri, 1 Oct 2021 21:41:20 +0200
> Subject: [PATCH] x86/sev: Make the #VC exception stacks part of the default
>  stacks storage
> 
> The size of the exception stacks was increased by the commit in Fixes,
> resulting in stack sizes greater than a page in size. The #VC exception
> handling was only mapping the first (bottom) page, resulting in an
> SEV-ES guest failing to boot.
> 
> Make the #VC exception stacks part of the default exception stacks
> storage and allocate them with a CONFIG_AMD_MEM_ENCRYPT=y .config. Map
> them only when a SEV-ES guest has been detected.
> 
> Rip out the custom VC stacks mapping and storage code.
> 
>  [ bp: Steal and adapt Tom's commit message. ]
> 
> Fixes: 7fae4c24a2b8 ("x86: Increase exception stack sizes")

$ git tag --contains 7fae4c24a2b8 | grep -E "^v"
v5.16-rc1

Scripts kaputtski?

:-)

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
