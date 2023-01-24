Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C25F679F8D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 18:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbjAXRD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 12:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbjAXRDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 12:03:42 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7E04A1CD;
        Tue, 24 Jan 2023 09:03:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AC3681FE57;
        Tue, 24 Jan 2023 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674579778;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bDWQxMnhLeGsZ8JNduZ1oVI86fu9mUjTwWZnWw3q6rQ=;
        b=M6Z43LSBW2oCK013O2Cs2fls9oa6YL80Cqy+I09ZtFXUqVns2dU+IzcA9n/sYQEMDC3sKf
        ObJF+jzoM3eZtEq9FAhoL+42jDUSUiBiTuRcqpckvSYXcQ4cMqrg4PMsBkWAI5nZWmR5ir
        r6xWbXcV5TlkzgAsf2ks/iBVEsZlrzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674579778;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bDWQxMnhLeGsZ8JNduZ1oVI86fu9mUjTwWZnWw3q6rQ=;
        b=bupjln3b4gXMhPj34sRKzrtwUUVdEjaAyClle2IieUEZOF0LXOAnO/M9x8jQuUa0BomPU8
        l9TrNcHUcg9MaWAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 77F04139FB;
        Tue, 24 Jan 2023 17:02:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xfVrHEIP0GNYXAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 24 Jan 2023 17:02:58 +0000
Date:   Tue, 24 Jan 2023 17:57:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 15/35] btrfs: stop using write_one_page in
 btrfs_scratch_superblock
Message-ID: <20230124165716.GS11562@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20230124134131.637036-1-sashal@kernel.org>
 <20230124134131.637036-15-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124134131.637036-15-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 08:41:11AM -0500, Sasha Levin wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 26ecf243e407be54807ad67210f7e83b9fad71ea ]
> 
> write_one_page is an awkward interface that expects the page locked and
> ->writepage to be implemented.  Replace that by zeroing the signature
> bytes and synchronize the block device page using the proper bdev
> helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Sterba <dsterba@suse.com>
> [ update changelog ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this patch and "btrfs: factor out scratching of one regular
super block" from all stable queues. It's not a fix, only preparatory
work to allow removing write_one_page from MM code.

Commit ids: 0e0078f72be81bbb and 26ecf243e407be54
