Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD0597429
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 18:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiHQQaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 12:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241159AbiHQQ3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 12:29:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D64EA2622;
        Wed, 17 Aug 2022 09:29:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8E04F37CA9;
        Wed, 17 Aug 2022 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660753738;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lL2oRxUB2zNiDSHL08lc1EgwtUwwuRJxehS/wfuxEr8=;
        b=gTJptUcWDH9T32V6Of5E4f+an9thPxzAqL2zZ4uFoaV32CH/kC5Oqo3vZ9LHTmTlJ+tuVL
        A3+dhsBh5eZdfCmtH7xL/RQmfyMQDcGUzBKRNZme0snq0i9GrTs/Uv/03JleGFJ8Qio7Bf
        EZWqi5eB5Z1tnJlzobNWGKw7Eu4jJuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660753738;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lL2oRxUB2zNiDSHL08lc1EgwtUwwuRJxehS/wfuxEr8=;
        b=oQlChQs+3AqvuskTD+p7PyrlbFGLHkNkA4Q7T/ZAeXWAIss/IBZKuESNJEiq28uBip5Bba
        EPXRnNLmC1ChRADQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 616FA13A8E;
        Wed, 17 Aug 2022 16:28:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cg/SFkoX/WJXKAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 17 Aug 2022 16:28:58 +0000
Date:   Wed, 17 Aug 2022 18:23:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.18 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Message-ID: <20220817162347.GF13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Greg KH <gregkh@linuxfoundation.org>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1659600630.git.wqu@suse.com>
 <YvESBmvjMqIXvqjp@kroah.com>
 <Yvejlr1Nds8wtyKj@kroah.com>
 <b10f1e72-0846-f46c-816a-352646ae5661@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b10f1e72-0846-f46c-816a-352646ae5661@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 14, 2022 at 06:17:45AM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/8/13 21:13, Greg KH wrote:
> > On Mon, Aug 08, 2022 at 03:39:18PM +0200, Greg KH wrote:
> >> On Thu, Aug 04, 2022 at 04:10:57PM +0800, Qu Wenruo wrote:
> >>> Hi Greg and Sasha,
> >>>
> >>> This two patches are backports for v5.18 branch.
> >>
> >> I also need these for the 5.19.y branch if we were to take them into
> >> 5.18.y as you do not want anyone to suffer a regression when moving to
> >> the newer kernel release.
> >>
> >> So I'll wait for those to be sent before taking any of these.
> >
> > I've dropped all of these btrfs backports from my "to review" queue now.
> > Please fix them all up, get the needed acks, and then resend them and I
> > will be glad to reconsider them at that point in time.
> 
> To David,
> 
> Mind to give an ACK for these backports?

Acked-by: David Sterba <dsterba@suse.com>
