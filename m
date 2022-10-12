Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F1C5FC2A0
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJLJDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 05:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiJLJCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 05:02:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F304B97A2;
        Wed, 12 Oct 2022 02:02:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 639301F37C;
        Wed, 12 Oct 2022 09:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665565328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfiK9XlS8vf7wIi3+hdD7zY490h6oKiwsp6Xn66hWgY=;
        b=WPol0X1B1o9AbyBJWj7Iv3i5W/wpqOOySalW8RUqEW0lKSc/583PO2rPghDhh+wACq3Guz
        v39fmHRVHHE2wfahT+5zczVmhdHI4Dt97NEYs2Ec6/ntd/bVgpsjD1JTcDdOckmMbeJ7pF
        ZozlvF2MyfUZ17fO09KvWExRfklCDO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665565328;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfiK9XlS8vf7wIi3+hdD7zY490h6oKiwsp6Xn66hWgY=;
        b=AxLojc2Yw/MfXh2RPy4Sr8u0Xm5pT3f8YHjoc1J9PsZBvBOMkrnl/V7gboDE3q957HxHZZ
        iWs/RycEnlnNOlDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D19E313A5C;
        Wed, 12 Oct 2022 09:02:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jhvAL4+CRmO7awAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 12 Oct 2022 09:02:07 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id ce5a5aa3;
        Wed, 12 Oct 2022 09:03:03 +0000 (UTC)
Date:   Wed, 12 Oct 2022 10:03:03 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix BUG_ON() when a directory entry has an invalid
 rec_len
Message-ID: <Y0aCx45PBQrde4IC@suse.de>
References: <20221011155745.15264-1-lhenriques@suse.de>
 <Y0YQ42Z/XPuHZRS8@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0YQ42Z/XPuHZRS8@mit.edu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 08:57:07PM -0400, Theodore Ts'o wrote:
> On Tue, Oct 11, 2022 at 04:57:45PM +0100, Luís Henriques wrote:
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 3a31b662f661..06803292e394 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -2254,8 +2254,18 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
> >  	memset(de, 0, len); /* wipe old data */
> >  	de = (struct ext4_dir_entry_2 *) data2;
> >  	top = data2 + len;
> > -	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top)
> > +	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top) {
> > +		if (de->rec_len & 3) {
> 
> As the kernel test bot as flaged, de->rec_len needs to be byte swapped
> on big endian machines.  Also, for block sizes larger than 64k the low
> 2 bits are used to encode rec_len sizes 256k-4.  All of this is
> encoded in ext4_rec_len_from_disk().
> 
> However, I think a better thing to do is instead of doing this one
> check on rec len, that instead we call ext4_check_dir_entry(), which
> will do this check, and many more besides.  It will also avoid some
> code duplication, since it will take care of calling EXT4_ERROR_INODE
> with the appropriate explanatory message.

Awesome, thanks for the explanation, Ted.  I'll work on a v2 of the patch
that'll use ext4_check_dir_entry() and send it after running some tests
with it.  Thanks for the suggestion!

Cheers,
--
Luís
