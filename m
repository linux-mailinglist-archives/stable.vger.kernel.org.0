Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F263BAAD5
	for <lists+stable@lfdr.de>; Sun,  4 Jul 2021 03:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhGDBhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 21:37:47 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:14463 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhGDBhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 21:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1625362512; x=1656898512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d12ngtaNL85OjZKjEac9shxBSZoy7AyPEUt7niWW5MI=;
  b=FKva5AIhuWcYtn4ekyiB+Chv6Os6HpJsx+vqjGnGjcC2Y3dyC4ki9S/S
   vWrXcNcg1r737SIZO31IurrNVlGjXEBkQG5hnkvIBPTLH4UjIfgfDKKKv
   AfloShb0EMDH2NJ356CUrWlf3iPe/oSGy8UK9i2awh8/IBV9uNf6pj+sn
   s=;
X-IronPort-AV: E=Sophos;i="5.83,323,1616457600"; 
   d="scan'208";a="118498715"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 04 Jul 2021 01:35:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 8D303A2555;
        Sun,  4 Jul 2021 01:35:10 +0000 (UTC)
Received: from EX13D19UWC004.ant.amazon.com (10.43.162.56) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sun, 4 Jul 2021 01:35:09 +0000
Received: from EX13D19UWC001.ant.amazon.com (10.43.162.64) by
 EX13D19UWC004.ant.amazon.com (10.43.162.56) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sun, 4 Jul 2021 01:35:09 +0000
Received: from EX13D19UWC001.ant.amazon.com ([10.43.162.64]) by
 EX13D19UWC001.ant.amazon.com ([10.43.162.64]) with mapi id 15.00.1497.018;
 Sun, 4 Jul 2021 01:35:09 +0000
From:   "Erdogan, Tahsin" <trdgn@amazon.com>
To:     Theodore Ts'o <tytso@mit.edu>
CC:     Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4.19] ext4: eliminate bogus error in
 ext4_data_block_valid_rcu()
Thread-Topic: [PATCH 4.19] ext4: eliminate bogus error in
 ext4_data_block_valid_rcu()
Thread-Index: AQHXcHTT8UN1zsnza0mnnGKkuTe2tA==
Date:   Sun, 4 Jul 2021 01:35:09 +0000
Message-ID: <1625362509314.54473@amazon.com>
References: <20210703230555.4093-1-trdgn@amazon.com>,<YOEHmjjY9facxtIY@mit.edu>
In-Reply-To: <YOEHmjjY9facxtIY@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.66]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> If I understand the commit description, this patch is only intended=0A=
> for the 4.19 stable kernel.  If this is the case, I'd suggest using=0A=
> the Subject prefix [PATCH 4.19] for future patches.  This is more=0A=
=0A=
Hi Ted, yes this is only intended for 4.19. Thanks for the tip on subject l=
ine,=0A=
I will keep that in mind in the future.=0A=
=0A=
> if you could indicate whether a similar fix is needed for 4.14, and=0A=
> other older LTS kernels, or whether the only stable backport which had=0A=
> this bug was 4.19.=0A=
=0A=
I have checked 4.4, 4.9, 4.14, 5.8. They all look fine. I believe this prob=
lem=0A=
only affects 4.19.=0A=
=0A=
> P.S.  Great to see you've landed at Amazon!  It's been a while; if I=0A=
> have a chance to make it out to Seattle, one of these days, it would=0A=
> be great to catch up.=0A=
=0A=
Absolutely, drop me a note next time you are around Seattle.=0A=
=0A=
thanks=0A=
tahsin=0A=
=0A=
________________________________________=0A=
From: Theodore Ts'o <tytso@mit.edu>=0A=
Sent: Saturday, July 3, 2021 5:58 PM=0A=
To: Erdogan, Tahsin=0A=
Cc: Jan Kara; Greg Kroah-Hartman; stable@vger.kernel.org; Andreas Dilger; l=
inux-ext4@vger.kernel.org; linux-kernel@vger.kernel.org=0A=
Subject: RE: [EXTERNAL] [PATCH] ext4: eliminate bogus error in ext4_data_bl=
ock_valid_rcu()=0A=
=0A=
CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you can confirm the sender and know the=
 content is safe.=0A=
=0A=
=0A=
=0A=
On Sat, Jul 03, 2021 at 04:05:55PM -0700, Tahsin Erdogan wrote:=0A=
> Mainline commit ce9f24cccdc0 ("ext4: check journal inode extents more car=
efully")=0A=
> enabled validity checks for journal inode's data blocks. This change got=
=0A=
> ported to stable branches, but the backport for 4.19 has a bug where it w=
ill=0A=
> flag an error even when system block entry's inode number matches journal=
=0A=
> inode.=0A=
=0A=
Tahsin,=0A=
=0A=
If I understand the commit description, this patch is only intended=0A=
for the 4.19 stable kernel.  If this is the case, I'd suggest using=0A=
the Subject prefix [PATCH 4.19] for future patches.  This is more=0A=
likely to be clearer (via a quick glance at the Subject line) for=0A=
subsystem maintainers, as well as for stable kernel maintainers, that=0A=
this is meant for the stable kernel.  It would perhaps also be useful=0A=
if you could indicate whether a similar fix is needed for 4.14, and=0A=
other older LTS kernels, or whether the only stable backport which had=0A=
this bug was 4.19.=0A=
=0A=
Cheers,=0A=
=0A=
                                        - Ted=0A=
=0A=
P.S.  Great to see you've landed at Amazon!  It's been a while; if I=0A=
have a chance to make it out to Seattle, one of these days, it would=0A=
be great to catch up.=0A=
