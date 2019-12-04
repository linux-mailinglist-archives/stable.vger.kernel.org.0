Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270F0112D14
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 14:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfLDN6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 08:58:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfLDN6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 08:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Mime-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1O3RASwSBQtukZSsiULD4Oz8VPMmlubHuY7PxIAb5yg=; b=DQlqMhee5t6rs7/yLDNfMIzRx
        2PC5TdPG/McP0TnA7ja0ZmSD6npxQ7/Vxl60N407jJm82Ly/lFfjczxz27RjppptRB12qVMYbnyve
        cywGhi/oMKg6zgHUAgzo1886oi0C3ZlEjc1+4B42dFffXprOj++Ht0NIaM87lzg63sxti+ekXbhlj
        MQ1efmvUdK2e8xxFbXIWeNd2ebuUcvF1kXF49ZrubBVX9V2M3y5C5FbOATt/OPJ1MJnAIjqQgyOWb
        cR25AeTiCXfoOE6gWsgV+6gM1ko7oplDCjzaX/nhfDq6UVFWTsPgfhcjmhhR7q2oqWQImqnrMHTCI
        e4c+pIbOw==;
Received: from [54.239.6.185] (helo=u0c626add9cce5a.drs10.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1icVB8-0001fV-4J; Wed, 04 Dec 2019 13:58:54 +0000
Message-ID: <108357faa8d7add057a8dc0870b42c482eec34ee.camel@infradead.org>
Subject: Re: [PATCH v3] virtio_console: allocate inbufs in add_port() only
 if it is needed
From:   Amit Shah <amit@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Date:   Wed, 04 Dec 2019 14:58:51 +0100
In-Reply-To: <20191203103840-mutt-send-email-mst@kernel.org>
References: <20191114122548.24364-1-lvivier@redhat.com>
         <ae3451423c18f2e408245d745d1f28e311a2845c.camel@infradead.org>
         <20191203103840-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-12-03 at 10:42 -0500, Michael S. Tsirkin wrote:
> On Tue, Dec 03, 2019 at 03:46:50PM +0100, Amit Shah wrote:
> > On Thu, 2019-11-14 at 13:25 +0100, Laurent Vivier wrote:
> > > When we hot unplug a virtserialport and then try to hot plug
> > > again,
> > > it fails:
> > > 
> > > (qemu) chardev-add
> > > socket,id=serial0,path=/tmp/serial0,server,nowait
> > > (qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
> > >                   chardev=serial0,id=serial0,name=serial0
> > > (qemu) device_del serial0
> > > (qemu) device_add virtserialport,bus=virtio-serial0.0,nr=2,\
> > >                   chardev=serial0,id=serial0,name=serial0
> > > kernel error:
> > >   virtio-ports vport2p2: Error allocating inbufs
> > > qemu error:
> > >   virtio-serial-bus: Guest failure in adding port 2 for device \
> > >                      virtio-serial0.0
> > > 
> > > This happens because buffers for the in_vq are allocated when the
> > > port is
> > > added but are not released when the port is unplugged.
> > > 
> > > They are only released when virtconsole is removed (see
> > > a7a69ec0d8e4)
> > > 
> > > To avoid the problem and to be symmetric, we could allocate all
> > > the
> > > buffers
> > > in init_vqs() as they are released in remove_vqs(), but it sounds
> > > like
> > > a waste of memory.
> > > 
> > > Rather than that, this patch changes add_port() logic to ignore
> > > ENOSPC
> > > error in fill_queue(), which means queue has already been filled.
> > > 
> > > Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
> > > Cc: mst@redhat.com
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> > 
> > Reviewed-by: Amit Shah <amit@kernel.org>
> > 
> > Thanks!
> 
> 
> Thanks, however this has already been merged by Linus.
> I can't add the tag retroactively, sorry about that.

Right, no problem - but I wanted to ensure it's on-list :)

> 
> For bugfix patches like that, I think we can reasonably
> target a turn around of a couple of days, these
> shouldn't really need to wait weeks for review.

Sure, thanks for picking it up fast enough.  Life happens, etc., and
it's not always possible to reply in a couple of days.  Since we had
already covered the main comments in v1 and v2, v3 wasn't going to need
much attention anyway.


