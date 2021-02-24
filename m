Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15D3324353
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 18:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhBXRsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 12:48:41 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:59955 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbhBXRsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 12:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614188919; x=1645724919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=9vMc5IDtWIWHzA5qb6nps20KNvfTWHSoLjMmqyQPdcE=;
  b=dNcY+iahmNNJqSRSzHp/TufCYAFF0lUliLfUJQIY21AXSqc6JxVW2nhz
   bEhLKedVlyjKbt4fBNVnqp0PP6aWgf2mUyEcPRVOatc6Yr6vIRblnprU6
   KqN2mzRbWvW8C/477Lk4FUwcwNreICQIdKfUxDFGfliJesPsNQQH0Ojv/
   o=;
X-IronPort-AV: E=Sophos;i="5.81,203,1610409600"; 
   d="scan'208";a="87725213"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Feb 2021 17:47:52 +0000
Received: from EX13D31EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 6FE2FA1B7C;
        Wed, 24 Feb 2021 17:47:50 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.160.207) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 17:47:45 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <sashal@kernel.org>,
        <aams@amazon.com>, <markubo@amazon.com>,
        <linux-kernel@vger.kernel.org>,
        "# 4 . 4 . y" <stable@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: Please apply "xen-netback: delete NAPI instance when queue fails to initialize" to v4.4.y
Date:   Wed, 24 Feb 2021 18:47:32 +0100
Message-ID: <20210224174732.30014-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <YDaLBcj5DJrSWXqU@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.207]
X-ClientProxiedBy: EX13D41UWB002.ant.amazon.com (10.43.161.109) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Feb 2021 18:21:09 +0100 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, Feb 24, 2021 at 06:03:56PM +0100, SeongJae Park wrote:
> > This is a request for merge of upstream commit 4a658527271b ("xen-netback:
> > delete NAPI instance when queue fails to initialize") on v4.4.y tree.
> > 
> > If 'xenvif_connect()' fails after successful 'netif_napi_add()', the napi is
> > not cleaned up.  Because 'create_queues()' frees the queues in its error
> > handling code, if the 'xenvif_free()' is called for the vif, use-after-free
> > occurs. The upstream commit fixes the problem by cleaning up the napi in the
> > 'xenvif_connect()'.
> > 
> > Attaching the original patch below for your convenience.
> 
> The original patch does not apply cleanly.

I tested the commit is cleanly applicable with 'git cherry-pick' before posting
this.  I just tried 'git format-patch ... && git am ...' and confirmed it
doesn't work.  Sorry, my fault.

> 
> > Tested-by: Markus Boehme <markubo@amazon.de>
> 
> What was tested?

We confirmed the unmodified v4.4.y kernel crashes on a stress test that
repeatedly doing netdev attach/detach, while the patch applied version doesn't.

> 
> I backported the patch, but next time, please provide the patch that
> will work properly.

Thanks, and apology for the inconvenience.  I will do the check with posting
patch again rather than only 'git cherry-pick' from next time.


Thanks,
SeongJae Park

> 
> greg k-h
