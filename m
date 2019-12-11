Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4411C08E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLKX33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:29:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37905 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727043AbfLKX32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576106967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0i+XMsJFtYhtxBhdu2EW4dCVP37dPVo6eqPpiyrg98k=;
        b=BouRC/jHsteusw2io5wc66DlcC9AqHRW+kJh6bPt3K032eX5b5k/rks/AsrogYhr+MsYy1
        54NTsXuuh5ClpJ5J+O92K0gNTOHcwgq/4WXRWRHY5kMyJ/74PhWC4ZdtjoD8bM0jDY1XXn
        SAx+YvqOFI3EkCPgZCnFq90u9AykgKs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-qhTPL4hQN32UY6HJaBa8dg-1; Wed, 11 Dec 2019 18:29:24 -0500
X-MC-Unique: qhTPL4hQN32UY6HJaBa8dg-1
Received: by mail-wr1-f71.google.com with SMTP id l20so243866wrc.13
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 15:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=0i+XMsJFtYhtxBhdu2EW4dCVP37dPVo6eqPpiyrg98k=;
        b=et7SOr7Is5o0YjqxQi+8kvQfvTgxfzODFJW3zFGh4zPX2zODSzKcHhTr/7b5hSaRnM
         SktbBNe3hsW/L9Nmyi79NW1Prk/yQOlKVNm6dwjrwqOdDR/YcLS6eEtEUF/88OMv7hzQ
         WclXa3PSpsNgSthMwmenE99CKcfBvqeozLLUHU7dNFcba955kKnrz2TEYJCgmspWNF/x
         1g4WgubIx9dcxBft8G4KJ6xtoN+v3CheW5pY0jnfPkHXkHD++3yQMiZSt542pu3w4OBR
         MV9joR5wjg0TyvJewbJnDEtudUnNsRzXPQggKwkPYMBLAgYmFAoqDGecELqhshQ0Vxxt
         wV6g==
X-Gm-Message-State: APjAAAUys7Zz8hAy+QVp8W+bdQVoOU5ISwZGUAvJayfbU4rqoMbdetfE
        f5QDDSRbIVDvEgk0ucvKk7B+5q1evx0KMp2pK8yM1C/rli7bdFbB+6aAe02cwz1dsKc7KS+0q5x
        65iTgpObcqWkHF57z
X-Received: by 2002:a5d:6211:: with SMTP id y17mr2558145wru.344.1576106963228;
        Wed, 11 Dec 2019 15:29:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqwWsS0ih/51rSFF4d2cx4Nne4F6h3CdAazWfe5DQSNs6ci9a4+0zjXdvxKXHpznuY+jl5AzGg==
X-Received: by 2002:a5d:6211:: with SMTP id y17mr2558129wru.344.1576106963002;
        Wed, 11 Dec 2019 15:29:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id h17sm4035818wrs.18.2019.12.11.15.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 15:29:22 -0800 (PST)
Subject: Re: [stable] KVM: x86: fix out-of-bounds write in
 KVM_GET_EMULATED_CPUID (CVE-2019-19332)
To:     Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
References: <6be50392b6128f7cd654c342dc6157a97ccb3d8d.camel@decadent.org.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc8b829f-ca2d-5b8c-c880-567bab77a1c2@redhat.com>
Date:   Thu, 12 Dec 2019 00:29:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6be50392b6128f7cd654c342dc6157a97ccb3d8d.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ID0R9n6MbZGJxdq42gtEF88feYLCpVBb8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ID0R9n6MbZGJxdq42gtEF88feYLCpVBb8
Content-Type: multipart/mixed; boundary="opaPoe1iK5casvymZME4iwND7FjTTHJzq"

--opaPoe1iK5casvymZME4iwND7FjTTHJzq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/12/19 23:25, Ben Hutchings wrote:
> Please pick:
>=20
> commit 433f4ba1904100da65a311033f17a9bf586b287e
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Wed Dec 4 10:28:54 2019 +0100
>=20
>     KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-20=
19-19332)
>=20
> for all stable branches.
>=20
> Ben.
>=20

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


--opaPoe1iK5casvymZME4iwND7FjTTHJzq--

--ID0R9n6MbZGJxdq42gtEF88feYLCpVBb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl3xe9IACgkQv/vSX3jH
roOH3gf/ZRP3PefDkLnn4I7lp/CGvLTUBxgZw8XNNTwGOkoLRUMQXL9RGgseGeAb
ypzqGlYB2/ojE3X1p5vRhEqD51jiE+7Syb+6zVIocRKI9GyvQYGPpNZJPVOcTgfY
OcibLg4WCuVDYKUU7GQvK1tZpUphvSc0hcEmwIN/HeBoOk7DqqtMJeFoeZUn4Sac
ecNvx5RZiYPx23Qc1sCwIjb2nzfhexu5uOiabV3peGw6mEmjknKhqf44Rkgu8BZK
hfB5Zc6vSGwiDa/ch7qzOYOGSaZGrHwW/UAhUaS1fAm+Dth8Vol6ioGBJ5TPPvD+
zq+tI8oSVVD6K18os7/Q6bCJBmSTmw==
=udyk
-----END PGP SIGNATURE-----

--ID0R9n6MbZGJxdq42gtEF88feYLCpVBb8--

