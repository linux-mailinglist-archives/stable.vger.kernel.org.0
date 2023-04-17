Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC346E54AA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 00:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDQWWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 18:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDQWWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 18:22:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CB0421A;
        Mon, 17 Apr 2023 15:22:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C12D021987;
        Mon, 17 Apr 2023 22:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681770150;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qAb7nlwr2gwBwC0x/k5wZHXvRdk3L7+2KbQoxqxD21c=;
        b=sOlNF4YQ88syQvalD+J+jQLM36ZPrMAPsf3om0ekyrGThc6kc/0xRaO3Z0csghf3CQJWGU
        Y5EJkAt7aP+eqqVVyVG2rjqnlzJ1QnW+veH7+rlKZIQ4SQTtvdHhpE25AFD2U+dlSWoBsw
        W38aDU7vFFwGv+EmPmRgMBAyU1vlgUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681770150;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qAb7nlwr2gwBwC0x/k5wZHXvRdk3L7+2KbQoxqxD21c=;
        b=jzM+UgCYuG4BJ13eiNX7x5ljEGzZvV0E7BybgzMn1frgBuZmiVosWEbAkDjMDdID+ZAw48
        sGeqrCGHEMF3mpCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B1011390E;
        Mon, 17 Apr 2023 22:22:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /zESJabGPWQJegAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 17 Apr 2023 22:22:30 +0000
Date:   Tue, 18 Apr 2023 00:22:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH pre-6.4] btrfs: dev-replace: error out if we have
 unrepaired metadata error during
Message-ID: <20230417222221.GO19619@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4360e4f01d47cca45930ea74b02c5d734a9cbfbd.1681093106.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4360e4f01d47cca45930ea74b02c5d734a9cbfbd.1681093106.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 10, 2023 at 10:22:57AM +0800, Qu Wenruo wrote:
> This is for pre-6.4 kernels, as scrub code goes through a huge rework.
> 
> [BUG]
> Even before the scrub rework, if we have some corrupted metadata failed
> to be repaired during replace, we still continue replace and let it
> finish just as there is nothing wrong:
> 
>  BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>  BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>  BTRFS warning (device dm-4): tree block 5578752 mirror 0 has bad csum, has 0x00000000 want 0xade80ca1
>  BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>  BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>  BTRFS error (device dm-4): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>  BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad bytenr, has 0 want 5578752
>  BTRFS error (device dm-4): unable to fixup (regular) error at logical 5578752 on dev /dev/mapper/test-scratch1
>  BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 finished
> 
> This can lead to unexpected problems for the result fs.
> 
> [CAUSE]
> Btrfs reuses scrub code path for dev-replace to iterate all dev extents.
> 
> But unlike scrub, dev-replace doesn't really bother to check the scrub
> progress, which records all the errors found during replace.
> 
> And even if we checks the progress, we can not really determine which
> errors are minor, which are critical just by the plain numbers.
> (remember we don't treat metadata/data checksum error differently).
> 
> This behavior is there from the very beginning.
> 
> [FIX]
> Instead of continue the replace, just error out if we hit an unrepaired
> metadata sector.
> 
> Now the dev-replace would be rejected with -EIO, to inform the user.
> Although it also means, the fs has some metadata error which can not be
> repaired, the user would be super upset anyway.
> 
> The new dmesg would look like this:
> 
>  BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>  BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>  BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>  BTRFS error (device dm-4): unable to fixup (regular) error at logical 5570560 on dev /dev/mapper/test-scratch1 physical 5570560
>  BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>  BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>  BTRFS error (device dm-4): stripe 5570560 has unrepaired metadata sector at 5578752
>  BTRFS error (device dm-4): btrfs_scrub_dev(/dev/mapper/test-scratch1, 1, /dev/mapper/test-scratch2) failed -5
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> I'm not sure how should we merge this patch.
> 
> The misc-next is already merging the new scrub code, but the problem is
> there for all old kernels thus we need such fixes.
> 
> Maybe we can merge this fix before the scrub rework, then the rework,
> and finally the better fix using reworked interface?

Rebasing the whole 6.4 queue with the scrub rewrite would be too much
and there's no time left for that before merge window. We'd also need to
retest it after such change.

If we have the fix in master we can do a backport to older stable tree,
in this case it would not be close implementation-wise but the effects
should be the same. Doing two separate fixes will also avoid merge
conflicts.
