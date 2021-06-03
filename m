Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803F039AC20
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCU4o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 3 Jun 2021 16:56:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:25534 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229620AbhFCU4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 16:56:43 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-263-dIA6wV8cOrqlc1RzI2IVVQ-1; Thu, 03 Jun 2021 21:54:53 +0100
X-MC-Unique: dIA6wV8cOrqlc1RzI2IVVQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Thu, 3 Jun 2021 21:54:52 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Thu, 3 Jun 2021 21:54:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Greg KH' <gregkh@linuxfoundation.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
CC:     Daniel Rosenberg <drosen@google.com>, Chao Yu <chao@kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Thread-Topic: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Thread-Index: AQHXWKQQ6htlFlDG3kih+WsZuRk5JqsCwvWQ
Date:   Thu, 3 Jun 2021 20:54:52 +0000
Message-ID: <ed3e4f591c354ec596db4edd148a0892@AcuMS.aculab.com>
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-3-drosen@google.com> <YLipSQxNaUDy9Ff1@kroah.com>
 <YLj36Fmz3dSHmkSG@google.com> <YLkQtDZFG1xKoqE5@kroah.com>
 <YLkXFu4ep8tP3jsh@google.com> <YLkblVt+v68KFXf7@kroah.com>
In-Reply-To: <YLkblVt+v68KFXf7@kroah.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH
> Sent: 03 June 2021 19:13
> 
> On Thu, Jun 03, 2021 at 10:53:26AM -0700, Jaegeuk Kim wrote:
> > On 06/03, Greg KH wrote:
> > > On Thu, Jun 03, 2021 at 08:40:24AM -0700, Jaegeuk Kim wrote:
> > > > On 06/03, Greg KH wrote:
> > > > > On Thu, Jun 03, 2021 at 09:50:38AM +0000, Daniel Rosenberg wrote:
> > > > > > Older kernels don't support encryption with casefolding. This adds
> > > > > > the sysfs entry encrypted_casefold to show support for those combined
> > > > > > features. Support for this feature was originally added by
> > > > > > commit 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> > > > > >
> > > > > > Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> > > > > > Cc: stable@vger.kernel.org # v5.11+
> > > > > > Signed-off-by: Daniel Rosenberg <drosen@google.com>
> > > > > > ---
> > > > > >  fs/f2fs/sysfs.c | 15 +++++++++++++--
> > > > > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
> > > > > > index 09e3f258eb52..6604291a3cdf 100644
> > > > > > --- a/fs/f2fs/sysfs.c
> > > > > > +++ b/fs/f2fs/sysfs.c
> > > > > > @@ -161,6 +161,9 @@ static ssize_t features_show(struct f2fs_attr *a,
> > > > > >  	if (f2fs_sb_has_compression(sbi))
> > > > > >  		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > > > > >  				len ? ", " : "", "compression");
> > > > > > +	if (f2fs_sb_has_casefold(sbi) && f2fs_sb_has_encrypt(sbi))
> > > > > > +		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > > > > > +				len ? ", " : "", "encrypted_casefold");
> > > > > >  	len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > > > > >  				len ? ", " : "", "pin_file");
> > > > > >  	len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
> > > > >
> > > > > This is a HUGE abuse of sysfs and should not be encouraged and added to.
> > > >
> > > > This feature entry was originally added in 2017. Let me try to clean this up
> > > > after merging this.
> > >
> > > Thank you.
> > >
> > > > > Please make these "one value per file" and do not keep growing a single
> > > > > file that has to be parsed otherwise you will break userspace tools.
> > > > >
> > > > > And I don't see a Documentation/ABI/ entry for this either :(
> > > >
> > > > There is in Documentation/ABI/testing/sysfs-fs-f2fs.
> > >
> > > So this new item was documented in the file before the kernel change was
> > > made?
> >
> > Do we need to describe all the strings in this entry?
> >
> > 203 What:           /sys/fs/f2fs/<disk>/features
> > 204 Date:           July 2017
> > 205 Contact:        "Jaegeuk Kim" <jaegeuk@kernel.org>
> > 206 Description:    Shows all enabled features in current device.
> 
> Of course!  Especially as this is a total violation of normal sysfs
> files, how else are you going to parse the thing?
> 
> Why wouldn't you describe the contents?
> 
> But again, please obsolete this file and make the features all
> individual
> files like they should be so that you do not have any parsing problems.

My 2c:

Isn't this a list of fixed strings - rather than a list of values.
So parsing isn't that difficult.
Although it would be more sensible to add new ones at the end.

If they were in separate files you'd need to start reading the
directory to find which names were supported (or known) and then
read the file itself to see if it was actually in use.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

