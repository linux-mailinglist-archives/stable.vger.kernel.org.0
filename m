Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2312750C9DF
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 14:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbiDWM1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 08:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiDWM1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 08:27:01 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE36B183FBD
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 05:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1650716643; x=1682252643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+yiU7Oq1XcIX54gF42T1ANlNkoyazWVXh7pWiySAw9o=;
  b=PBWsjRZiY6hxH6ydthZMm1Mlw0AT7/tC6WzbZRgHfbPcb1ICYqz3Fphe
   q2LOL+9lWbigb+DMaaCzs+ZYq4NOPW+6SNyLxs5AHauuR5Hk4ugZAGppm
   R9XBVoMeJKuRc5aUKgoSqm+ipMj1o+dnzfJLnczYP5+pA0xqb8Ht/HB03
   4=;
X-IronPort-AV: E=Sophos;i="5.90,284,1643673600"; 
   d="scan'208";a="197082672"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-0168675e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 23 Apr 2022 12:24:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0168675e.us-east-1.amazon.com (Postfix) with ESMTPS id E0E89A27A5;
        Sat, 23 Apr 2022 12:24:00 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Sat, 23 Apr 2022 12:24:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.156) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Sat, 23 Apr 2022 12:23:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <gregkh@linuxfoundation.org>
CC:     <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>, <sashal@kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: Request to cherry-pick c89dffc70b34 to 4.14, 4.19, and 5.4.
Date:   Sat, 23 Apr 2022 21:23:54 +0900
Message-ID: <20220423122354.56795-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YmPcYGUsZef6OQX0@kroah.com>
References: <YmPcYGUsZef6OQX0@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D19UWC001.ant.amazon.com (10.43.162.64) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sat, 23 Apr 2022 13:00:48 +0200
> On Sat, Apr 23, 2022 at 10:58:19AM +0200, Greg Kroah-Hartman wrote:
> > On Sat, Apr 23, 2022 at 10:07:06AM +0900, Kuniyuki Iwashima wrote:
> > > Hi maintainers,
> > > 
> > > Upstream commit 01770a166165 ("tcp: fix race condition when creating child
> > > sockets from syncookies") is planned to be backported to 4.14, 4.19 and
> > > 5.4:
> > > 
> > >   https://marc.info/?l=linux-stable-commits&m=165063781908608&w=3
> > >   https://marc.info/?l=linux-stable-commits&m=165063781708604&w=3
> > >   https://marc.info/?l=linux-stable-commits&m=165063781708603&w=3
> > > 
> > > Another commit c89dffc70b34 ("tcp: Fix potential use-after-free due to
> > > double kfree()") has a Fixes tag for it, so please backport this also.
> > 
> > Ick, that commit does not apply cleanly.  The people who wanted
> > 01770a166165 should also provide a working version of this fix as well.
> 
> Oh nevermind, I didn't have my queue up to date.  It worked just fine,
> sorry for the noise.

Thanks for queuing up!

Next time I'll send a mail with a backportable-patch, not just commit id :)
