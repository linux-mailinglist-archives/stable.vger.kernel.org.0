Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38936118E3
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 19:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJ1RI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 13:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiJ1RIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 13:08:12 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8948B234792
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 10:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666976773; x=1698512773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GVbpre3DLWQF9M/QQf+58FpujWq7O3tpeqmA1RriO/M=;
  b=o6V+FhvDphMbPe5PHusaWSGIhzVVny5JHn62B9E2QYd9c8ePSzWyc9r8
   dOnZ2lhBB/c8CvNRH0s17BbTSWm/j3bMv91AHmh+a43Hj4eywGjfEoxcz
   M6lufGFgO8h4Q5ScjfE1vJNvjlg0/RD/FYYTAe3nRBTLsU9B1Mau4Wl+q
   A=;
X-IronPort-AV: E=Sophos;i="5.95,221,1661817600"; 
   d="scan'208";a="274711127"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 17:06:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com (Postfix) with ESMTPS id 1A96841849;
        Fri, 28 Oct 2022 17:06:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 28 Oct 2022 17:06:03 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 28 Oct 2022 17:06:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <daniel@iogearbox.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuniyu@amazon.co.jp>, <kuniyu@amazon.com>, <pabeni@redhat.com>,
        <patches@lists.linux.dev>, <sashal@kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct sock_reuseport.
Date:   Fri, 28 Oct 2022 10:05:52 -0700
Message-ID: <20221028170552.59120-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Y1t0Br1mqkhqYP8U@kroah.com>
References: <Y1t0Br1mqkhqYP8U@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D12UWC001.ant.amazon.com (10.43.162.78) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From:   Greg KH <gregkh@linuxfoundation.org>
Date:   Fri, 28 Oct 2022 08:17:42 +0200
> On Thu, Oct 27, 2022 at 12:53:49PM -0700, Kuniyuki Iwashima wrote:
> > Hi Greg, Sasha,
> > 
> > From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Date:   Thu, 27 Oct 2022 18:55:45 +0200
> > > From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > 
> > > [ Upstream commit 5c040eaf5d1753aafe12989ca712175df0b9c436 ]
> > > 
> > > As noted in the following commit, a closed listener has to hold the
> > > reference to the reuseport group for socket migration. This patch adds a
> > > field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> > > within the same reuseport group. Moreover, this and the following commits
> > > introduce some helper functions to split socks[] into two sections and keep
> > > TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> > > queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> > > sockets from the end.
> > > 
> > >   TCP_LISTEN---------->       <-------TCP_CLOSE
> > >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > >   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
> > >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > > 
> > >   i = num_socks - 1
> > >   j = max_socks - num_closed_socks
> > >   k = max_socks - 1
> > > 
> > > This patch also extends reuseport_add_sock() and reuseport_grow() to
> > > support num_closed_socks.
> > > 
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > > Link: https://lore.kernel.org/bpf/20210612123224.12525-3-kuniyu@amazon.co.jp
> > > Stable-dep-of: 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > I think this patch is backported due to a conflict with the cited commit
> > 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.").
> > 
> > The following patch seems to conflicts with some functions which are
> > introduced in this patch, but the cited commit does not depend on the
> > functions.
> > 
> > So, we can just remove the functions in this patch and resolve the
> > conflict in the next patch like below. (based on the v5.10.150 branch)
> 
> so drop this "dependent" patch and just take your backport instead?

Yes, my backport patch replaces these patches in this series.

  [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct sock_reuseport
  [PATCH 5.10 36/79] udp: Update reuse->has_conns under reuseport_lock
