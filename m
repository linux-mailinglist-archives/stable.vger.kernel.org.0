Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6B24AC303
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345340AbiBGPXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 10:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243944AbiBGPW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 10:22:57 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0D6C0401C1;
        Mon,  7 Feb 2022 07:22:57 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nH5qx-000EH9-5j; Mon, 07 Feb 2022 15:22:55 +0000
Date:   Mon, 7 Feb 2022 15:22:55 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ari Sundholm <ari@tuxera.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Anton Altaparmakov <anton@tuxera.com>
Subject: Re: [PATCH] fs/read_write.c: Fix a broken signed integer overflow
 check.
Message-ID: <YgE5T0NzGqNO+jJ1@zeniv-ca.linux.org.uk>
References: <20220207120711.4070403-1-ari@tuxera.com>
 <YgEzs2Hp0LrdDmJu@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgEzs2Hp0LrdDmJu@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 02:58:59PM +0000, Al Viro wrote:
> On Mon, Feb 07, 2022 at 02:07:11PM +0200, Ari Sundholm wrote:
> > The function generic_copy_file_checks() checks that the ends of the
> > input and output file ranges do not overflow. Unfortunately, there is
> > an issue with the check itself.
> > 
> > Due to the integer promotion rules in C, the expressions
> > (pos_in + count) and (pos_out + count) have an unsigned type because
> > the count variable has the type uint64_t. Thus, in many cases where we
> > should detect signed integer overflow to have occurred (and thus one or
> > more of the ranges being invalid), the expressions will instead be
> > interpreted as large unsigned integers. This means the check is broken.
> 
> I must be slow this morning, but... which values of pos_in and count are
> caught by your check, but not by the original?
> 
> > -	if (pos_in + count < pos_in || pos_out + count < pos_out)
> > +	if ((loff_t)(pos_in + count) < pos_in ||
> > +			(loff_t)(pos_out + count) < pos_out)
> 
> Example, please.  Why do you need that comparison to be signed?

Note that we explicitly truncate count so we won't get past the EOF of
file_in right below that check and the check in generic_write_check_limits()
truncates count so we won't get past ->s_maxbytes on the filesystem we
are writing to.

If both source and destination allow arbitrary offsets, we should not
fail on copy that crosses from 2^63-1 to 2^63.  Your variant will do
just that.

It's multiples of 2^64 that we should never attempt to cross, no matter
what.

IOW, what values of pos_in, pos_out, count, input file size and output
filesystem file size limit do you think should be rejected with
-EOVERFLOW here?
