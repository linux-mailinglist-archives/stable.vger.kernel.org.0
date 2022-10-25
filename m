Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D0260C810
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJYJ3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJYJ3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:29:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E31DF5B;
        Tue, 25 Oct 2022 02:27:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 622CC220A6;
        Tue, 25 Oct 2022 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666690019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+HGnLY306jy4fvUdCHxKjpjZejfwZcQIT35V1hFjoA=;
        b=OUtfMkz3OJvDfqAMtwqWf7k1Pi7qIxAS5MB102cPv5WME1jsfKJfQ77lN+/tz24xTKGPnb
        wj3EEDG4GRCBPpMFzEZ3V5vmDURJndwsAzlxBrcdrMtfnLdyR4k+tjxYxxYC7QmvzfOzO2
        AAPXhTky1UlF5hepfpXpIHnVfaai1b8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666690019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+HGnLY306jy4fvUdCHxKjpjZejfwZcQIT35V1hFjoA=;
        b=EhnJldASVXrNxBiqA2m24UtHP/rG2wFxWhvo9Q4JG4X+pTLPBGuTdZhub1Sb+A14G/ff58
        Pfpi1gJXhDWHhrDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 509B7134CA;
        Tue, 25 Oct 2022 09:26:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WXOrE+OrV2MBQAAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 25 Oct 2022 09:26:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id DDD13A06F5; Tue, 25 Oct 2022 11:26:58 +0200 (CEST)
Date:   Tue, 25 Oct 2022 11:26:58 +0200
From:   Jan Kara <jack@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Schmitt <scdbackup@gmx.net>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jeff Layton <jlayton@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: prevent file time rollover after year 2038
Message-ID: <20221025092658.qshqotkncsbp5nr5@quack3>
References: <20221020160037.4002270-1-arnd@kernel.org>
 <20221024122614.bkcehqr7gi3f23ca@quack3>
 <20221024145121.2dj6sdeqvxndbhpt@quack3>
 <20221024135517.7d40b96a206020eca03e3802@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024135517.7d40b96a206020eca03e3802@linux-foundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 24-10-22 13:55:17, Andrew Morton wrote:
> On Mon, 24 Oct 2022 16:51:21 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > > Thanks! I've added the patch to my tree and will push it to Linus.
> > 
> > Oh, I have noticed Andrew has merged the patch already into his tree. So
> > dropped from mine.
> 
> You could have just added it and I'd drop my copy when Stephen tells
> us of the duplicate.  But whatever.

Yeah, I know. But since I've just pulled the patch in I figured it's less
work if I just take it out as well ;)

> Maybe you owe us an ISOFS MAINTAINERS entry ;)

Yeah, I can see isofs currently has no entry in MAINTAINERS. OK, I'll add
some ;)

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
