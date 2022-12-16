Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39ED64EFFE
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiLPRFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 12:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiLPRFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 12:05:14 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4A969AB0
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 09:05:13 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BGH4tFH017214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 12:04:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671210298; bh=czyZa4h4xnG1V2lFwz0kam2aIsqEihy+AZSfIfZu/AY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=KvOaE/9hc3wBmqQYhQFxe6AuvtCcPhKHEh9QBl1oQgL/pTsVUkHNLxzTggMMcMLqd
         i+XOmb4YWd/KI7Z2HU/F81WV6tBI6d/fdZNqDBb/xigPS2Z/Ms+Wd5+BHnykxt/iIS
         pGqVYGXAwtdDxmJiUcIc4H3fg13OOvvgRpdT51t5SVaDFo7DL1JPv/TNNKQG1x5D1+
         IoOWtbG+k7bEq5VP9YSTjAWj/VM9kuO0c1cY8mHlZ90Xx4+9372a78jYN2xFMg/2pw
         krgWbFFpjHLZByuOqZpCSsHwNfmRB6g8l470apqUcLDnX/EL4upEPkzC1a4Hmv+/ly
         ozWT4d3npKD+g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4F0E415C40A2; Fri, 16 Dec 2022 12:04:55 -0500 (EST)
Date:   Fri, 16 Dec 2022 12:04:55 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     Lee Jones <lee@kernel.org>,
        syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Subject: Re: kernel BUG in ext4_free_blocks (2)
Message-ID: <Y5ylNxoN2p7dmcRD@mit.edu>
References: <0000000000006c411605e2f127e5@google.com>
 <000000000000b60c1105efe06dea@google.com>
 <Y5vTyjRX6ZgIYxgj@mit.edu>
 <Y5xsIkpIznpObOJL@google.com>
 <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 03:09:04PM +0100, Aleksandr Nogikh wrote:
> 
> Syzbot is actually reacting here to this bug from the Android namespace:
> 
> https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c

Thanks for the clarification; stupid question, though -- I see
"upstream" is listed on the dashboard link above.  Assuming that
"usptream" is "Linus's tree", why was it still saying, "I can't find
this patch in any of my trees"?  What about the upstream tree?

> > Although this does appear to be a Stable candidate, I do not see it
> > in any of the Stable branches yet.  So I suspect the answer here is to
> > wait for the fix to filter down.

The reason why it's not hit any of the long-term stable trees is
because the patch doesn't apply cleanly, because there are
pre-requisite commits that were required.  Here are the required
commits for 5.15:

https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext4_for_5.15.83

% git log --reverse --oneline  v5.15.83..
96d070a12a7c ext4: refactor ext4_free_blocks() to pull out ext4_mb_clear_bb()
    [ Upstream commit 8ac3939db99f99667b8eb670cf4baf292896e72d ]
2fa7a1780ecd ext4: add ext4_sb_block_valid() refactored out of ext4_inode_block_valid()
    [ Upstream commit 6bc6c2bdf1baca6522b8d9ba976257d722423085 ]
8dc76aa246b1 ext4: add strict range checks while freeing blocks
    [ Upstream commit a00b482b82fb098956a5bed22bd7873e56f152f1 ]
deb2e1554497 ext4: block range must be validated before use in ext4_mb_clear_bb()
    [ Upstream commit 1e1c2b86ef86a8477fd9b9a4f48a6bfe235606f6 ]

Further backports to LTS kernels for 5.10, 5.4, etc., are left as an
exercise to the reader.  :-)

	     	   	      	       	     - Ted
					     
P.S.  I have not tried to run gce-xfstests regressions yet. so the
only QA done on these backports is "it builds, ship it!"  (And it
fixes the syzbot reproducers.)  Then again, we're not running this
kind of regression tests on the LTS kernels.

P.P.S.  If anyone is willing to volunteer to be an ext4 backports
maintainer, please contact me.  The job description is (a) dealing
with the stable backport failures and addressing the patch conflicts,
potentially by dragging in patch prerequisites, and (b) running
"gce-xfstests ltm -c ext4/all -g auto" and making sure there are no
regressions.

	     	   		  	      - Ted
