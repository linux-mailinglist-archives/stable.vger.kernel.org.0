Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5171B97F4
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 09:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgD0HCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 03:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgD0HCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 03:02:05 -0400
X-Greylist: delayed 86010 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Apr 2020 00:02:05 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DECC061A0F
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 00:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1587970919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KbvoomzfamrUKNn59kmZAaB2OHNvjnwBMb+jI5NKQP0=;
        b=XsGDxGSAPBbqFwVqwRf2WKSF0Ki301aVcMzm54qPyJSrsY5Xk5q6yUSVemTM9OIgETS8wH
        /1hJQGpdwBEh+0Pq1qwChOYULqWgkZH10O7aUcqYbp1XjKkl8JAqkJBsufEH+SAhRLOlVU
        s53eFkNocD10V31MqdjWyFSqPvpiRvs=
From:   Sven Eckelmann <sven@narfation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.14] mm, slub: restore the original intention of prefetch_freepointer()
Date:   Mon, 27 Apr 2020 09:01:56 +0200
Message-ID: <11030934.sCltEm0ppq@bentobox>
In-Reply-To: <20200426231426.GM13035@sasha-vm>
References: <20200426070617.14575-1-sven@narfation.org> <20200426231426.GM13035@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7321197.xugn6qQKx4"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart7321197.xugn6qQKx4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, 27 April 2020 01:14:26 CEST Sasha Levin wrote:
> On Sun, Apr 26, 2020 at 09:06:17AM +0200, Sven Eckelmann wrote:
> >From: Vlastimil Babka <vbabka@suse.cz>
> >
> >commit 0882ff9190e3bc51e2d78c3aadd7c690eeaa91d5 upstream.
[...]
> >---
> >The original problem is explained in the patch description as
> >performance problem. And maybe this could also be one reason why it was
> >never submitted for a stable kernel.
> >
> >But tests on mips ath79 (OpenWrt ar71xx target) showed that it most likely
> >related to "random" data bus errors. At least applying this patch seemed to
> >have solved it for Matthias Schiffer <mschiffer@universe-factory.net> and
> >some other persons who where debugging/testing this problem with him.
> >
> >More details about it can be found in
> >https://github.com/freifunk-gluon/gluon/issues/1982
> 
> Interesting... I wonder why this issue has started only now.

Unfortunately, I don't know the details. So I (actually we) would love to get 
some feedback from the slub experts. Not that there is another problem which 
we just don't grasp yet.

Just some background information about the "why" from freifunk-gluon's 
perspective:

OpenWrt 19.07 was released (despite its name) at the beginning of 2020. And it 
was the first release using kernel 4.14 on the most used target: ar71xx 
(ath79). The wireless community network firmware projects (freifunk-gluon in 
this example) updated their frameworks to this OpenWrt release in the last 
months and just now started to roll it out on their networks.

And while the wireless community networks around here usually don't track the 
connected clients, the health of the APs is often tracked on some central 
system. And some people then just noticed a sudden spike of reboots on their 
APs. Since ar71xx is (often) the most used architecture at the moment, this 
could be spotted rather easily if you spend some time looking at graphs.

Kind regards,
	Sven
--nextPart7321197.xugn6qQKx4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl6mg2QACgkQXYcKB8Em
e0axuw//WUYoq2bULwztmPwcfVxfsZCA7BGsYbwY8Z+3DfSefvChjuKn7FIJgtww
aepueFu4ZlSimrCUrld48Va6/UVjYHkZUw10e+F3Cix5pPkM8uyvPrfs+FQJbrrr
GAingH5grXDQm7HZG960hVxFA4wQPCKoCIEdO1652z9COZE3mtRtoj6uY2NvFnXI
U7IDfPZdLzcVGUdvVycgynhMvg0+9dK4jpoIFwHrZGdonPscNQRI7Ha1JzKI+5O+
Po7HB+m92tFD3BCpk30c6GuIxyvXsWqZAS9WPf/8BcR9eSYL5myOAMZ52aHEWe5U
m1xNX8vJmqwQNjw6pwxGzJYW7IrVGgbjWyZBkWsw0C/IDlgTOz4zAItQha95yfGG
txf00BLb8Xk2o87EkdyUbHkvY7TeoLj/8AbC+tmCp1rMBIzdOCHizdOR8nZkTads
MphQf8VY0AACnYhFju8q+Pe4J65l3yRUTEk59n//jl6CajHszyb0WFZB3ZJCVsyf
CgNQ5Yq3ebuuq14PKi94J6sWKQmMLS2VyolBPyW8/G1nFe2mqQ1jZeU0DZB81G2z
5g/x5Wth5SR2a0MHagC4zG866r8xhpfDWhKrycflW5ZOA7Tgz9SY7R3luqUvPv0I
QICz6wKr6FRAfb+UNwoufsCfAlKctE1wZGmPe5e5CoHAvR8we1w=
=nK+i
-----END PGP SIGNATURE-----

--nextPart7321197.xugn6qQKx4--



