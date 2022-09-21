Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B585BF3BB
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 04:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiIUCm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 22:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiIUCmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 22:42:16 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE157D7A8;
        Tue, 20 Sep 2022 19:42:14 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28L2fupT001976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 22:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1663728119; bh=t2Q8V+AEIFSC4FWyOVVZ3q/0L0fosOQqOKm2sowUgLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=DBiS/xxerukulQL4UwQIAmdTUPF9ZSkwh0fPFFq45tIbzNTTWEtxhAsfkEW70KQS6
         qVQtcbPI6J+lJlpLcMN+MNpep3yeA+QiSlt78GuRjpM0NlbsRU7CUd8lClb5b+pepC
         DSS5we2t7YAFaleOQHG9zF1rC1W0QjD9Q0SMXgAHw2PHxAHAvVY8VlEORVR60ahCKx
         r9VUo+eHY2Tjmw1u8rvxxTfK//3CQeIm7I52ipSmSoYVorRjTXvjyhmM9IYSb+90KY
         ESIQQzwUFtn0JUDdW51LtlAvo1Y+u1sCQeYNRMUINshuUyBZAmigOj0rBhBZeJUCU6
         5zAPxOdZN1BPg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C6C2515C526C; Tue, 20 Sep 2022 22:41:56 -0400 (EDT)
Date:   Tue, 20 Sep 2022 22:41:56 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Subject: Re: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
Message-ID: <Yyp59DELlYXpoCBC@mit.edu>
References: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
 <48bb6266-2d5c-ffcd-6982-4fd02bfdcfc3@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48bb6266-2d5c-ffcd-6982-4fd02bfdcfc3@leemhuis.info>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hazem started separate e-mail threads on this issue (separated by
about an hour), and I replied to the earlier one here:

    https://lore.kernel.org/all/Yypx6VQRbl3bFP2v@mit.edu/

TL;DR:

1)  The patch landed in 5.6, and improved performance for some
workloads, and also fixed a potential security problem (exposure of
stale data caused by a race).

2)  If you are using a storage device >= 128GB, and a version of
e2fsprogs v1.43.2 (released six years ago), the journal size will be
1GB, which Hazem reported resolved the problem.

3) I disagree that we should revert this commit, as it only changes a
default.  If you prefer the older behavior, you can change it with a
mount option.

						- Ted
