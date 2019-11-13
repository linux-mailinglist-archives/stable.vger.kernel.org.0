Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B047FB50F
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfKMQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 11:29:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:36170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfKMQ3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 11:29:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 307AFB205;
        Wed, 13 Nov 2019 16:29:36 +0000 (UTC)
Date:   Wed, 13 Nov 2019 17:29:34 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191113162934.GF19372@blackbody.suse.cz>
References: <20191106225131.3543616-1-guro@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Content-Disposition: inline
In-Reply-To: <20191106225131.3543616-1-guro@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi.

On Wed, Nov 06, 2019 at 02:51:30PM -0800, Roman Gushchin <guro@fb.com> wrote:
> Let's fix it by switching from css_tryget_online() to css_tryget().
Is this a safe thing to do? The stack captures a kmem charge path, with
css_tryget() it may happen it gets an offlined memcg and carry out
charge into it. What happens when e.g. memcg_deactivate_kmem_caches is
skipped as a consequence?

> The problem is caused by an exiting task which is associated with
> an offline memcg. We're iterating over and over in the
> do {} while (!css_tryget_online()) loop, but obviously the memcg won't
> become online and the exiting task won't be migrated to a live memcg.
As discussed in other replies, the task is not yet exiting. However, the
access to memcg isn't through `current` but `mm->owner`, i.e. another
task of a threadgroup may have got stuck in an offlined memcg (I don't
have a good explanation for that though).

HTH,
Michal

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl3ML2cACgkQia1+riC5
qSgQZA/+KD6f95XTCnV55rr15xwdquOdz4T+bmiNstvliVaYqvukej5/cCxTPKJK
I4zHkgTix48h9NDvrvIuOaY68D+nlczIUsAIA1BQlZga7HnV96+d1/j/TFiNMIyr
FDFHIfNU07mO6C5uCQOYe1VLfa9auNrpNtkhiqYYhaFrLVsQC7veGWg2Euy914Rc
YgQMhFuz4HxFwOtXaHKh+SvvNhL9qttdOZx1ACAAcNhS0nltpj/mGhG2gO8mChkh
YhXjf5CeDY4nqnLwgiDlRQN66cSOL/DVUC7Acl3NLpmWzTkKuS3gIIsSTvzhsKAE
G/B/fbPupZuPuE8tC+kVdKacZVhJ1v1mgcyZxRAXKaSGOhCXhSIQlqt9bgflGMwZ
Gfp8YY8F1LcFZdTuCvkodnS4TAAnL54GEuvqAxTqs7FzTgb9VBtx7C99spTxXY3q
uC99i+J8swSO/a14Eo0RGAZB0RKtDpGxHyTa/kwsHx2JcJLrFKQGzstK2rdmUS1q
2mt6zT+AM8RVJqHSVdtDGdA1fBlZcDvWTRIr/FtQswGFtXN8ikpEfUXRT0NrL75s
89w/b3qb2PMVaDoIwGEnIudNYCmoEhBo8OocB8pWwt3BYnBX7L+aLXqDX9ITLJOj
vOwcVSWNy2EuLN6XEa1P8opml3XXoDl2l9D/7a4qIb8214XwAtY=
=Czsl
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
