Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12F21164CF
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 02:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfLIBkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 20:40:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:45255 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfLIBkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Dec 2019 20:40:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 17:40:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,293,1571727600"; 
   d="scan'208";a="206735287"
Received: from rzhang1-mobile.sh.intel.com ([10.239.195.243])
  by orsmga008.jf.intel.com with ESMTP; 08 Dec 2019 17:40:32 -0800
Message-ID: <2a37f59cd86d75258ac7257a23132d6ebfbcea70.camel@intel.com>
Subject: Re: [PATCH 3.16 43/72] thermal: Fix use-after-free when
 unregistering thermal zone device
From:   Zhang Rui <rui.zhang@intel.com>
To:     Ben Hutchings <ben@decadent.org.uk>,
        Ido Schimmel <idosch@mellanox.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "wvw@google.com" <wvw@google.com>
Date:   Mon, 09 Dec 2019 09:40:37 +0800
In-Reply-To: <92faedffaa625da9d385a6af2e554d8e4744fa7a.camel@decadent.org.uk>
References: <lsq.1575813164.154362148@decadent.org.uk>
         <lsq.1575813165.267246545@decadent.org.uk>
         <20191208162216.GA330015@splinter>
         <92faedffaa625da9d385a6af2e554d8e4744fa7a.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2019-12-08 at 18:09 +0000, Ben Hutchings wrote:
> On Sun, 2019-12-08 at 16:22 +0000, Ido Schimmel wrote:
> > On Sun, Dec 08, 2019 at 01:53:27PM +0000, Ben Hutchings wrote:
> > > 3.16.79-rc1 review patch.  If anyone has any objections, please
> > > let me know.
> > > 
> > > ------------------
> > > 
> > > From: Ido Schimmel <idosch@mellanox.com>
> > > 
> > > commit 1851799e1d2978f68eea5d9dff322e121dcf59c1 upstream.
> > > 
> > > thermal_zone_device_unregister() cancels the delayed work that
> > > polls the
> > > thermal zone, but it does not wait for it to finish. This is racy
> > > with
> > > respect to the freeing of the thermal zone device, which can
> > > result in a
> > > use-after-free [1].
> > > 
> > > Fix this by waiting for the delayed work to finish before freeing
> > > the
> > > thermal zone device. Note that thermal_zone_device_set_polling()
> > > is
> > > never invoked from an atomic context, so it is safe to call
> > > cancel_delayed_work_sync() that can block.
> > 
> > Ben,
> > 
> > Wei Wang (copied) found a problem with this patch and fixed it:
> > 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=163b00cde7cf2206e248789d2780121ad5e6a70b
> > 
> > I believe you should take both patches to your tree.
> 
> Thanks, I will add that now that it is in Linus's tree.
> 

yes, please do, thanks!

-rui
> Ben.
> 

