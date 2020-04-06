Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91B19F217
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 11:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgDFJKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 05:10:06 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:51998 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgDFJKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 05:10:06 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2020 05:10:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1586164206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7NHbB9BsfudNyev+nKE/1EJEWNA2WPr4keczYxzGBKc=;
  b=Mls9pi13hIp6oRyD0aZ9Et2Yjxajmbo8u2d/ghjsECQbqpC8TxpQmglM
   lMAnPnNGUX1qZl3plS3Vve76L8JiyNzJunfmTmln8uRSLW5UvAX+e9khn
   fCHsmdrykQM05j6G4XYI3+GZRptZIqhWKPN7DuZsBXyFRtABKWxySWZv/
   I=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=roger.pau@citrix.com; spf=Pass smtp.mailfrom=roger.pau@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  roger.pau@citrix.com) identity=pra; client-ip=162.221.158.21;
  receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa1.hc3370-68.iphmx.com: domain of
  roger.pau@citrix.com designates 162.221.158.21 as permitted
  sender) identity=mailfrom; client-ip=162.221.158.21;
  receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: sfPgwiT0RDqtOpIx8BpsOCGBpAYrEzJ8byAffdFSgPLT9oxrM1pLGxV1YpTJCLmm+D5/KjNwTc
 4UshXQsueyUHBq1QxYi9jubJ5prBv2AV1sK3XdnCfpQ5nvwcoAgTHamzh1kzvb9Msqal7Yq7ju
 qkhW17FkqJq6jUNmkeLMrG3DrtG4VCWd4pl8ZCS6WZTcR9wCZPK+yuKDj30clW5wGNYiAOrJNF
 kaoORMq+5pf6CxfxkMZjiwGVrinU52Ub1BjdqlJR6wPq5FyizUbdSQa9w4AHuCK67Qe5lhHDdp
 LIU=
X-SBRS: 2.7
X-MesageID: 15445372
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.72,350,1580792400"; 
   d="scan'208";a="15445372"
Date:   Mon, 6 Apr 2020 11:02:50 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Juergen Gross <jgross@suse.com>
CC:     <xen-devel@lists.xenproject.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/blkfront: fix memory allocation flags in
 blkfront_setup_indirect()
Message-ID: <20200406090250.GX28601@Air-de-Roger>
References: <20200403090034.8753-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200403090034.8753-1-jgross@suse.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 03, 2020 at 11:00:34AM +0200, Juergen Gross wrote:
> Commit 1d5c76e664333 ("xen-blkfront: switch kcalloc to kvcalloc for
> large array allocation") didn't fix the issue it was meant to, as the
> flags for allocating the memory are GFP_NOIO, which will lead the
> memory allocation falling back to kmalloc().
> 
> So instead of GFP_NOIO use GFP_KERNEL and do all the memory allocation
> in blkfront_setup_indirect() in a memalloc_noio_{save,restore} section.
> 
> Fixes: 1d5c76e664333 ("xen-blkfront: switch kcalloc to kvcalloc for large array allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>

Acked-by: Roger Pau Monné <roger.pau@citrix.com>

Thanks!
