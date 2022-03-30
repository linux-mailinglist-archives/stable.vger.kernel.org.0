Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA22A4ECCDB
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 21:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350401AbiC3TDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 15:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350394AbiC3TDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 15:03:40 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577FD7B543;
        Wed, 30 Mar 2022 12:01:54 -0700 (PDT)
Received: from callcc.thunk.org (c-24-1-67-28.hsd1.il.comcast.net [24.1.67.28])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22UJ1V8e008101
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 15:01:32 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 73D894200DE; Wed, 30 Mar 2022 15:01:31 -0400 (EDT)
Date:   Wed, 30 Mar 2022 15:01:31 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Michael Brooks <m@sweetwater.ai>
Cc:     David Laight <David.Laight@aculab.com>,
        Sasha Levin <sashal@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
Message-ID: <YkSpCy023rHoefi1@mit.edu>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-16-sashal@kernel.org>
 <CAOnCY6TTx65+Z7bBwgmd8ogrCH78pps59u3_PEbq0fUpd1n_6A@mail.gmail.com>
 <9e78091d07d74550b591c6a594cd72cc@AcuMS.aculab.com>
 <CAOnCY6QNPUC-VK+ARLb6i_UskV2CkW+AG5ZqWe_oMGUumL9Gnw@mail.gmail.com>
 <CAOnCY6Q9XoAMpeRfA_ghge3mXkGXFsm4fW64hxcbnMdJyx8Y2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnCY6Q9XoAMpeRfA_ghge3mXkGXFsm4fW64hxcbnMdJyx8Y2g@mail.gmail.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 11:33:21AM -0700, Michael Brooks wrote:
> The /dev/random device driver need not concern itself with root
> adversaries as this type of user has permissions to read and overwrite
> memory - this user even possesses permission to replace the kernel elf
> binary with a copy of /dev/random that always returns the number 0 -
> that is their right.

The design consideration that random number generators do concern
themselves with is recovery after pool exposure.  This could happen
through any number of ways; maybe someone got a hold of the suspended
image after a hiberation, or maybe a VM is getting hybernated, and
then replicated, etc.

One can argue whether or not it's "reasonable" that these sorts of
attacks could happen, or whether they are equivalent to full root
access whether you can overwrite the pool.  The point remains that it
is *possible* to have situations where the internal state of the RNG
might have gotten exposed, and a design criteria is how quickly or
reliably can you reocver from that situation over time.

See the Yarrow paper and its discussion of iterative guessing attack
for an explanation of why cryptographers like John Kelsey, Bruce
Schneier, and Niels Ferguson think it is important.  And please don't
argue with me on this point while discussing which patches should be
backported to stable kernels --- argue with them.  :-)

Cheers,

						- Ted
