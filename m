Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BCD5984C6
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 15:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245276AbiHRNv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 09:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245263AbiHRNv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 09:51:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB0261128;
        Thu, 18 Aug 2022 06:51:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C66C03F123;
        Thu, 18 Aug 2022 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660830714;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5J5R+4iCRX/vCWnJqa3Muoe4pQKBEy7Guvgt3BiJoY=;
        b=M9sf0Q2QiLKuo138yin73NSBwYg2XmjeiYVfzHbeLlctvRhu1vGfJszMntSIcsiGUJs4UH
        1fISlKuStxZj39dZgOl5sMJvnad3YOWOahKo5MnUHqxQCopWo0j7NHu/NG+4bU0QQeQYS1
        6EpXryK6PM5V2BWkAMjAVty+yPBO6vQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660830714;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5J5R+4iCRX/vCWnJqa3Muoe4pQKBEy7Guvgt3BiJoY=;
        b=4uWrFnUCl88gMPp8bok5mBdfauRW0plmgBC0TIUMa1Adibtf68WdKAgjkENf69eCpLW/PI
        D6g6LOnKh+S++wCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8AEED139B7;
        Thu, 18 Aug 2022 13:51:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2wPkIPpD/mKtagAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 18 Aug 2022 13:51:54 +0000
Date:   Thu, 18 Aug 2022 15:46:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     bingjing chang <bxxxjxxg@gmail.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        bingjingc <bingjingc@synology.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robbie Ko <robbieko@synology.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: send: fix failures when processing inodes
 with no links
Message-ID: <20220818134643.GL13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, bingjing chang <bxxxjxxg@gmail.com>,
        Filipe Manana <fdmanana@kernel.org>,
        bingjingc <bingjingc@synology.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robbie Ko <robbieko@synology.com>, stable@vger.kernel.org
References: <20220811100912.126447-1-bingjingc@synology.com>
 <20220811100912.126447-3-bingjingc@synology.com>
 <CAL3q7H60vU2SNto+vqo7bc6f8+0bWSTV-yMZ+mTOu-hWt_wejA@mail.gmail.com>
 <CAMmgxWFpRRp_gGXXncBzoJgsmmbfdtBtfysntW7JpxFBxBNPJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMmgxWFpRRp_gGXXncBzoJgsmmbfdtBtfysntW7JpxFBxBNPJQ@mail.gmail.com>
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

On Fri, Aug 12, 2022 at 10:36:38PM +0800, bingjing chang wrote:
> > I seriously doubt that those 4 commits are the only dependencies in
> > order to be able to cleanly backport to 4.9 and other old branches.
> >
> > It may be better to backport only to a few younger stable branches, or
> > just provide later a version of the patch to
> > apply to each desired stable branch (once the fix is in Linus' tree
> > and in a -rc release).
> >
> > If you are not interested in backporting to stable or don't have the
> > time to verify the dependencies and test, then just remove all the
> > stable tags.
> > Just leave a fixes tag:
> >
> > Fixes: 31db9f7c23fbf7 ("Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive")
> 
> Since backporting is not our goal. I will just leave the fix tag here.

This Fixes: points to the original send patch, so that's not really
useful, otherwise if there's a target stable release where the patches
still apply cleanly, or with minimal conflicts it's sufficient to add a
CC: stable tag it's good to have it.
