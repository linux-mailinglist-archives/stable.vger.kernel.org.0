Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391432DD401
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 16:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgLQPUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 10:20:44 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:54354 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbgLQPUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 10:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608218443; x=1639754443;
  h=from:to:cc:subject:date:message-id:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=VOFDcpN/HdhneyE9MEhTVbZj3lArp/QwANe0Gz7bY0U=;
  b=sWjci4LvY/lZ72Bv1bsiLD7Yvyqzrj1AozE3C6tKAnokv1pOTINeaCmF
   cZKVltnNkgoS83WH0CrwOXvFOnAT7Ah9Am3HFZO+1MOkIHBjVX+c42Aub
   PMJxoo6vKfMZRahL8xry6aWirlOOCkSlIz78C3Qw+jiKYpenl91j6GjSL
   g=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="103910716"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 17 Dec 2020 15:19:55 +0000
Received: from EX13D31EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 620CFA06B0;
        Thu, 17 Dec 2020 15:19:54 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.211) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 15:19:49 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     =?UTF-8?q?J=C3=BCrgen=20Gro=C3=9F?= <jgross@suse.com>
CC:     SeongJae Park <sjpark@amazon.com>, <stable@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <julien@xen.org>,
        <wipawel@amazon.de>, <linux-kernel@vger.kernel.org>,
        "Author Redacted" <security@xen.org>
Subject: Re: [PATCH 4/5] xen/xenbus: Count pending messages for each watch
Date:   Thu, 17 Dec 2020 16:19:31 +0100
Message-ID: <20201217151931.8078-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
In-Reply-To: <76711b5d-4166-19ff-e817-694675051f90@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.211]
X-ClientProxiedBy: EX13D27UWB001.ant.amazon.com (10.43.161.169) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Dec 2020 15:50:34 +0100 "Jürgen Groß" <jgross@suse.com> wrote:

> [-- Attachment #1.1.1: Type: text/plain, Size: 3509 bytes --]
> 
> On 17.12.20 09:17, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > This commit adds a counter of pending messages for each watch in the
> > struct.  It is used to skip unnecessary pending messages lookup in
> > 'unregister_xenbus_watch()'.  It could also be used in 'will_handle'
> > callback.
> > 
> > This is part of XSA-349
> > 
> > This is upstream commit 3dc86ca6b4c8cfcba9da7996189d1b5a358a94fc
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > Reported-by: Michael Kurth <mku@amazon.de>
> > Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
> > Signed-off-by: Author Redacted <security@xen.org>
> > Reviewed-by: Juergen Gross <jgross@suse.com>
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> > ---
> >   drivers/xen/xenbus/xenbus_xs.c | 30 ++++++++++++++++++------------
> >   include/xen/xenbus.h           |  2 ++
> >   2 files changed, 20 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> > index 0ea1c259f2f1..420d478e1708 100644
> > --- a/drivers/xen/xenbus/xenbus_xs.c
> > +++ b/drivers/xen/xenbus/xenbus_xs.c
> > @@ -701,6 +701,8 @@ int register_xenbus_watch(struct xenbus_watch *watch)
> >   
> >   	sprintf(token, "%lX", (long)watch);
> >   
> > +	watch->nr_pending = 0;
> > +
> 
> I'm missing the incrementing of nr_pending, which was present in the
> upstream patch.

Oops, it should be in this patch, but I mistakenly put it in the fifth patch.

  67 --- a/drivers/xen/xenbus/xenbus_xs.c
  68 +++ b/drivers/xen/xenbus/xenbus_xs.c
  69 @@ -917,6 +917,7 @@ static int process_msg(void)
  70                                          msg->u.watch.vec_size))) {
  71                         spin_lock(&watch_events_lock);
  72                         list_add_tail(&msg->list, &watch_events);
  73 +                       msg->u.watch.handle->nr_pending++;
  74                         wake_up(&watch_events_waitq);
  75                         spin_unlock(&watch_events_lock);
  76                 } else {
  77 --

And I just realized I even didn't post the fifth patch.

I will fix this and post new version (v3) soon.

Thank you for catching this, Juergen.


Thanks,
SeongJae Park
