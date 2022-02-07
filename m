Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799034AC70B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 18:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiBGRQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 12:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346605AbiBGRID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 12:08:03 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87F7C0401D3;
        Mon,  7 Feb 2022 09:08:00 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nH7Uc-000FVI-NY; Mon, 07 Feb 2022 17:07:58 +0000
Date:   Mon, 7 Feb 2022 17:07:58 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ari Sundholm <ari@tuxera.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Anton Altaparmakov <anton@tuxera.com>
Subject: Re: [PATCH] fs/read_write.c: Fix a broken signed integer overflow
 check.
Message-ID: <YgFR7mJE17C3LyzP@zeniv-ca.linux.org.uk>
References: <20220207120711.4070403-1-ari@tuxera.com>
 <YgEzs2Hp0LrdDmJu@zeniv-ca.linux.org.uk>
 <cd346b72-1899-8f2d-5ff6-65c4ac93308c@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd346b72-1899-8f2d-5ff6-65c4ac93308c@tuxera.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 06:44:55PM +0200, Ari Sundholm wrote:
> Hello, Al,
> 
> On 2/7/22 16:58, Al Viro wrote:
> > On Mon, Feb 07, 2022 at 02:07:11PM +0200, Ari Sundholm wrote:
> > > The function generic_copy_file_checks() checks that the ends of the
> > > input and output file ranges do not overflow. Unfortunately, there is
> > > an issue with the check itself.
> > > 
> > > Due to the integer promotion rules in C, the expressions
> > > (pos_in + count) and (pos_out + count) have an unsigned type because
> > > the count variable has the type uint64_t. Thus, in many cases where we
> > > should detect signed integer overflow to have occurred (and thus one or
> > > more of the ranges being invalid), the expressions will instead be
> > > interpreted as large unsigned integers. This means the check is broken.
> > 
> > I must be slow this morning, but... which values of pos_in and count are
> > caught by your check, but not by the original?
> > 
> 
> Thank you for your response and questions.
> 
> Assuming an x86-64 target platform, please consider:
> 
> loff_t pos_out = 0x7FFFFFFFFFFEFFFFLL;
> and
> uint64_t count = 65537;
> 
> The type of the expression (pos_out + count) is a 64-bit unsigned type, by
> C's integer promotion rules. Its value is 0x8000000000000000ULL, that is,
> bit 63 is set.
> 
> The comparison (pos_out + count) < pos_out, again due to C's integer
> promotion rules, is unsigned. Thus, the comparison, in this case, is
> equivalent to:
> 
> 0x8000000000000000ULL < 0x7FFFFFFFFFFEFFFFULL,
> 
> which is false. Please note that the LHS is not expressible as a positive
> integer of type loff_t. With larger values for count, the problem should
> become quite obvious, as some the offsets within the file would not be
> expressible as positive integers of type loff_t. But I digress. As we can
> see above, the overflow is missed.
> 
> With the LHS explicitly cast to loff_t, the comparison is equivalent to:
> 
> 0x8000000000000000LL < 0x7FFFFFFFFFFEFFFFLL,
> 
> which is true, as the LHS is negative.
> 
> This has also been verified in practice, and was detected when running tests
> on special cases of the copy_file_range syscall on different filesystems.

Er...  I still don't see the problem here.  If the destination filesystem
explicitly allows offsets in excess of 2^63, what's the point in that
-EOVERFLOW?  And if it doesn't, you'll get count truncated by
generic_write_check_limits(), down to the amount remaining until the
fs limit...

Same on the input side - if your source file is at least 2^63, what's the
problem?  And if not, you'll get count capped by file size - pos_in, right
under that check...

Which filesystems had been involved and what was the test?
