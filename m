Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF76D1FBC77
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 19:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbgFPRLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 13:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730125AbgFPRLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 13:11:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F1D720B1F;
        Tue, 16 Jun 2020 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592327474;
        bh=F3Z7ZE9ciwRV9Oco1l7sAqIS7v5q6e0MfPYwzEMo3oA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AQuWzJsxKgUuhQ/SRB2PZTHlF0nzNvYpQB8XpTvKbePZRm7KW9ISv3Mveuy03LCDV
         n1gJY2bwLucKXXAydX3WGBQgp1UqvppOfTMW8HN3qa8iU5SsJg6OvTLbPDs+rqFIii
         KC1nNTMP7Z9r9c3zQXfU4rZE3FsD2nJRR+KAvXeE=
Date:   Tue, 16 Jun 2020 19:11:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.6 041/161] kobject: Make sure the parent does not get
 released before its children
Message-ID: <20200616171107.GA4161772@kroah.com>
References: <20200616153106.402291280@linuxfoundation.org>
 <20200616153108.333633206@linuxfoundation.org>
 <CAJZ5v0hgw3atK4F705KDMjX8PAPbP1Hz8G+GXj8=UaMZizNHwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hgw3atK4F705KDMjX8PAPbP1Hz8G+GXj8=UaMZizNHwQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 07:05:44PM +0200, Rafael J. Wysocki wrote:
> On Tue, Jun 16, 2020 at 5:50 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >
> > [ Upstream commit 4ef12f7198023c09ad6d25b652bd8748c965c7fa ]
> >
> > In the function kobject_cleanup(), kobject_del(kobj) is
> > called before the kobj->release(). That makes it possible to
> > release the parent of the kobject before the kobject itself.
> >
> > To fix that, adding function __kboject_del() that does
> > everything that kobject_del() does except release the parent
> > reference. kobject_cleanup() then calls __kobject_del()
> > instead of kobject_del(), and separately decrements the
> > reference count of the parent kobject after kobj->release()
> > has been called.
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > Fixes: 7589238a8cf3 ("Revert "software node: Simplify software_node_release() function"")
> > Suggested-by: "Rafael J. Wysocki" <rafael@kernel.org>
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
> > Tested-by: Brendan Higgins <brendanhiggins@google.com>
> > Acked-by: Randy Dunlap <rdunlap@infradead.org>
> > Link: https://lore.kernel.org/r/20200513151840.36400-1-heikki.krogerus@linux.intel.com
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  lib/kobject.c | 30 ++++++++++++++++++++----------
> >  1 file changed, 20 insertions(+), 10 deletions(-)
> >
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index 83198cb37d8d..2bd631460e18 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -599,14 +599,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
> >  }
> >  EXPORT_SYMBOL_GPL(kobject_move);
> >
> > -/**
> > - * kobject_del() - Unlink kobject from hierarchy.
> > - * @kobj: object.
> > - *
> > - * This is the function that should be called to delete an object
> > - * successfully added via kobject_add().
> > - */
> > -void kobject_del(struct kobject *kobj)
> > +static void __kobject_del(struct kobject *kobj)
> >  {
> >         struct kernfs_node *sd;
> >         const struct kobj_type *ktype;
> > @@ -625,9 +618,23 @@ void kobject_del(struct kobject *kobj)
> >
> >         kobj->state_in_sysfs = 0;
> >         kobj_kset_leave(kobj);
> > -       kobject_put(kobj->parent);
> >         kobj->parent = NULL;
> >  }
> > +
> > +/**
> > + * kobject_del() - Unlink kobject from hierarchy.
> > + * @kobj: object.
> > + *
> > + * This is the function that should be called to delete an object
> > + * successfully added via kobject_add().
> > + */
> > +void kobject_del(struct kobject *kobj)
> > +{
> > +       struct kobject *parent = kobj->parent;
> > +
> > +       __kobject_del(kobj);
> > +       kobject_put(parent);
> > +}
> >  EXPORT_SYMBOL(kobject_del);
> >
> >  /**
> > @@ -663,6 +670,7 @@ EXPORT_SYMBOL(kobject_get_unless_zero);
> >   */
> >  static void kobject_cleanup(struct kobject *kobj)
> >  {
> > +       struct kobject *parent = kobj->parent;
> >         struct kobj_type *t = get_ktype(kobj);
> >         const char *name = kobj->name;
> >
> > @@ -684,7 +692,7 @@ static void kobject_cleanup(struct kobject *kobj)
> >         if (kobj->state_in_sysfs) {
> >                 pr_debug("kobject: '%s' (%p): auto cleanup kobject_del\n",
> >                          kobject_name(kobj), kobj);
> > -               kobject_del(kobj);
> > +               __kobject_del(kobj);
> >         }
> >
> >         if (t && t->release) {
> > @@ -698,6 +706,8 @@ static void kobject_cleanup(struct kobject *kobj)
> >                 pr_debug("kobject: '%s': free name\n", name);
> >                 kfree_const(name);
> >         }
> > +
> > +       kobject_put(parent);
> 
> This is known incorrect, because that should only be done if the
> __kobject_del() above has run.
> 
> Also this commit has been reverted from the mainline.

Argh, I should have caught this, my fault, sorry, I'll go drop it.

> I have posted a fixed replacement for it with no response whatever so far:
> 
> https://lore.kernel.org/lkml/1908555.IiAGLGrh1Z@kreacher/

It's been the merge window, I couldn't do anything until Monday :)

It's in my queue, give me a chance to catch up...

thanks,

greg k-h
