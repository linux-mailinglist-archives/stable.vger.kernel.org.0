Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C6757A146
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbiGSOXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 10:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbiGSOW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 10:22:59 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980FB48C94;
        Tue, 19 Jul 2022 07:06:32 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26JE64Hc032665
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 10:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1658239567; bh=pFRhtD0UYXegEYar/cYUoYiQFDVavLLZf/TJ5SxzjKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=pyGsb0Tfd4JJA+w/5eG0B95/9hfD4SG6u4KsBEoSxCrMF0ybcPQrYIlylp7JLQlYv
         nP09zeoD07k7y4ujU+gT4zDxYrZV1IKtksbIsKMLv4J4tU5fabUfLQ8sU0BVlYw/sV
         O1sUlDX3YQkCcrRw/3ijBTgaZJSMRemagBBWv+6WE+iSYQwAs1/96nmr6V6Fk/wT2t
         XAZ5g7SaN+/h5WNxMFrzGebpflAFrD1nkxO7ghfHUQpp74Nw6TFtpJ4tXaPIHjCkxH
         LSRSYPAoou8dJ1SqJOSiVyLm3/PWASj7OxHp/CqegeG3nlc93wQHxAuSz13m3GXF5o
         CiaLe4ypKE2mw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7BEB815C00E4; Tue, 19 Jul 2022 10:06:04 -0400 (EDT)
Date:   Tue, 19 Jul 2022 10:06:04 -0400
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
Message-ID: <Yta6THyDwHulhfi5@mit.edu>
References: <20220715023928.2701166-1-libaokun1@huawei.com>
 <YtF1XygwvIo2Dwae@kroah.com>
 <425ab528-7d9a-975a-7f4c-5f903cedd8bc@huawei.com>
 <YtaVAWMlxrQNcS34@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtaVAWMlxrQNcS34@kroah.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:26:57PM +0200, Greg KH wrote:
> On Sat, Jul 16, 2022 at 10:33:30AM +0800, Baokun Li wrote:
> > This problem persists until the patch d3b6f23f7167("ext4: move ext4_fiemap
> > to use iomap framework") is incorporated in v5.7-rc1.
> 
> Then why not ask for that change to be added instead?

Switching over to use the iomap framework is a quite invasive change,
which is fraught with danager and potential performance regressions.
So it's really not something that would be considered safe for an LTS
kernel.

As an upstream developer I'd ask why are people trying to use a kernel
as old as 4.19, but RHEL has done more insane things than that.  Also,
I know what the answer is, and it's just too depressing for a nice
summer day like this.  :-)

       	  	    	     	       - Ted
