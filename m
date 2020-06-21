Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E59202A88
	for <lists+stable@lfdr.de>; Sun, 21 Jun 2020 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgFUMpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 08:45:34 -0400
Received: from mout.web.de ([212.227.15.14]:46723 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbgFUMpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jun 2020 08:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592743513;
        bh=/0sroGrQnshfUEC3O2Ywl0S+MdJzfI+AJ4Ul0oeO1IA=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=OEJ+DPk8zJdfit9gtvaVodE3CjWfblMndc57LvPDwUGobsWy6uqFjRIj6FYKIeXcJ
         GeYcWl5UajHCTOFU5OGQFDdZcvqt4Za9B3jNICG5EuvB2Cyyj11sy2gbqtTKG2Uqak
         IqjKu885wx5EuHxT+PDTL3gwWDLgp20fmlz4GasA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.145.213]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LbOuI-1j2Q7v14uI-00kvGE; Sun, 21
 Jun 2020 14:45:13 +0200
To:     Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        linux-media@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6bed2d543cf7e48b822b@syzkaller.appspotmail.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] media: media-request: Fix crash according to a failed
 memory allocation
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <b39653f6-9587-4027-35ed-53d341845cb2@web.de>
Date:   Sun, 21 Jun 2020 14:45:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:46bp8riBqAnspdam8RlYisoTeAYmV8tRrTZeQVIx2tJ5wlm6Xin
 mAw8z0pokl4u2uofxE//X26XygVoDkWcs7u/navuE9Z4Z/NfRrWgAjbWPLoaUVc4pqJFxaU
 9s+ApwHtQNlgJwH5e21XcfHhbhcc1n+QIv6rrp7tLNkzHV5xYdSCVXLMBMROcwRtSL5SWNL
 OiK3HWB1bcGMMRLDVYbzQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:10cU/MadD7A=:1c8B2eoZE1bFz8E/h5eZtf
 a06Gr/ai70TeObfeMWOZYWiIE1DIqRlvzRxgFp/GMWD9eUiGWk8qcOFTS5qkaY8UGgUHkxteC
 lOBUNLMNcfHaSW2w0xG+gkU7Wt5KV9r5YYxbYyUtptdnFTUc9tWvEPRjzEilhl2D/l8Sd+Z19
 QBmN2LlDa5g1lM8vByPgS6MIpaZ9lEg65KV4UpbN9o+ZfuDq+3G+MNbD260bJIHCaRZ65rTuC
 7eWYPl4VB5b1gcgqHD3YLzrah+zeLoaKNmcCqXBa78L1W6e9YVxuJ9M7LZXWABBpHi7v4diBV
 Uzxbr34QdmS2RasME56pWBEdXCNUBF7keEP01RKaksNYacxZdWY/MzjzvIOS9YZN2SmWaaVbh
 RT/iskY/GMKUzHnDsQCQ1K15fVnpnIcES7EMRNRKqpwqwDq/+9BHpmidVgXVa0O8R1nHnihKy
 IezezJ+hK3uEL1Ny6thfJ2TRB6NIBLADwTJMCSDbakkVXqODD/sKpQYu8gZRO0Z/e1CeUTa7c
 ylsi7mOjkEN+9B/HVvP9GH5AtltjJHYhvb2lB/WE9yOPd0fs/jXUWMpqqULrwB0Z0CGMndBON
 vgI2IWxY2j8a3ALLhjdtwO6Yg7jx2emVk9XwwUBS8e88bKepPSqhsS/4LLWxMiaUZo2KgMxOW
 idIoXCoLXZG6YvH/hm4HhbZfINnaiPgepvzCT/QF7q0VyAhX0tyUcVZa2nrChySabpPDOqNFd
 vzh0mdvFoRwNxDhU5aHzdgwu8wg/UEPNqRdfMcok5stUvc91/XAzvxWLZbVvCLeu8ofFP7vsS
 eAt2w9ZcTn8t40cwROam93tqQKZRsK9frPk51kK6hQauo/MW7bUHwTZ3t2IRdNLtWWHYm7yWH
 4xCJixpu59qQpZUIdec7y8sAxBbzka49PN/Z2l77ouEZZweMeGisx5vkeBA41pWShpTl8ZAn2
 lbnhzQG0i6YF3GPAZvSvX7QEXNMWRSAr3jecy6A+2ryWmnLgsDPhBEokz6DmT3JQYwyOBj2f+
 CHGhrLl/ivsI9lhZC+pjIzwLboqYVn01c2G2VbxuIGeUlTG8fGevQbWJkLNeuREDJf0vnPefx
 uQZTYlVdprlPL3X33pxwXy3G1aM3trGFH/QyxSyUK0PPk2KpVelvNGff/Cn3h2mkxkEH5Ma21
 rARcoWRfUI7SmRRIGtQ1VnDFMiuSOJW8vy1ZoHSiKgPnAUEvlIMw1ntkh7ej6u/zC8LZeCH0+
 WpwiYBrDcBW/NVdlU
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> =E2=80=A6, reorder media_request_alloc() such that =E2=80=A6

Wording adjustments:
=E2=80=A6, reorder statements in the implementation of the function =E2=80=
=9Cmedia_request_alloc=E2=80=9D so that =E2=80=A6


> =E2=80=A6 the last step thus

=E2=80=A6 the last step.
Thus media_request_close() =E2=80=A6


Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?


=E2=80=A6
> +++ b/drivers/media/mc/mc-request.c
> @@ -296,9 +296,18 @@ int media_request_alloc(struct media_device *mdev, =
int *alloc_fd)
>  	if (WARN_ON(!mdev->ops->req_alloc ^ !mdev->ops->req_free))
>  		return -ENOMEM;
>
> +	if (mdev->ops->req_alloc)
> +		req =3D mdev->ops->req_alloc(mdev);
> +	else
> +		req =3D kzalloc(sizeof(*req), GFP_KERNEL);

How do you think about to use a conditional operator?

+	req =3D (mdev->ops->req_alloc
	       ? mdev->ops->req_alloc(mdev)
	       : kzalloc(sizeof(*req), GFP_KERNEL));


Regards,
Markus
