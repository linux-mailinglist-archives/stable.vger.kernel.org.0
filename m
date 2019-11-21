Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C69A10558D
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 16:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKUP2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 10:28:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:57076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbfKUP2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 10:28:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7F730B231;
        Thu, 21 Nov 2019 15:28:51 +0000 (UTC)
Date:   Thu, 21 Nov 2019 16:28:47 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191121152847.GA14375@blackbody.suse.cz>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20191113170823.GA12464@castle.DHCP.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2019 at 05:08:29PM +0000, Roman Gushchin <guro@fb.com> wrote:
> The thing here is that css_tryget_online() cannot pin the online state,
> so even if returned true, the cgroup can be offline at the return from
> the function.
Adding this for the record.

The actual offlining happens only from css_killed_ref_fn, which is
percpu_ref_kill_and_confirm confirmation callback. That is only called
after RCU grace period. So, css_tryget_online will pin the online state
_inside_ rcu_read_{,un}lock section.

The fact is that many call sites pass the css reference over
rcu_read_unlock boundary allowing potential offlining.

> So if we rely somewhere on it, it's already broken.
Charges into offlined memcg should fine (wrt the original patch). I
didn't check other callers though...

> Generally speaking, it's better to reduce it's usage to the bare minimum.
...I agree as it's confusing and potentially redundant.

Michal

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl3WrScACgkQia1+riC5
qShpuA//a/oxK/bmsjDKt4LE1wwkZ3GsY3MsYuExq3lBFEGj8FGXFuDA7qgrTHc5
MTk5HWE2HvGNuF/zUGKElTggicIlcEHb14RjiUpFstAZlVNkgL7CvILRNd+vIKZ8
nA8n509j+H8mtbdtsb9yvHFpvKKwz97X2Rvm8z8fhnzbiQEOOD0vdA/C7mIhVUty
YP7mT4GsinaUxlpnD6VP8V656yEM7PPCLSryJaJabdJAnk5rG4GXCfu15GRvGX4u
OMlRvSuF0YsRcSD6ay7YHo0+8dXyoLJyhZLyevCyqzRenWY5I6FUAV+1xwlukYY6
WaCPpJn7ZFo/Xb0f4g/2JBjnfw0sSRh9VDlg8Jct0uhckd1dCJIh8/DV2AJEs7X+
Ud+tgZHaULVPwFDI7489ovfdMi0z3xDwUVwCyh0l6x7zxLnrisuwCVPn3BSS6KRE
xKDGMbwwqdjviUmWbagxCVJnc140TKvkXvnwApn3yBG5qkYo+2eHHn74gYP7Pg6n
GplINVmLDEbJAxD6dtYWR4aKPgBQIJjfjgT8oRp6SNzULyKOm7KB2jyA6T5biHon
a7GmuSiOBMse4Ot2YoR5Z4h7AIcNN5HkZjn3phXM2UFRZuacuu/k8fsgSi7Mt3cR
qgRY69rUsd57kRC1Bm56FizYUDJL6S7FoeQrk/r2eR7giof1mGM=
=CqvJ
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
