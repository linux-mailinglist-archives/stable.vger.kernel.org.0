Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1DF28366A
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 15:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJENSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 09:18:06 -0400
Received: from mout.gmx.net ([212.227.17.22]:58785 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgJENSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 09:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601903883;
        bh=IQz55Vu5YnRa6sENuhwMeZNoKPh48zSXhDgWDtkO3oc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MDgEexZAD0/F/uYHna1kjvnTIMTKddq4AnKIDNMoLnLaGVVWxgDd2T4TgJR/qBpAD
         nJIJhIyxxbwDAr3mC8RYTcK+44uOkrrDmoLeEUn8ejlQ7BJpVWeWz1dBLnkhMcxffF
         ceoBKj95DzdrdX2vWhqD/YFLYchEAfQdpguZ5LI4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MuUjC-1kgfvu03Zy-00rZF5; Mon, 05
 Oct 2020 15:12:56 +0200
Subject: Re: [PATCH] btrfs: workaround the over-confident over-commit
 available space calculation
To:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200930120151.121203-1-wqu@suse.com>
 <54c0fa16-ed85-50bb-2267-0aff6276b4e2@toxicpanda.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAU4EEwEIADgCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1oQAKCRDC
 PZHzoSX+qCY6CACd+mWu3okGwRKXju6bou+7VkqCaHTdyXwWFTsr+/0ly5nUdDtT3yEVggPJ
 3VP70wjlrxUjNjFb6iIvGYxiPOrop1NGwGYvQktgRhaIhALG6rPoSSAhGNjwGVRw0km0PlIN
 D29BTj/lYEk+jVM1YL0QLgAE1AI3krihg/lp/fQT53wLhR8YZIF8ETXbClQG1vJ0cllPuEEv
 efKxRyiTSjB+PsozSvYWhXsPeJ+KKjFen7ebE5reQTPFzSHctCdPnoR/4jSPlnTlnEvLeqcD
 ZTuKfQe1gWrPeevQzgCtgBF/WjIOeJs41klnYzC3DymuQlmFubss0jShLOW8eSOOWhLRuQEN
 BFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcgaCbPEwhLj
 1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj/IrRUUka
 68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fNGSsRb+pK
 EKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0q1eW4Jrv
 0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEvABEBAAGJ
 ATwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1rgUJCWpOfwAKCRDCPZHz
 oSX+qFcEB/95cs8cM1OQdE/GgOfCGxwgckMeWyzOR7bkAWW0lDVp2hpgJuxBW/gyfmtBnUai
 fnggx3EE3ev8HTysZU9q0h+TJwwJKGv6sUc8qcTGFDtavnnl+r6xDUY7A6GvXEsSoCEEynby
 72byGeSovfq/4AWGNPBG1L61Exl+gbqfvbECP3ziXnob009+z9I4qXodHSYINfAkZkA523JG
 ap12LndJeLk3gfWNZfXEWyGnuciRGbqESkhIRav8ootsCIops/SqXm0/k+Kcl4gGUO/iD/T5
 oagaDh0QtOd8RWSMwLxwn8uIhpH84Q4X1LadJ5NCgGa6xPP5qqRuiC+9gZqbq4Nj
Message-ID: <47f06711-bbd3-9796-2934-ef0572f500cf@gmx.com>
Date:   Mon, 5 Oct 2020 21:12:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <54c0fa16-ed85-50bb-2267-0aff6276b4e2@toxicpanda.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FTxVubMMi5pOMuM7jdlk484gneBSugsxw"
X-Provags-ID: V03:K1:3KL5CIWxPb8A4a0SQDQK+UCp97oxWlwop0Iba5RtF630ooF5UMT
 YfK3zJ2/BBkJW/ReH6FrM8Sfr9Vs9tqibTFKMmip+U/qXYETb96ME7WY+KWbFGXOo8fuKKr
 ojLSCPsIj8/vQo8lOgRWvfVqJ24a8MYAc0TJKKp+JSAvtZHXR3n6HXAT7jA7RjZ1hpV1Q9s
 JFdhN+Dv2eVDtLQgitKRw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Pyp1btKm77I=:3iowGM0knqsAdmVcZIu+U4
 +8sMx7G6u9+HFpGto0BBK1X8bd6aOcVeuNr7o2OAEkh+Px8HoB1QZbL8U5jwV0XENOpGbyQo0
 1EwJy3i1m1cVr1VZv24GQYSMzqtKXUAIj5qCVD7ad7XDUZclpaK8p0NdYl9PRuIeHFYyyZPDq
 HEzkVqc3SS6VmlzB6aCe5AcvFiHC6Uj0KRGR8KKuOr5T8WztUDa5lkwiAeprLX/uoe0TRoNkR
 CttKJ0GEXZZ0kF5eROV664k/dLQItpz2Ra5HQnPvyZHnhA/x3vTZbLI5hrjukXVjnsHoN+bQS
 nLi70DSD0VVmfOw2n707B8lK/M15mtngk5caW1rZM5aKX9RffjJAfCoRtXHIk1S0qy9pjAMPO
 dhaiebobOTuYw7WUwjcnx6r7nd04UtxmDHqXyuc1ZlLBnzQWOluzpcfLi9/bNUxIQNN/5lcuX
 J2dydMrz6FvBF7Hs5F2hNZtJu8z90Bxs4x9xzgm2TLKGfWkNYsvmNWphNQk1DKQ4f7HnAa/KX
 ceJf+AWvScHdAK9njuZe9tdj/Zi+9/7JXkl77mKPmcDio+t4ocWMKRDoqbnEnnyo6RH15x2qd
 XO8g3Pd1vvLcOKqFKiTbln9ifu9gqg/SaOQiy9E2EyHY2wKjWbcl0GerBezgSkrZmNqA3HRyO
 BDWG1nqFJwHEA/mmPdFMOpVFfVHI1gwxAVrOwIghzVHJpwYxWw6bnI3pkkAmaguHFIWYxNIUc
 jeAENLpluMa7IMfJ/A45EWEvyEBHJA0EUMwH6v6Qq8P3cSGXEPQR9Bl9SkrYB+f17FpMkEP+a
 TswHZ7jf4VELPw65xVRenVt/ti1uIZSt9jtFHWTINoB0MZ7unXpDsmU5I1exk+9y7mrmL2APg
 ahcw8mg82hI3oSOdj6zVCwrQgNUAU0BYkzNv8H2yzeIFNA+9ANQdYRMHohqSA00YQxTnNjzCy
 7SGc7unZlus929fDAOB0DpKlqWqiInNmirIgnsIt5JBIfELLDJzPg5D+wvQhnSWPl1zLdico1
 dIE/4d2iE/dE4BCq0pOGhaf9EDjeOd+8JrjpPIaeOH/cWOPzqp05s/F0aVL+MuBYuZaF79UOi
 6fuqzW7mLIrCmyDAwtQb1/efSl89xG57nCwBfw7RYqHOVEVwVJQ/S04L5VUSy8YfyhVGpwtie
 9LgO+ttBarb9Vkt1LXy9S5r8B5I7SXXaBdir//zRCF/3wTk1snNz3P7C18hdkYIEQO3vJAB/+
 uwONWp7P+WBfN6pOyYVqKsJyyq/buMWDRxeT2DA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FTxVubMMi5pOMuM7jdlk484gneBSugsxw
Content-Type: multipart/mixed; boundary="L6AORRMiyklG5IkarKBzr9rTyK90RIRAv"

--L6AORRMiyklG5IkarKBzr9rTyK90RIRAv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2020/10/5 =E4=B8=8B=E5=8D=889:05, Josef Bacik wrote:
> On 9/30/20 8:01 AM, Qu Wenruo wrote:
>> [BUG]
>> There are quite some bug reports of btrfs falling into a ENOSPC trap,
>> where btrfs can't even start a transaction to add new devices.
>>
>> [CAUSE]
>> Most of the reports are utilize multi-device profiles, like
>> RAID1/RAID10/RAID5/RAID6, and the involved disks have very unbalanced
>> sizes.
>>
>> It turns out that, the overcommit calculation in btrfs_can_overcommit(=
)
>> is just a factor based calculation, which can't check if devices can
>> really fulfill the requirement for the desired profile.
>>
>> This makes btrfs_can_overcommit() to be always over-confident about
>> usable space, and when we can't allocate any new metadata chunk but
>> still allow new metadata operations, we fall into the ENOSPC trap and
>> have no way to exit it.
>>
>> [WORKAROUND]
>> The root fix needs a device layout aware, chunk allocator like availab=
le
>> space calculation.
>>
>> There used to be such patchset submitted to the mail list, but the ext=
ra
>> failure mode is tricky to handle for chunk allocation, thus that
>> patchset needs more time to mature.
>>
>> Meanwhile to prevent such problems reaching more users, workaround the=

>> problem by:
>> - Half the over-commit available space reported
>> =C2=A0=C2=A0 So that we won't always be that over-confident.
>> =C2=A0=C2=A0 But this won't really help if we have extremely unbalance=
d disk size.
>>
>> - Don't over-commit if the space info is already full
>> =C2=A0=C2=A0 This may already be too late, but still better than doing=
 nothing and
>> =C2=A0=C2=A0 believe the over-commit values.
>>
>=20
> I just had a thought, what if we simply cap the free_chunk_space to the=

> min of the free space of all the devices.

Sure, reducing the number will never be a problem.

> Simply walk through all the
> devices on mount, and we do the initial set of whatever the smallest on=
e
> is.=C2=A0 The rest of the math would work out fine, and the rest of the=

> modifications would work fine.

But I still prefer to do the minimal device size update at the timing of
my per-profile available space, so we don't have any chance to
over-estimate.

> =C2=A0The only "tricky" part would be when we
> do a shrink or grow, we'd have to re-calculate the sizes for everybody,=

> but that's not a big deal.=C2=A0 Thanks,

As long as we don't over-estimate, everything will be fine, just how
many extra metadata flushing is needed (thus extra overhead).

The rest is just a spectrum between "I don't really like over-commit at
all and let's make it really hard to do any overcommit" and "I'm a super
smart guy and here is the best algorithm to estimate how many space we
really have for over-commit".

Thanks,
Qu

>=20
> Josef
>=20


--L6AORRMiyklG5IkarKBzr9rTyK90RIRAv--

--FTxVubMMi5pOMuM7jdlk484gneBSugsxw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl97G9UACgkQwj2R86El
/qhQ1wf7BRK0pILid0ZUEwZBuVGOhpbN3HkQ2VMEuKJcvYFshZFoaLBP6AXezIKH
5KxRN6hGdfy15V+H3zbvfVPYdXZbHcnuGNhqRBmBkVbIGylde4pJLxt1sIrUavLw
26MX4xBe9ZQ8mn9mVTdv3kJooJRayvxRMDvjAj3dpG+1jPYeef6o0Trv4kVNRv65
rPCVnYrzbBah4YDvsuoGA/Id6biun/I5jT6ox+BX2xtaEFs6jF++bdN3y+Q3DfGI
eTFYYstvGnsyb07Xz+loRdRVAcio36hO7jaEza+jbtemyi+lLGdrqyoKqDcX8a7x
pc98cjuvGUYlZupgfMaw7VdSjYz0MQ==
=C3lI
-----END PGP SIGNATURE-----

--FTxVubMMi5pOMuM7jdlk484gneBSugsxw--
