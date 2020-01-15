Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D820C13C2B6
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 14:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgAON0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 08:26:51 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40609 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgAON0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 08:26:50 -0500
Received: by mail-lj1-f193.google.com with SMTP id u1so18552526ljk.7;
        Wed, 15 Jan 2020 05:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=BNgZyNR9g9I8cL/8kYFEhAhW0Tg8IwdiIKGKieeU8/c=;
        b=m4e7OtAp+BqxAcJ9kneipNfLe8d43ZOMompiFjW3D81N6nNjfVRj0+HvPHD1hu4g5d
         2261Hy8+9CQblWYKIRgPAf7DAWZvggO/cIOH9Jl1BBY/rXNq20/AxwnVnjxOKtY6+KNM
         fPsGWLANYluCgrqiuOh7JeDqVC+vd15pC8+bbpXAnO4OpK2OcWdHb4RHeTqWKt83I8uh
         ipB4p8aovM+2J53w+Ghere+/cAEuNGhWIdLkKb+5hrdMeZWI+dOdeMj5cCCQNAl8LfV5
         vBZW3Gb6wFeEx38IBhn/eqC97ZAtTGw0La9QbPaZpAnXJV10WeVnE7EMdhL3k4gCdFaZ
         QzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=BNgZyNR9g9I8cL/8kYFEhAhW0Tg8IwdiIKGKieeU8/c=;
        b=hi0FefKcD09wEFt49sVf6Tf0mUdvHgh3Un7xOpP213x/geKv3sALJMsUqRiJVqZWZV
         1o3zUsXvMuHvKBWpJCDsHgT01yNJCSBnGA07CJK32r1O0cWcaxXKwauN4OgXoR4a7itF
         Hl1KqpSz+LJdxZj+m+r2GYJHX/0WuKuxtwR4ijzBUVtyHA1WP1ci/8mLaKOc+loYPbja
         OoQ1FL4y23czsoozZC8fZvYjmxpiSO3EMfllNQxpYDMw0YGfzRCkJHLmTaOo/ECTueyM
         FGbTaEZxfWzh4fmZ7RSk7qKdAdZGOlLM2fKzcpBXJTMbzchZFtqGO3aBDFi2p70krc6e
         lyPw==
X-Gm-Message-State: APjAAAXbhJfKt2nwlgoQDRYJKZpXaCMw6igIT8SPQtL8qgxdcm2Oujhk
        EDSAOfKhI9PXx5bJTxPiNYFmcH5Mb9CQRQ==
X-Google-Smtp-Source: APXvYqwAzbTKEsygaZSFy/vePtrF4ZK5YNQD2QFA5CxAjZZGWPNa3lIho5OBDia2qKWKeWqREXiNBw==
X-Received: by 2002:a2e:9e16:: with SMTP id e22mr1734301ljk.220.1579094808619;
        Wed, 15 Jan 2020 05:26:48 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id i4sm9188330ljg.102.2020.01.15.05.26.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jan 2020 05:26:47 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Mitchell <ml@embed.me.uk>
Subject: Re: [PATCH v2] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
In-Reply-To: <c2dd753e-d891-72f0-409e-5f23e5f170f0@synopsys.com>
References: <38a93a8deedd76dbc22bb1e41b4fc998f3750c95.1576516371.git.hminas@synopsys.com> <c2dd753e-d891-72f0-409e-5f23e5f170f0@synopsys.com>
Date:   Wed, 15 Jan 2020 15:27:49 +0200
Message-ID: <87o8v46e96.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com> writes:
>> @@ -1768,16 +1771,17 @@ static int dwc2_hsotg_process_req_feature(struct=
 dwc2_hsotg *hsotg,
>>   				return -EINVAL;
>>=20=20=20
>>   			hsotg->test_mode =3D wIndex >> 8;
>> -			ret =3D dwc2_hsotg_send_reply(hsotg, ep0, NULL, 0);
>> -			if (ret) {
>> -				dev_err(hsotg->dev,
>> -					"%s: failed to send reply\n", __func__);
>> -				return ret;
>> -			}
>>   			break;
>>   		default:
>>   			return -ENOENT;
>>   		}
>> +
>> +		ret =3D dwc2_hsotg_send_reply(hsotg, ep0, NULL, 0);
>> +		if (ret) {
>> +			dev_err(hsotg->dev,
>> +				"%s: failed to send reply\n", __func__);
>> +			return ret;
>> +		}
>>   		break;
>>=20=20=20
>>   	case USB_RECIP_ENDPOINT:
>>=20
>
> What about this patch?

See:

https://lore.kernel.org/linux-usb/875zhd6pw0.fsf@kernel.org/T/#u

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4fE1UACgkQzL64meEa
mQaSxA//TyJxirXjEnLVly2oMv56uZrZo7CWHCb2M5EDTwonJi7oMHpFTeM50R6+
o0tz+TWvWNJge+iD9He5At8Oi/yoWI5ddo8k5f6Dct3aw8i5E0eiUPG9mnC62dNI
aOaYzGzQKPm4cLo3g60Sxz9Xy1t9SbM63ncnHnmhIRpZrhQ72K4ac8tbzYzGdkJk
TOWcJzJMpKBvzb6542onwvRuyUUZ9cmhPS2j9d5GCJVnmXmnBzoO6j4usvRNzNzR
k/P3P9xlVFa7eheXyFMA+uYVtOuuRywcqvB/qZikatE0m1lESwLkpM3Y05BAoSVu
7cnguuW0rhBZnqmevY1+KbhYodCSu3vIs9bVdzY7mAOtkO8eo1+x47yIrLYU1FDD
Qm+s0kd5cVRoeB5G+mBp9HcdiaVImsTR6z/3q1f7uQC3E42y3fnjZUcWEUDL9P2v
7gDiJvuNx4ZUkPG/EWQy4ZS6AnJGSgIcDl5KjHEAIOsDAh6JcMtoZ1x4x07m6ns4
wzqz2MOT9qeiZcKboJZ1OJ8X9A5a0FvB6vi8mkE2E1zM90yJ5pb+0fFtmILYr4IS
Ynrqj7EZ2qL0RPtEN/l3am197dk8ApRu+slRRvaB9DF5J0hKt4pJp67utBLbL6tT
TniB1nyB5Wa4N7P4zPhJRe5429upeiZT3trpqCFsztsvuOKQtCE=
=rpJN
-----END PGP SIGNATURE-----
--=-=-=--
