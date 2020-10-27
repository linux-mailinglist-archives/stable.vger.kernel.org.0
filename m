Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3484729A7B8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 10:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509823AbgJ0JYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 05:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509822AbgJ0JX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 05:23:59 -0400
Received: from saruman (88-113-213-94.elisa-laajakaista.fi [88.113.213.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E2A20829;
        Tue, 27 Oct 2020 09:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603790638;
        bh=k0q1UXQyIMVNWtmVhow0jpMDJ0XmJolwwLg8XgByQUg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UWF6aOhC4q0nsNt2300n7nUokiHRXjqrNCtWimEBvdk0KNDuCgoBjaOxMVuIC4plq
         8JeKxkI/G1EwQKZnPg6XKCDPDiunZ5JpcfK8EuHs+Kv7TYYdqtJsaYjSidnhC/KmzA
         Z3vOQRDLZojGT4Vbr1wWnXwS9Vi2CNnzZzXkfMrw=
From:   Felipe Balbi <balbi@kernel.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: configfs: Fix use-after-free issue with
 udc_name
In-Reply-To: <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
References: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
 <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
Date:   Tue, 27 Oct 2020 11:23:49 +0200
Message-ID: <87eelkc996.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Macpaul Lin <macpaul.lin@mediatek.com> writes:
> From: Eddie Hung <eddie.hung@mediatek.com>
>
> There is a use-after-free issue, if access udc_name
> in function gadget_dev_desc_UDC_store after another context
> free udc_name in function unregister_gadget.
>
> Context 1:
> gadget_dev_desc_UDC_store()->unregister_gadget()->
> free udc_name->set udc_name to NULL
>
> Context 2:
> gadget_dev_desc_UDC_show()-> access udc_name
>
> Call trace:
> dump_backtrace+0x0/0x340
> show_stack+0x14/0x1c
> dump_stack+0xe4/0x134
> print_address_description+0x78/0x478
> __kasan_report+0x270/0x2ec
> kasan_report+0x10/0x18
> __asan_report_load1_noabort+0x18/0x20
> string+0xf4/0x138
> vsnprintf+0x428/0x14d0
> sprintf+0xe4/0x12c
> gadget_dev_desc_UDC_show+0x54/0x64
> configfs_read_file+0x210/0x3a0
> __vfs_read+0xf0/0x49c
> vfs_read+0x130/0x2b4
> SyS_read+0x114/0x208
> el0_svc_naked+0x34/0x38
>
> Add mutex_lock to protect this kind of scenario.
>
> Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Reviewed-by: Peter Chen <peter.chen@nxp.com>
> Cc: stable@vger.kernel.org

patch doesn't apply:

$ patch -p1 --dry-run
/usr/bin/patch: **** Only garbage was found in the patch input.

Please resend using git send-email and make sure your smtp server sends
it as plain text, not base64.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl+X5yURHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZtZg//coyB3wE6OkS6Hlv+h19vVYx+t2brKcxC
g5bumXnlkQ9Alqu77kfPmqXkdtGtTTCIF/hM3WsrvfnHUaewkm2XpFpLfsL4grDQ
cI6VO1basL0cPUDsYYkVcujkTNNpQfAkQ1dcaUn7+Q7OM0uYMDI164AKENynlF+e
pJKHzeo5WJY+FETSac0fqwDoDBuPucHcx+dPjZH4QYCIyEmmCinzrp4CISOpjXCv
mu2n9Ix8CfuFbocuXtqHRZq/t7ZlmhPo9y2+hX1+F33oBRLx4L37/GdicJXWp+Rd
DeZCO5klDOnXheRXK/pyIPOMWrGCar2jyjw1EdqPvW34aabTb2Ms7NuH0u2LaOxu
AGUfuFXML/iWAnBuU1S/Gkjn7+hnZJiLJIV6EM380frH/dz7QXYUdjAlMnCp9qCY
grjypjGIW87GmF8IQS3G2Ip/Ique0rRt03ioUlG/4zq+OKiRaVXCFCvxOyARELmu
r/AlOo+fugXhAaJqcjIS2lYc0j6qp0NV27LVQDDFJI+dJzTXLbENIrxGacn/M0ll
JQnEA0iDmDWXQU1Dv+Lki4ezHg7NWNQSNDBqY/LjdymwtYQd8XcjKo/11Dlq4cpJ
TT72bdl7Rqg/Qm4JB/KWryxSdJlYzK1iLxZLsfuUD5w3I8AO5L+QRurTAhtZ2FT8
fVqBmJhM+/w=
=y0xX
-----END PGP SIGNATURE-----
--=-=-=--
