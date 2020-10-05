Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFAF283318
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 11:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgJEJWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 05:22:55 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:44017 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgJEJWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 05:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601889770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ainB/PT4vIjNDb7xFspprPKgDDdfhBCDyfDAZQeU7Js=;
        b=GTLBoqxdpu+r+J/G6WH310dz1jL0eqUdNa6XrP7EX6GykGQlcPD0bzhIKTmB+NnmIfEuDk
        pPM35h6vYYBLyBDti9IcVScb1W2WQKknJYtfISeJXYYQArCBngZkFalaawFp3q8uqZxYjp
        LgRpCQcR1lBzntbwy+u7Ks6X3ATV6Ig=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2057.outbound.protection.outlook.com [104.47.9.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-1EeXVGB2NAKO4oxb26RcjQ-1; Mon, 05 Oct 2020 11:22:48 +0200
X-MC-Unique: 1EeXVGB2NAKO4oxb26RcjQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icqGfAbgoQxo5mQUYzP0Yr5tOceWy5iA4QVQ40zwXXa4bfMDpLGGXa03H+vTiJjIlxgqgqg3096kG77uuuAtHvgW8NR4wzmGoS6pidx1QssR15Pc5miUfgQSEcfr5p9Qk7zUp3NdQjLEMDkBa2abrMR6QV+dejsdi9kNxQalRuCaeJ1jc5FXmYFlEJOwROjX4zQm4HwtyAJET+dKwLhiRKPu4CjuMtkhaDiV0eTX/yhgxJ3W8XhDhwLhL4a32XpNWycv1PJcu6mdIGk44UNDvqp0YNPcpH/MnubB4L0G6HCEg7Cn7OTBzgYWMe3SwBkUMENmn6ORTaBP5zJaOafKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ainB/PT4vIjNDb7xFspprPKgDDdfhBCDyfDAZQeU7Js=;
 b=husmm86NzfICby0OB86K4xFmKmy+laZ5cDpltvfR7M+tDW9JULL8+KJ0T8XcnbO029XyPqrpwzhEg0nW44pfhlG8+Pmk/qyrhiKQraCXQuAgi3NrBR51qcacZLn0OohmIjdTTTGKAAjkHA1r4zaCKGtrAaxvn4UJpz/i1tDxtgtTKtXi+30//ehzLmgJCYe9dffqTSDAHdD0kAP1kGHMY6leRKH6Gog4TWo/XGO88QlV8kphqxQ+roTmRgCm9Uj8xqZ5vm7L6k+q2FesQ66BvH+9Hi/nlulODB+WbNG+SXKfEItheTr9Zh0+WWPKiemyjou1dpfH5TBO/4d+ouxm2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6195.eurprd04.prod.outlook.com (2603:10a6:208:13c::13)
 by AM0PR0402MB3345.eurprd04.prod.outlook.com (2603:10a6:208:1d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Mon, 5 Oct
 2020 09:22:46 +0000
Received: from AM0PR04MB6195.eurprd04.prod.outlook.com
 ([fe80::e9b0:22ea:e2da:1315]) by AM0PR04MB6195.eurprd04.prod.outlook.com
 ([fe80::e9b0:22ea:e2da:1315%5]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 09:22:46 +0000
Subject: Re: [PATCH] btrfs: workaround the over-confident over-commit
 available space calculation
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
References: <20200930120151.121203-1-wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0GFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPokBTQQTAQgAOAIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJdnDWhAAoJEMI9kfOhJf6oZgoH
 90uqoGyUh5UWtiT9zjUcvlMTCpd/QSgwagDuY+tEdVPaKlcnTNAvZKWSit8VuocjrOFbTLwb
 vZ43n5f/l/1QtwMgQei/RMY2XhW+totimzlHVuxVaIDwkF+zc+pUI6lDPnULZHS3mWhbVr9N
 vZAAYVV7GesyyFpZiNm7GLvLmtEdYbc9OnIAOZb3eKfY3mWEs0eU0MxikcZSOYy3EWY3JES7
 J9pFgBrCn4hF83tPH2sphh1GUFii+AUGBMY/dC6VgMKbCugg+u/dTZEcBXxD17m+UcbucB/k
 F2oxqZBEQrb5SogdIq7Y9dZdlf1m3GRRJTX7eWefZw10HhFhs1mwx7kBDQRZ1YGvAQgAqlPr
 YeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4KXk/kHw5h
 ieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T7RZwB69u
 VSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9fNN8e9c0
 MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD/dt76Kp/
 o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgBCAAmAhsM
 FiEELd9y5aWlW6idqkLhwj2R86El/qgFAl2cNa4FCQlqTn8ACgkQwj2R86El/qhXBAf/eXLP
 HDNTkHRPxoDnwhscIHJDHlsszke25AFltJQ1adoaYCbsQVv4Mn5rQZ1Gon54IMdxBN3r/B08
 rGVPatIfkycMCShr+rFHPKnExhQ7Wr555fq+sQ1GOwOhr1xLEqAhBMp28u9m8hnkqL36v+AF
 hjTwRtS+tRMZfoG6n72xAj984l56G9NPfs/SOKl6HR0mCDXwJGZAOdtyRmqddi53SXi5N4H1
 jWX1xFshp7nIkRm6hEpISEWr/KKLbAiKKbP0ql5tP5PinJeIBlDv4g/0+aGoGg4dELTnfEVk
 jMC8cJ/LiIaR/OEOF9S2nSeTQoBmusTz+aqkbogvvYGam6uDYw==
Message-ID: <62de94f8-9912-d612-6738-771e860765c5@suse.com>
Date:   Mon, 5 Oct 2020 17:22:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200930120151.121203-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n1OAKHSxeF5MRlf24f6kZSE4f3jf8PDp9"
X-Originating-IP: [149.28.201.231]
X-ClientProxiedBy: BYAPR01CA0014.prod.exchangelabs.com (2603:10b6:a02:80::27)
 To AM0PR04MB6195.eurprd04.prod.outlook.com (2603:10a6:208:13c::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR01CA0014.prod.exchangelabs.com (2603:10b6:a02:80::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Mon, 5 Oct 2020 09:22:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd2e3964-0c72-4f8e-10ec-08d86910388f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3345:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3345FB0A5185AEB53D1D5860D60C0@AM0PR0402MB3345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0heQxJO05VoAj68624quzcytMHqTihf9xMF3/HRKNcCjrinx14/qoKgPsmsjymT1dgXk6jh0a1c51N/OSEVr7CecjB4wCxglNzw1R0XJhFQGr3EWhNA2QPyne1+WtpX7gWOgg6qwOSd4Qc7CgyAnJC2C3+E/+TmHiXr+ok+5tX/CVKrlqsVTM6v+Hu4C4aFPCTf3gFX3RSrc504JBH2SAV/rGUqTYZmawq5ooowr2UcBstTPMNzncthjQCN8DS+Qfp+QV9ThTQc+sRcQ6SE1p1BNm2YERqJw1Dr2T6/79xCX9859u3OFjvbbd/hua2zV/JYRxR6aIJ5vZlvIa7WpP6K3Xf2/lnTw59UeI3X+jWJadqH9Rvj1TULTZRwuOt9rKw55/jNcrI0U0/5GStBIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6195.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39850400004)(4326008)(478600001)(66476007)(66946007)(31696002)(2906002)(21480400003)(36756003)(16576012)(66556008)(8676002)(186003)(52116002)(83380400001)(316002)(26005)(33964004)(16526019)(8936002)(6666004)(6706004)(86362001)(956004)(6916009)(6486002)(31686004)(5660300002)(2616005)(235185007)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MJ0YqYUqGgijJk4FFFzFWgo8xFAku18ghq7bNimKRuZ1WJxlDKY4CTLkRqMJa54QTlQVdqCQLbdpl71e79sRQUixh/r320dVWjh3Yi5FtfDCbtPxxm57FhpyWv60YZepkkKmb8+dU/O/A7F5aJl2XhHlaVbKDpDWiF5JzD3Xzf2iGOwVu961wxeEQrNHN4NE6/vnVs26naY1n2/Bq1446f+i1rLFRCeco0bueAfqUsR8YctQKrvVTLrozJCsuejWClcm5yzDK5+Pqyo9nEgbcCl15TUyLOy5p8fO6iI98ThIKuCZjLRq0o/eoAk08rgWL9yKAleCrJrD+JeAprU6GsypkXwAY7sNnWi4XkhFGRg1rH8DxM+BSyhAoeRv9bbR3s7/a2ScSDH3mLGUTfRPwicCXo4YIkx4yRYuRPFhglsVRab+wRumYuO7QFXTaVgaV9tWeUBmw990ofwTgjb8wHur+TEARE5LycsOasFtGTTNF0J6cGt0oarOsxN+CsrylubbEYXEV/dW+8sJnnSnXsO5rbasweiyknUxROP8X8V75enMdoeeETs406UK8X2gvNa9q2qY0lrSWvmKNhL1K/lmJ27hynXnQt1dFkEzkrxbnFVjObRS+tPg4rk/OSJj++fWOMnfobdOLSasL/nqmg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2e3964-0c72-4f8e-10ec-08d86910388f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6195.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 09:22:46.6306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Wsfv3yy6r5zpyKTZwQFHb5YrDPiDEVLnxwAcO/4N8LwYz9S6qLCY/YMqJ7iJPW3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3345
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--n1OAKHSxeF5MRlf24f6kZSE4f3jf8PDp9
Content-Type: multipart/mixed; boundary="xmigZaDafMjs2vCTJR1ymNoNSFg84QTqm"

--xmigZaDafMjs2vCTJR1ymNoNSFg84QTqm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

Would you please consider merge this patch as a hotfix?

We have more and more reports about deadly ENOSPC trap for multi-device
setup.

Considering the worst consequence, user can't even delete anything due
to exhausted metadata, I really hope we can at least workaround it.

The side effect of the patch is, smaller metadata over-commit, which may
decrease the performance, but I see it worthy to avoid the worst case
scenario.

And buy enough time for us to review the per-profile available space patc=
h.

Thanks,
Qu

On 2020/9/30 =E4=B8=8B=E5=8D=888:01, Qu Wenruo wrote:
> [BUG]
> There are quite some bug reports of btrfs falling into a ENOSPC trap,
> where btrfs can't even start a transaction to add new devices.
>=20
> [CAUSE]
> Most of the reports are utilize multi-device profiles, like
> RAID1/RAID10/RAID5/RAID6, and the involved disks have very unbalanced
> sizes.
>=20
> It turns out that, the overcommit calculation in btrfs_can_overcommit()=

> is just a factor based calculation, which can't check if devices can
> really fulfill the requirement for the desired profile.
>=20
> This makes btrfs_can_overcommit() to be always over-confident about
> usable space, and when we can't allocate any new metadata chunk but
> still allow new metadata operations, we fall into the ENOSPC trap and
> have no way to exit it.
>=20
> [WORKAROUND]
> The root fix needs a device layout aware, chunk allocator like availabl=
e
> space calculation.
>=20
> There used to be such patchset submitted to the mail list, but the extr=
a
> failure mode is tricky to handle for chunk allocation, thus that
> patchset needs more time to mature.
>=20
> Meanwhile to prevent such problems reaching more users, workaround the
> problem by:
> - Half the over-commit available space reported
>   So that we won't always be that over-confident.
>   But this won't really help if we have extremely unbalanced disk size.=

>=20
> - Don't over-commit if the space info is already full
>   This may already be too late, but still better than doing nothing and=

>   believe the over-commit values.
>=20
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/space-info.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>=20
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 475968ccbd1d..e8133ec7e34a 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -339,6 +339,18 @@ static u64 calc_available_free_space(struct btrfs_=
fs_info *fs_info,
>  		avail >>=3D 3;
>  	else
>  		avail >>=3D 1;
> +	/*
> +	 * Since current over-commit calculation is doomed already for
> +	 * RAID0/RADI1/RAID10/RAID5/6, we half the availabe space to reduce
> +	 * over-commit amount.
> +	 *
> +	 * This is just a workaround before the device layout aware
> +	 * available space calculation arrives.
> +	 */
> +	if ((BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1_MASK |
> +	     BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_RAID56_MASK) &
> +	     profile)
> +		avail >>=3D 1;
>  	return avail;
>  }
> =20
> @@ -353,6 +365,14 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_=
info,
>  	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
>  		return 0;
> =20
> +	/*
> +	 * If we can't allocate new space already, no overcommit is allowed.
> +	 *
> +	 * This check may be already late, but still better than nothing.
> +	 */
> +	if (space_info->full)
> +		return 0;
> +
>  	used =3D btrfs_space_info_used(space_info, true);
>  	avail =3D calc_available_free_space(fs_info, space_info, flush);
> =20
>=20


--xmigZaDafMjs2vCTJR1ymNoNSFg84QTqm--

--n1OAKHSxeF5MRlf24f6kZSE4f3jf8PDp9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl965d0ACgkQwj2R86El
/qj48Qf8CMDOO7x9B26XfPY1r8AQW43FEIbz2QSPVHMny6MEuq0WVUC6YsjZ2jdk
fmfVwEUZ5UvusdbvFV6Gh5DI2ozbFehoDXr2s3v3jZgikDk93nzqODz1K9ezltT8
xxpG5b0DYHuo9WQ3u5J9V8+TWQi5IsgGs1g59aXU6cbMhmrDndCbusGI6Zcc/SfE
tUlt5kXv7SGODytU74lkiEM1s0G/FqzMhpoMDq0LG5FNpCugdRFVE7FsVmKIWstr
OPQ6i+pWWW+CXvPbNBXSs58seHebYY/M2e0mC0lRGnDDUPXm1IGfFGdj5FicRXpu
WGV7hByaL1mJhp7N1iykmTHEfTDfJA==
=p5fm
-----END PGP SIGNATURE-----

--n1OAKHSxeF5MRlf24f6kZSE4f3jf8PDp9--

