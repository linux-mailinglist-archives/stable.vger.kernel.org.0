Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6EB57A6D7
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 20:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbiGSS6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 14:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiGSS6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 14:58:01 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F5F371A7;
        Tue, 19 Jul 2022 11:57:58 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26JIvIO3024559
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 14:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1658257041; bh=BIjtyFIgMPnChoE7vwY9XWlVWzUjFB9JtmI293znBvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=E4xS15bHFDIay7XDBxKgPt+kzSB6T2hLWBbV8afitS4YkEkBwTWZM/wvXJ05JPEal
         AKRPosIRGIcP7M4GY4jHxEmF8OIcUmFhQWPrk2bM740qic4yxE3Gdj9rCrCSrriRE5
         xTVLL4VSZGJ5RzEHxkDFwj4PiEiVw168lRaHjmRyOu3TriXFe+UC8XyW7dJIYVcjnG
         wSO1H3JvTH6eKZnd3mRQa0iK6X4GzbkHWLzsTYOtYgVwBIOOlU+nCEdItmbA/UQUhS
         uWTnXK7UNs+I9G5aa6Mvu9Yxe8MKNJP7qxkBnHD9vfvDnc93E62JdFXmW9NH3IvnsC
         s1yvW5za9VSvg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A79AE15C00E4; Tue, 19 Jul 2022 14:57:18 -0400 (EDT)
Date:   Tue, 19 Jul 2022 14:57:18 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Baokun Li <libaokun1@huawei.com>, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        ritesh.list@gmail.com, lczerner@redhat.com, enwlinux@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yebin10@huawei.com, yukuai3@huawei.com,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH 4.19] ext4: fix race condition between
 ext4_ioctl_setflags and ext4_fiemap
Message-ID: <Ytb+ji56S/de/5Rm@mit.edu>
References: <20220715023928.2701166-1-libaokun1@huawei.com>
 <YtF1XygwvIo2Dwae@kroah.com>
 <425ab528-7d9a-975a-7f4c-5f903cedd8bc@huawei.com>
 <YtaVAWMlxrQNcS34@kroah.com>
 <ffb13c36-521e-0e06-8fd6-30b0fec727da@huawei.com>
 <YtairkXvrX6IZfrR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtairkXvrX6IZfrR@kroah.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 02:25:18PM +0200, Greg KH wrote:
> 
> 95% of the time we take a patch that is not in Linus's tree, it is buggy
> and causes problems in the long run.

So if we really want a 4.19 LTS specific patch, I'd be OK with signing
off on it from an ext4 perspective.... IF AND ONLY IF someone is
willing to tell me that they ran "kvm-xfstests -c ext4/all -g auto" or
the equivalent before and after applying the patch, and is willing to
certify that there are no test regressions.

Helpful links:

  * https://thunk.org/gce-xfstests
  * https://thunk.org/android-xfstests
  * Documentation links from https://github.com/tytso/xfstests-bld
      * https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
      * https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md

(Note that running "-c ext4/all -g auto" will take some 12+ hours if
the tests are run serially, which is why using gce-xfstests's
lightweight test manager to run the file system test configurations in
parallel is a big win.)

> Or better yet, take the effort here and move off of 4.19 to a newer
> kernel without this problem in it.  What is preventing you from doing
> that today?  4.19 is not going to be around for forever, and will
> probably not even be getting fixes for stuff like RETBLEED, so are you
> _SURE_ you want to keep using it?

Or yeah, maybe it's better/cheaper/time for you to move off of 4.19.  :-)

   	       	    	    	       - Ted

P.S.  If we go down this path, Greg K-H may also insist on getting the
bug fix to the 5.4 LTS kernel, so that a bug isn't just fixed in 4.19
LTS but not 5.4 LTS.  In which case, the same requirement of running
"-c ext4/all -g auto" and showing that there are no test regressions
is going to be a requirement for 5.4 LTS as well.
