Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A191556C07E
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbiGHQg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiGHQg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:36:59 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BC4167EF;
        Fri,  8 Jul 2022 09:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657298218; x=1688834218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BknkyAPrm5VBVvoOhYx5ncloGt6kCZ64NEbfyFnrRMU=;
  b=lkHI0LkuzvGWFuzn0HYri2wUjtarL/Fpa77yj8eM/dnBYldtKPeVs1sm
   jVLoENzyqr0R3Ex8aQ+MpswYlsgqs8aMRDPdESTYrvujtllYmWgmYiM2G
   Qll6e+DxC+m39Qt2SuuuNEqemZXazdNEqlFgNwv0sMqIT6RTFqVimxkjN
   g=;
X-IronPort-AV: E=Sophos;i="5.92,256,1650931200"; 
   d="scan'208";a="219528291"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 08 Jul 2022 16:36:45 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id 11CBD4C00A5;
        Fri,  8 Jul 2022 16:36:45 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 8 Jul 2022 16:36:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.50) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 8 Jul 2022 16:36:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <djwong@kernel.org>
CC:     <amir73il@gmail.com>, <ayudutta@amazon.com>, <kkexu@amazon.com>,
        <kuniyu@amazon.com>, <linux-xfs@vger.kernel.org>,
        <lrumancik@google.com>, <pbonzini@redhat.com>,
        <sandeen@redhat.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH stable 5.15] xfs: remove incorrect ASSERT in xfs_rename
Date:   Fri, 8 Jul 2022 09:36:32 -0700
Message-ID: <20220708163632.65870-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YshTjclKanmcBsUW@magnolia>
References: <YshTjclKanmcBsUW@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D20UWA004.ant.amazon.com (10.43.160.62) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From:   "Darrick J. Wong" <djwong@kernel.org>
Date:   Fri, 8 Jul 2022 08:55:57 -0700
> On Fri, Jul 08, 2022 at 08:54:13AM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 07, 2022 at 03:58:35PM -0700, Kuniyuki Iwashima wrote:
> > > From: Eric Sandeen <sandeen@redhat.com>
> > > 
> > > commit e445976537ad139162980bee015b7364e5b64fff upstream.
> > > 
> > > Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
> > > the original commit misses a Fixes tag and was not backported to the stable
> > > tree.  The fix is merged in 5.16, so please backport it to 5.15 first.
> > > 
> > > This ASSERT in xfs_rename is a) incorrect, because
> > > (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> > > b) unnecessary, because actual invalid flag combinations are already
> > > handled at the vfs level in do_renameat2() before we get called.
> > > So, remove it.
> > > 
> > > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
> > > Reported-by: Ayushman Dutta <ayudutta@amazon.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > 
> > Looks good to me, but you really ought to send 5.10 patches to the 5.10
> > XFS maintainer (Amir, now cc'd).  (Yes, this is a recent change.) ;)
> 
> ...and of course the first thing that happens is that I mix up the 5.10
> and 5.15 patches.
> 
> Amir is the 5.10 maintainer, Leah is the 5.15 maintainer.  Sorry about
> the mixup.  /me pours himself a third(!) cup of coffee.

Thank you for taking a look!

And sorry that I'm not familiar with xfs workflow and didn't know each
version has dedicated maintainers.

Is there a doc like Documentation/process/maintainer-netdev.rst as both of
Amir and Leah seem not listed in the xfs entry of MAINTAINERS...?
