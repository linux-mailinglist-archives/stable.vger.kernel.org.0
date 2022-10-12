Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E428E5FC828
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 17:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJLPR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 11:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJLPRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 11:17:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D579D18C9;
        Wed, 12 Oct 2022 08:17:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8B28A1F381;
        Wed, 12 Oct 2022 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665587864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUQdCV8qiu2z5cZbzxSEaEkk7or+cErTkTgKM6DkvSE=;
        b=TQBH6wZEfg2J4/JXfuz2CUfAw1+Wpt5z7yW90MCznNrPc1PrIJijJ1VCqid5Cvm+eI60qQ
        5WWug0YABffQ/hGUHPcDgZhagmRKLa90pB0Wew+DeotunOyVKjqfwfB6eOJem5VKN1lmll
        uCEHtshMka44Sj3n5sJJu1jBIKwEHAQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665587864;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUQdCV8qiu2z5cZbzxSEaEkk7or+cErTkTgKM6DkvSE=;
        b=ZGqGu7Q+iBgrLcvuZ+tMwCZGjy+Qc/1rmPnZpoX8IMOOWToDcLWEdjt38F6XYNAO2Xee72
        Q3pu8bOFCyF3fiDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1219F13ACD;
        Wed, 12 Oct 2022 15:17:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 78FiAZjaRmM4PAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 12 Oct 2022 15:17:44 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id a8723c1a;
        Wed, 12 Oct 2022 15:18:39 +0000 (UTC)
Date:   Wed, 12 Oct 2022 16:18:39 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix BUG_ON() when directory entry has invalid
 rec_len
Message-ID: <Y0baz6C1aKRjKzvJ@suse.de>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221012131330.32456-1-lhenriques@suse.de>
 <Y0a+Ommsgm4ogo7u@suse.de>
 <Y0bNc9XZA5wXNJMX@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0bNc9XZA5wXNJMX@mit.edu>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 10:21:39AM -0400, Theodore Ts'o wrote:
> On Wed, Oct 12, 2022 at 02:16:42PM +0100, Luís Henriques wrote:
> > Grr, looks like I accidentally reused a 'git send-email' from shell
> > history which had a '--in-reply-to' in it.  Please ignore and sorry about
> > that.  I've just resent a new email.
> 
> No worries!  The --in-reply-to wasn't actually a problem, since b4
> generally will do the right thing (and sometimes humans prefer the
> in-reply-to since they can more easily see the patch that it is
> replacing/obsoleting).
> 
> b4 can sometimes get confused when a patch series gets split, and both
> parts of the patch series are in a reply-to mail thread to the
> original patch series, since if it can't use the -vn+1 hueristic or
> the "subject line has stayed the same but has a newer date" hueristic,
> it falls back to "latest patch in the mail thread".  So if there are
> two "valid" patches or patch series in an e-mail thread, b4 -c
> (--check-newer-revisions) can get confused.  But even in that case,
> that it's more a minor annoyance than anything else.
> 
> So in the future, don't feel that you need to resend a patch if
> there's an incorrect/older --in-reply-to; it's not a big deal.

Great, I haven't yet included b4 in my workflow so, to be honest, I didn't
really thought about that tool being confused.  What really made me resend
the patch was that I used the *wrong message-ID in the "--in-reply-to"!
And that thread already had a v2 patch, which would could easily confuse
humans.  Hopefully, b4 won't be confused by that either.

Cheers,
--
Luís
