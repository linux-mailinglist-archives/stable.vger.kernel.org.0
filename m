Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E10268E623
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 03:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjBHCkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 21:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjBHCkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 21:40:09 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB79042DEA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 18:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675824008; x=1707360008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PjWRrm2LJtOm8PvLNduPpn+Q1l4tJ8mCU1PPR66XryE=;
  b=hHv6Kiy7YVDjUx2wx4cACF+JK6SmJD1YDJ9X/4xD5lfLDJ6ElbUOCU9r
   +jvSWlrxTyMNnU7v8m6H+Bk9MKo7hRdpKJVLDY21CPEUIkp7lfYw1lWBf
   U5mwJ7XHghT331WX9wYNr4MtnfeJI/+Oy1cWNQSPdZAQfyLTMAOA5MUUl
   w=;
X-IronPort-AV: E=Sophos;i="5.97,279,1669075200"; 
   d="scan'208";a="179521674"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 02:40:07 +0000
Received: from EX13MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id 7622A4359E;
        Wed,  8 Feb 2023 02:40:04 +0000 (UTC)
Received: from EX19D043UWA003.ant.amazon.com (10.13.139.31) by
 EX13MTAUWA002.ant.amazon.com (10.43.160.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 8 Feb 2023 02:40:03 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D043UWA003.ant.amazon.com (10.13.139.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Wed, 8 Feb 2023 02:40:03 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.189.91.91)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.45 via Frontend Transport; Wed, 8 Feb 2023 02:40:03 +0000
Received: by dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (Postfix, from userid 13116433)
        id 545F82236D; Wed,  8 Feb 2023 02:40:02 +0000 (UTC)
Date:   Wed, 8 Feb 2023 02:40:02 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     David Ahern <dsahern@kernel.org>, <gregkh@linuxfoundation.org>
CC:     <idosch@nvidia.com>, <kuba@kernel.org>, <patches@lists.linux.dev>,
        <sashal@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 v2 2/2] ipv4: Fix incorrect route flushing when
 source address is deleted
Message-ID: <20230208024002.GA20289@dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com>
References: <Y+IckeUtbE/UfOz/@kroah.com>
 <20230207182820.4959-1-shaoyi@amazon.com>
 <20230207182820.4959-2-shaoyi@amazon.com>
 <9d90e05b-c9cb-03d2-645a-b50b1cae694d@kernel.org>
 <98459a1b-eb42-afe3-9795-70c45292add9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <98459a1b-eb42-afe3-9795-70c45292add9@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 07:23:41PM -0700, David Ahern wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 2/7/23 7:22 PM, David Ahern wrote:
> > On 2/7/23 11:28 AM, Shaoying Xu wrote:
> >> From: Ido Schimmel <idosch@nvidia.com>
> >>
> >> [ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]
> >>
> >
> > That commit, does not have this change:
> >
> 
> nevermind. I was looking at the other commit with that Fixes tag.
> 
> 
> You did drop the selftests associated with the commit.
> 
Yes because ipv4_del_addr test does not exist in fib_tests.sh of kernel 5.4 
and similar drop in the commit ("ipv4: Fix incorrect route flushing when
table ID 0 is used") [1].

[1] https://lore.kernel.org/stable/20221212130920.527377379@linuxfoundation.org/
