Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B6263CC81
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 01:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiK3AeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 19:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiK3AeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 19:34:12 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BC827925;
        Tue, 29 Nov 2022 16:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669768453; x=1701304453;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SdWegCh9WoUemvDgOqiphOFPN3rRgc2laV4ucMMVz1Q=;
  b=gGvES0l1QwmQM3g/KBVXaWHJy6TM7cQ8VAOVbps02UQOal3x9h89qDHQ
   D+h6JvbFqW/KcMiiKvn0YnFJ3Pu9REclLSyx8CYEu9I8Dm19IPs9VCnG9
   WxJLLId1hkD9z4gDecwC8G0Xo2xt+9jch7iRcTtGL0yn+i8/NQ3+vDId0
   w=;
X-IronPort-AV: E=Sophos;i="5.96,204,1665446400"; 
   d="scan'208";a="156184454"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 00:34:11 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id 10B13A2E16;
        Wed, 30 Nov 2022 00:34:05 +0000 (UTC)
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 30 Nov 2022 00:34:05 +0000
Received: from localhost (10.43.160.223) by EX19D001UWA002.ant.amazon.com
 (10.13.138.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20; Wed, 30 Nov 2022
 00:34:04 +0000
Date:   Tue, 29 Nov 2022 16:34:02 -0800
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Shakeel Butt <shakeelb@google.com>,
        Michele Jr De Candia <mdecandia@gmail.com>,
        <akpm@linux-foundation.org>, <bsegall@google.com>,
        <edumazet@google.com>, <jbaron@akamai.com>, <khazhy@google.com>,
        <linux-kernel@vger.kernel.org>, <r@hev.cc>, <rpenyaev@suse.de>,
        <stable@kernel.org>, <stable@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <benh@amazon.com>, <risbhat@amazon.com>
Subject: Re: [PATCH 5.4 051/389] epoll: autoremove wakers even more
 aggressively
Message-ID: <20221130003402.hu3l4hehge5xqgen@u46989501580c5c.ant.amazon.com>
References: <20220823080117.738248512@linuxfoundation.org>
 <20221026160051.5340-1-mdecandia@gmail.com>
 <Y1ljluiq8Ojp4vdL@kroah.com>
 <CAAPDZK9Oz2Hs9wofW9820gM=SeWgycCEWN=Xsjmy-YY_iFBcfQ@mail.gmail.com>
 <CALvZod5My-JaXBSm1iuVSFMiarB2YuE=O0AxD=6ZG0BfmJZ1AQ@mail.gmail.com>
 <Y1pY2n6E1Xa58MXv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y1pY2n6E1Xa58MXv@kroah.com>
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D32UWB002.ant.amazon.com (10.43.161.139) To
 EX19D001UWA002.ant.amazon.com (10.13.138.236)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 12:09:30PM +0200, Greg KH wrote:
> On Wed, Oct 26, 2022 at 11:48:01AM -0700, Shakeel Butt wrote:
> > On Wed, Oct 26, 2022 at 11:44 AM Michele Jr De Candia
> > <mdecandia@gmail.com> wrote:
> > >
> > > Hi Greg,
> > > sorry for the confusion.
> > >
> > > I'm running a container-based app on top of Ubuntu Linux 20.04 and linux kernel 5.4 always updated with latest patches.
> > >
> > > Updating from 5.4.210 to 5.4.211 we faced the hang up issue and searching for the cause we have tested that
> > > hangup occurs only with this patch
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=cf2db24ec4b8e9d399005ececd6f6336916ab6fc
> > >
> > > While understanding root cause, wt the moment we reverted it and hang up does not occurs (actually we are running 5.4.219 without that patch).
> > >
> > > Michele
> > >
> > 
> > Hi Michele, can you try the latest upstream kernel and see if the
> > issue repro ther? Also is it possible to provide a simplified repro of
> > the issue?
> 
> Also is this issue on 5.10.y and 5.15.y?
> 
> thanks,
> 
> greg k-h

Following up this email thread for those of us who were watching it; it
looks like this was only an issue on 5.4.y due to some missing
backports that this change depended on - see this thread for details:
https://lore.kernel.org/lkml/Y38h9oe4ZEGNd7Zx@quatroqueijos.cascardo.eti.br/T/

Cheers,
Sam
