Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241E048669D
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbiAFPTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:19:08 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47354 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240393AbiAFPTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:19:08 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4276C21114;
        Thu,  6 Jan 2022 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641482347;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3vzoYJuskF5/uhIe0lRF4N8mvQUoKdiiDOuYiDcwr8=;
        b=Idp1Jc9qfmSN/Ml5G0Wn3xX5JpSxPC7sxkxs3+ytlJGoV/EV8lenjPHR3YR3+H9+NLpdE4
        1fynfUsyEletpTnQXJn+5tG9OBcJviyR+nNHjLnvVmJSo7TtvlaKs3sbGZyn9vPCtxftH7
        ndzOc21ceOSBceVqEEdAxojfpJXQoEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641482347;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3vzoYJuskF5/uhIe0lRF4N8mvQUoKdiiDOuYiDcwr8=;
        b=jxJx3EW1HUWSEsTMQRYn81Ado0J6wNrkAPEHOPqR/gOt8D4KSP0o3tSXJNyQtMhcBfDTcG
        CA4lhMiDm2z8udCQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 3AB1FA3B87;
        Thu,  6 Jan 2022 15:19:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E3F78DA799; Thu,  6 Jan 2022 16:18:36 +0100 (CET)
Date:   Thu, 6 Jan 2022 16:18:36 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: don't start transaction for scrub if the fs
 is mounted read-only
Message-ID: <20220106151836.GF14046@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <20211216114736.69757-1-wqu@suse.com>
 <20211216114736.69757-2-wqu@suse.com>
 <20220103185237.GQ28560@twin.jikos.cz>
 <4f1857d7-3788-6d0e-96a1-23a9a3ec61e9@gmx.com>
 <20220104184044.GV28560@twin.jikos.cz>
 <0a9a1a2c-7052-cb80-a87d-5f1ef6f8802c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a9a1a2c-7052-cb80-a87d-5f1ef6f8802c@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 05, 2022 at 06:13:09AM +0800, Qu Wenruo wrote:
> >>> Should this also verify or at least assert that do_chunk_alloc is not
> >>> set? The scrub code is used for replace that can set the parameter to
> >>> true.
> >>
> >> Replace start needs RW mount, thus we don't need to bother replace in
> >> this case.
> >
> > What if replace starts on rw mount, and then it's flipped to read-only?
> > I don't see how this is prevented (like by mnt_want_write). It should
> > not cause any problems either, as it would not start the transaction.
> 
> For this case, there are 2 entrances:
> 
> - Remount RO
>    We will stop replace in that case
> 
> - Some fs error (like trans abort)
>    I believe we should fail at any transaction start.

Right, thanks, that was the missing piece.
