Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869F156C0D0
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbiGHRFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 13:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiGHRFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 13:05:16 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3706050E;
        Fri,  8 Jul 2022 10:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657299912; x=1688835912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ocLp2g7HvWeV/+zNIJuX9Ttd/BemGYzF52YFR+8iCz0=;
  b=Retikdnw2ykVBIdBOM4g6nhOUchM8Xwc9zifdc2mJUQVyu4EP+o40PWk
   MQigecLpFR8jsPFmiuEdJBa5QvMCsaj9BBv7zOl2EW4Yvi7qslvjoqSvS
   Q+D8p467T1shWkxYmPC3ZnvLqT8LAhcYXZQwVoWdIoqMMAMMq480aeuT2
   k=;
X-IronPort-AV: E=Sophos;i="5.92,256,1650931200"; 
   d="scan'208";a="106314054"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 08 Jul 2022 17:04:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id 9A42C8100F;
        Fri,  8 Jul 2022 17:04:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 8 Jul 2022 17:04:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 8 Jul 2022 17:04:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <djwong@kernel.org>
CC:     <amir73il@gmail.com>, <ayudutta@amazon.com>, <kkexu@amazon.com>,
        <kuniyu@amazon.com>, <linux-xfs@vger.kernel.org>,
        <lrumancik@google.com>, <pbonzini@redhat.com>,
        <sandeen@redhat.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH stable 5.15] xfs: remove incorrect ASSERT in xfs_rename
Date:   Fri, 8 Jul 2022 10:04:40 -0700
Message-ID: <20220708170440.67583-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YshgrEyqzF+rbi0c@magnolia>
References: <YshgrEyqzF+rbi0c@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From:   "Darrick J. Wong" <djwong@kernel.org>
Date:   Fri, 8 Jul 2022 09:51:56 -0700
> On Fri, Jul 08, 2022 at 09:36:32AM -0700, Kuniyuki Iwashima wrote:
> > From:   "Darrick J. Wong" <djwong@kernel.org>
> > Date:   Fri, 8 Jul 2022 08:55:57 -0700
> > > On Fri, Jul 08, 2022 at 08:54:13AM -0700, Darrick J. Wong wrote:
> > > > On Thu, Jul 07, 2022 at 03:58:35PM -0700, Kuniyuki Iwashima wrote:
> > > > > From: Eric Sandeen <sandeen@redhat.com>
> > > > > 
> > > > > commit e445976537ad139162980bee015b7364e5b64fff upstream.
> > > > > 
> > > > > Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
> > > > > the original commit misses a Fixes tag and was not backported to the stable
> > > > > tree.  The fix is merged in 5.16, so please backport it to 5.15 first.
> > > > > 
> > > > > This ASSERT in xfs_rename is a) incorrect, because
> > > > > (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> > > > > b) unnecessary, because actual invalid flag combinations are already
> > > > > handled at the vfs level in do_renameat2() before we get called.
> > > > > So, remove it.
> > > > > 
> > > > > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
> > > > > Reported-by: Ayushman Dutta <ayudutta@amazon.com>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > 
> > > > Looks good to me, but you really ought to send 5.10 patches to the 5.10
> > > > XFS maintainer (Amir, now cc'd).  (Yes, this is a recent change.) ;)
> > > 
> > > ...and of course the first thing that happens is that I mix up the 5.10
> > > and 5.15 patches.
> > > 
> > > Amir is the 5.10 maintainer, Leah is the 5.15 maintainer.  Sorry about
> > > the mixup.  /me pours himself a third(!) cup of coffee.
> > 
> > Thank you for taking a look!
> > 
> > And sorry that I'm not familiar with xfs workflow and didn't know each
> > version has dedicated maintainers.
> 
> It's a recent change, because I wasn't keeping up with tending to six
> LTS trees /and/ upstream /and/ feature development.

It must have been really hard, that makes sense.


> > Is there a doc like Documentation/process/maintainer-netdev.rst as both of
> > Amir and Leah seem not listed in the xfs entry of MAINTAINERS...?
> 
> They're listed in MAINTAINERS in the 5.10 and 5.15 trees, respectively.
> That's also a very recent change (within the last week, I think).

Ah, I got it.  I'm sorry it was because I used the latest get_maintainer.pl
only.  I'll check each branch's MAINTAINERS next time.

Thank you!
