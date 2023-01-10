Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6C866435E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 15:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbjAJOfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 09:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjAJOfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 09:35:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21B4CE3;
        Tue, 10 Jan 2023 06:35:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4741E4EEF3;
        Tue, 10 Jan 2023 14:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673361343;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jIsnICKDFKhguVfgisA4ETDbWchSWVTrOhoHYr1z6c8=;
        b=0a1B38L9l5kb82YkgaZpSDLEcYEM1wx6SyKUrFedvtVCAPW7ACyVX0Q9USy6avgNId8Ht6
        Io1xmLNbokBurGMt6WEp/PN4lgpP535vRo5t5R+VZOMeIQ/0Lpp0DuYF3SP9lNlp6Mr7ZG
        lXdBwCI3i6GOCEGo+58wHdgeyO3rUos=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673361343;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jIsnICKDFKhguVfgisA4ETDbWchSWVTrOhoHYr1z6c8=;
        b=8ZvKG2P+DY9WzEUgZD7oduekvQQabehGzx3T/9xWFiG3avrm4Dby6/BCVdez7RGkcawfjj
        G8or4m6brXk21fBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1BD951358A;
        Tue, 10 Jan 2023 14:35:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tyjGBb93vWPeYgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 10 Jan 2023 14:35:43 +0000
Date:   Tue, 10 Jan 2023 15:30:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: please rebase the patch queue-6.1(btrfs: fix an error handling
 path in btrfs_defrag_leaves)
Message-ID: <20230110143008.GB11562@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20230110123813.7DCC.409509F4@e16-tech.com>
 <Y70aTKUaBOLah8EQ@kroah.com>
 <20230110164234.14C5.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110164234.14C5.409509F4@e16-tech.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 04:42:35PM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Tue, Jan 10, 2023 at 12:38:14PM +0800, Wang Yugui wrote:
> > > Hi, Sasha Levin
> > > 
> > > please rebase the patch queue-6.1(btrfs: fix an error handling path in btrfs_defrag_leaves)
> > > just like queue-6.0, and then drop its 8 depency patches.
> > > 
> > > the 2 of 8 depency patches are file rename, so it will make later depency patch become
> > > difficult?
> > > #btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
> > > #btrfs-move-flush-related-definitions-to-space-info.h.patch
> > > #btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
> > > #btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
> > > #btrfs-move-assert-helpers-out-of-ctree.h.patch
> > > #btrfs-move-the-printk-helpers-out-of-ctree.h.patch
> > > #**btrfs-rename-struct-funcs.c-to-accessors.c.patch
> > > #**btrfs-rename-tree-defrag.c-to-defrag.c.patch
> > > 
> > > and the patch(btrfs: fix an error handling path in btrfs_defrag_leaves) is small,
> > > so a rebase will be a good choice.
> > 
> > I do not understand, sorry, we can not rebase anything, that's not how
> > our patch queue works.
> > 
> > So what exactly do you want to see changed?  What patches dropped?  And
> > what added?
> 
> What I suggest:
> 
> 1)replace queue-6.1/btrfs-fix-an-error-handling-path-in-btrfs_defrag_lea.patch
>         with queue-6.0/btrfs-fix-an-error-handling-path-in-btrfs_defrag_lea.patch
> 
> 2) drop pathes in queue-6.1/
> btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
> btrfs-move-flush-related-definitions-to-space-info.h.patch
> btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
> btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
> btrfs-move-assert-helpers-out-of-ctree.h.patch
> btrfs-move-the-printk-helpers-out-of-ctree.h.patch
> btrfs-rename-struct-funcs.c-to-accessors.c.patch
> btrfs-rename-tree-defrag.c-to-defrag.c.patch

Right, I'd rather not add all the code moving patches to stable though I
understand that it could ease backporting. Many stable backports need to
be adapted to versions before/after the code moves so the work has to be
done anyway.
