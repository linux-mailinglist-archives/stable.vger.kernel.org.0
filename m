Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41254FF82F
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 15:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiDMNxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 09:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiDMNxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 09:53:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAC3201A3;
        Wed, 13 Apr 2022 06:50:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0D049210E5;
        Wed, 13 Apr 2022 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649857837;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qieCuiLQH+pWYdEHMFdODgDSSaypk9s0BWvVFU2mA2Y=;
        b=oR5TtgkXxJoWj6mzYUVlGWw7ufhjYXiCRUm5uVgbgiFhgkVfXu825tZEGYS/xGkwAg0S7t
        eC8Y06bPXLnKe6WQyR/KPv99ZMcDEoNpYNTh+zeSukGJaUHzasSfYIuGzFGwngxlYmL8HS
        uILY3MH0kYFXcJeD3OOC9Hhtzw0wbZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649857837;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qieCuiLQH+pWYdEHMFdODgDSSaypk9s0BWvVFU2mA2Y=;
        b=4cLr30CNjqW1tkVQgQ40CKf6+yeyquCockCeHLSIUemWJIWyv2/3fxxhf1jRNk+Q7trx6r
        HWS0oVLaBKhhqJAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D22D113A91;
        Wed, 13 Apr 2022 13:50:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IgSIMizVVmJgCQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 13 Apr 2022 13:50:36 +0000
Date:   Wed, 13 Apr 2022 15:46:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when
 submit_one_bio() failed
Message-ID: <20220413134630.GI15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
 <20220412204104.GA15609@twin.jikos.cz>
 <447a2d76-dfff-9efb-09e8-9778ac4a44f2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <447a2d76-dfff-9efb-09e8-9778ac4a44f2@gmx.com>
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

On Wed, Apr 13, 2022 at 07:32:41AM +0800, Qu Wenruo wrote:
> On 2022/4/13 04:41, David Sterba wrote:
> > On Tue, Apr 12, 2022 at 08:30:13PM +0800, Qu Wenruo wrote:
> >> The commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
> >> reads") itself is completely fine, it's our existing code not properly
> >> handling the error from bio submission hook properly.
> >>
> >> This patch will make submit_one_bio() to return void so that the callers
> >> will never be able to do cleanup when bio submission hook fails.
> >>
> >> CC: stable@vger.kernel.org # 5.18+
> >
> > BTW stable tags are only for released kernels, if it's still in some rc
> > then Fixes: is appropriate.
> 
> The problem is I don't have a good idea on which commit to be fixed.
> 
> Commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
> reads") is completely fine by itself.
> 
> The problem is there for a long long time, but can only be triggered
> with IO errors with that newer commit.
> 
> Should we really use that commit? It looks like a scapegoat to me...

I see, so it does not make sense to put Fixes: if it's not clearly
caused by the patch, the text description of the problem and references
to patches that could affect is OK.

Still the stable tag should reflect where the fix applies but 5.18
hasn't been released so either it's a typo or you know roughly which
stable kernels should get the fix (5.15, 5.10, etc).
