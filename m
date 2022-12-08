Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F4B646E24
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 12:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLHLLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 06:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiLHLLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 06:11:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AE63B9E7;
        Thu,  8 Dec 2022 03:10:33 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D9151337AA;
        Thu,  8 Dec 2022 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670497831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zmvc3H8NnLbC5krQvKGPaPRF5mseKg2g+qba4OlodDg=;
        b=yewVYfps6/kgbQKcOu7m76whd9zqyQ/QCQn/DShQYd0oYjzPoSc4M3Cp8p89a2QDnkwHHB
        RMi9gt2Qg3/gMI1E5BJfr/RJcfo5y1/Jnv1C6lLCc6ZGEXrQ/cn9O+9Mwcnb/RJeO+7ooq
        m/bXAnnDVOjMCr2tm62qXIVFqD+iVWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670497831;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zmvc3H8NnLbC5krQvKGPaPRF5mseKg2g+qba4OlodDg=;
        b=R9QeLJPT4gPC3e89hukJiNMhJXxfrzuj1YVdXMNaxb8IEaKhjof5rnkN034kQHg7z2s/iW
        QcYlkTa0EtTOkSBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC025138E0;
        Thu,  8 Dec 2022 11:10:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +qfYLSfGkWN9HwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Dec 2022 11:10:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 8EB37A0725; Thu,  8 Dec 2022 10:15:23 +0100 (CET)
Date:   Thu, 8 Dec 2022 10:15:23 +0100
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org, Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Message-ID: <20221208091523.t6ka6tqtclcxnsrp@quack3>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
 <Y5F8ayz4gEtKn0LF@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5F8ayz4gEtKn0LF@mit.edu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ted!

On Thu 08-12-22 00:55:55, Theodore Ts'o wrote:
> One thing which is completely unclear to me is how this relates to the
> claimed regression.  I understand that Jeremi and Thilo have asserted
> that the hang goes away if a backport commit 51ae846cff5 ("ext4: fix
> warning in ext4_iomap_begin as race between bmap and write") is not in
> their 5.15 product tree.

IMHO the bisection was flawed and somehow the test of a revert (which guys
claimed to have done) must have been lucky and didn't trip the race. This
is not that hard to imagine because firstly, the commit 51ae846cff5 got
included in the same stable kernel release as ext4 xattr changes
(65f8b80053 ("ext4: fix race when reusing xattr blocks") and related
mbcache changes) which likely made the race more likely. Secondly, the
mbcache state corruption is not that easy to hit because you need an
interaction of slab reclaim on mbcache entry with ext4 xattr code adding
reference to xattr block and just hitting the reference limit.

> However, the stack traces point to a problem in the extended attribute
> code, which has nothing to do with ext4_bmap(), and commit 51ae846cff5
> only changes the ext4's bmap function --- which these days gets used
> for the FIBMAP ioctl and very little else.
> 
> Furthermore, the fix which Jan provided, and which apparently fixes
> the user's problem, (a) doesn't touch the ext4_bmap function, and (b)
> has a fixes tag for the patch:
> 
>     Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
> 
> ... which is a commit which dates back to 2016, and the v4.6 kernel.  ?!?

Yes. AFAICT the bitfield race in mbcache was introduced in this commit but
somehow ext4 was using mbcache in a way that wasn't tripping the race.
After 65f8b80053 ("ext4: fix race when reusing xattr blocks"), the race
became much more likely and users started to notice...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
