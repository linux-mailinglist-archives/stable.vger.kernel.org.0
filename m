Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD7B9F733
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 02:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfH1AMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 20:12:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50212 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfH1AMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 20:12:53 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1i2lZz-0000Ho-Oi; Wed, 28 Aug 2019 01:12:51 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1i2lZz-0007mg-Gv; Wed, 28 Aug 2019 01:12:51 +0100
Message-ID: <3c6356b7406c0a49b8262b9b4b7326afd367a3f5.camel@decadent.org.uk>
Subject: Re: [PATCH 4.9 033/223] perf test 6: Fix missing kvm module load
 for s390
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Wed, 28 Aug 2019 01:12:44 +0100
In-Reply-To: <20190802092241.125480296@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
         <20190802092241.125480296@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-RT7iNlAGbWHQO9K0QoHF"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-RT7iNlAGbWHQO9K0QoHF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-08-02 at 11:34 +0200, Greg Kroah-Hartman wrote:
> [ Upstream commit 53fe307dfd309e425b171f6272d64296a54f4dff ]

This results in numerous compiler errors:

tests/parse-events.c: In function 'kvm_s390_create_vm_valid':
tests/parse-events.c:25:14: error: implicit declaration of function 'get_ev=
ents_file' [-Werror=3Dimplicit-function-declaration]
  eventfile =3D get_events_file("kvm-s390");
              ^~~~~~~~~~~~~~~
tests/parse-events.c:25:12: error: assignment makes pointer from integer wi=
thout a cast [-Werror=3Dint-conversion]
  eventfile =3D get_events_file("kvm-s390");
            ^
tests/parse-events.c:34:3: error: implicit declaration of function 'put_eve=
nts_file' [-Werror=3Dimplicit-function-declaration]
   put_events_file(eventfile);
   ^~~~~~~~~~~~~~~
tests/parse-events.c: At top level:
tests/parse-events.c:1622:3: error: unknown field 'valid' specified in init=
ializer
   .valid =3D kvm_s390_create_vm_valid,
   ^
tests/parse-events.c:1622:12: error: excess elements in struct initializer =
[-Werror]
   .valid =3D kvm_s390_create_vm_valid,
            ^~~~~~~~~~~~~~~~~~~~~~~~
tests/parse-events.c:1622:12: note: (near initialization for 'test__events[=
45]')

It is using functions that were only added in Linux 4.18 so I think it
should be reverted from the 4.4, 4.9, and 4.14 stable branches.

Ben.

> Command
>=20
>    # perf test -Fv 6
>=20
> fails with error
>=20
>    running test 100 'kvm-s390:kvm_s390_create_vm' failed to parse
>     event 'kvm-s390:kvm_s390_create_vm', err -1, str 'unknown tracepoint'
>     event syntax error: 'kvm-s390:kvm_s390_create_vm'
>                          \___ unknown tracepoint
>=20
> when the kvm module is not loaded or not built in.
>=20
> Fix this by adding a valid function which tests if the module
> is loaded. Loaded modules (or builtin KVM support) have a
> directory named
>   /sys/kernel/debug/tracing/events/kvm-s390
> for this tracepoint.
>=20
> Check for existence of this directory.
>=20
> Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/r/20190604053504.43073-1-tmricht@linux.ibm.c=
om
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/perf/tests/parse-events.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>=20
> diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-eve=
nts.c
> index aa9276bfe3e9..9134a0c3e99d 100644
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -12,6 +12,32 @@
>  #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
>  			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
> =20
> +#if defined(__s390x__)
> +/* Return true if kvm module is available and loaded. Test this
> + * and retun success when trace point kvm_s390_create_vm
> + * exists. Otherwise this test always fails.
> + */
> +static bool kvm_s390_create_vm_valid(void)
> +{
> +	char *eventfile;
> +	bool rc =3D false;
> +
> +	eventfile =3D get_events_file("kvm-s390");
> +
> +	if (eventfile) {
> +		DIR *mydir =3D opendir(eventfile);
> +
> +		if (mydir) {
> +			rc =3D true;
> +			closedir(mydir);
> +		}
> +		put_events_file(eventfile);
> +	}
> +
> +	return rc;
> +}
> +#endif
> +
>  static int test__checkevent_tracepoint(struct perf_evlist *evlist)
>  {
>  	struct perf_evsel *evsel =3D perf_evlist__first(evlist);
> @@ -1593,6 +1619,7 @@ static struct evlist_test test__events[] =3D {
>  	{
>  		.name  =3D "kvm-s390:kvm_s390_create_vm",
>  		.check =3D test__checkevent_tracepoint,
> +		.valid =3D kvm_s390_create_vm_valid,
>  		.id    =3D 100,
>  	},
>  #endif
--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.


--=-RT7iNlAGbWHQO9K0QoHF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1lxv0ACgkQ57/I7JWG
EQmeAg//YSz80BQP46T+aVNoqw//S8wZ3Wf8rDkYAmxzO8gTUOJikrMFnf87d+WV
wlDDY5citkhBPRpRNID33LqNX+GHyYoBH6v71cfdtYYxwPl9ClitrdicajJ7ljkz
fn1nLYDgwHXO57MEoX3TwJObmiHYfeQM1fXQIzvy+gFED95iBHnRQAHy7FRYIJQg
4iaR2S0ciV5CKZviZvjUrfydH5B7pFWiyTudoLw2el9+4OXznwTY1to+d7hJcxFI
No5XYmNRlA7xYw2WsXRINd07yOK4ps4UqhhcBwTlkzpaVJw2/DBOsDYUINWmCDQD
QUs8WFX5ZU2eivb2OVLX24cz4EkMv9oADdKkryDhnoHmlor37IDATWubEejQ6MTC
DnnAtDURsQ24Ly2oQzVJ25Mfw+gfAcZgcc5ZSzdzOEuyuApw+7FTZ1A1p0OpKxje
QEM2fdPTfGSyyM5DOJzfKBgcfE5EaR+K5RcCBCbWBiKiWVwNNUN4H1de0hWKiRhT
e64R/TYbyfxuHoQvuC5W/EhqarOUkUClK0x2tb6A9jro3y/FuDu4zJkIY7IKx26X
pCmYYRieDz8kLTJlNvz7oYRIU965h90gSIB8/0xB5R85E4dWah89ImNrmyp/Bk+0
71Qo3Z6S09Dma2SJLpxgR32e2t2lY6fZypbcaZIxskensSxN01k=
=SPQP
-----END PGP SIGNATURE-----

--=-RT7iNlAGbWHQO9K0QoHF--
