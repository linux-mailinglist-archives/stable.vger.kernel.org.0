Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925752545A0
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 15:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgH0NFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 09:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgH0NE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 09:04:59 -0400
Received: from saruman (91-155-214-58.elisa-laajakaista.fi [91.155.214.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9BD22CB2;
        Thu, 27 Aug 2020 13:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598533434;
        bh=Bi9r01y/oAwP2vlIGYEvJd0db7VUaWRQRZh/kykfMJk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=EKheZYsk+i9D/SZWLSwwwgH5/wMI9ndeycv8LzX2TwhOCzJKdQ4c1PxaolOoO5qcj
         bqiw9EnLZFDZHlGopD7a7/SyhwivnFqCm2EUXSHr/E1FZ3zXuuf1bvhXiJmwxGKgZO
         xB9vsq9i2/TByOTvUuFhNH6l3GyNUtViwepcmJtc=
From:   Felipe Balbi <balbi@kernel.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] usb: mtu3: fix panic in mtu3_gadget_stop()
In-Reply-To: <1598520178-17301-1-git-send-email-macpaul.lin@mediatek.com>
References: <1596185878-24360-1-git-send-email-macpaul.lin@mediatek.com>
 <1598520178-17301-1-git-send-email-macpaul.lin@mediatek.com>
Date:   Thu, 27 Aug 2020 16:03:46 +0300
Message-ID: <87pn7ci6kt.fsf@kernel.org>
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

Macpaul Lin <macpaul.lin@mediatek.com> writes:

> This patch fixes a possible issue when mtu3_gadget_stop()
> already assigned NULL to mtu->gadget_driver during mtu_gadget_disconnect(=
).
>
> [<ffffff9008161974>] notifier_call_chain+0xa4/0x128
> [<ffffff9008161fd4>] __atomic_notifier_call_chain+0x84/0x138
> [<ffffff9008162ec0>] notify_die+0xb0/0x120
> [<ffffff900809e340>] die+0x1f8/0x5d0
> [<ffffff90080d03b4>] __do_kernel_fault+0x19c/0x280
> [<ffffff90080d04dc>] do_bad_area+0x44/0x140
> [<ffffff90080d0f9c>] do_translation_fault+0x4c/0x90
> [<ffffff9008080a78>] do_mem_abort+0xb8/0x258
> [<ffffff90080849d0>] el1_da+0x24/0x3c
> [<ffffff9009bde01c>] mtu3_gadget_disconnect+0xac/0x128
> [<ffffff9009bd576c>] mtu3_irq+0x34c/0xc18
> [<ffffff90082ac03c>] __handle_irq_event_percpu+0x2ac/0xcd0
> [<ffffff90082acae0>] handle_irq_event_percpu+0x80/0x138
> [<ffffff90082acc44>] handle_irq_event+0xac/0x148
> [<ffffff90082b71cc>] handle_fasteoi_irq+0x234/0x568
> [<ffffff90082a8708>] generic_handle_irq+0x48/0x68
> [<ffffff90082a96ac>] __handle_domain_irq+0x264/0x1740
> [<ffffff90080819f4>] gic_handle_irq+0x14c/0x250
> [<ffffff9008084cec>] el1_irq+0xec/0x194
> [<ffffff90085b985c>] dma_pool_alloc+0x6e4/0xae0
> [<ffffff9008d7f890>] cmdq_mbox_pool_alloc_impl+0xb0/0x238
> [<ffffff9008d80904>] cmdq_pkt_alloc_buf+0x2dc/0x7c0
> [<ffffff9008d80f60>] cmdq_pkt_add_cmd_buffer+0x178/0x270
> [<ffffff9008d82320>] cmdq_pkt_perf_begin+0x108/0x148
> [<ffffff9008d824d8>] cmdq_pkt_create+0x178/0x1f0
> [<ffffff9008f96230>] mtk_crtc_config_default_path+0x328/0x7a0
> [<ffffff90090246cc>] mtk_drm_idlemgr_kick+0xa6c/0x1460
> [<ffffff9008f9bbb4>] mtk_drm_crtc_atomic_begin+0x1a4/0x1a68
> [<ffffff9008e8df9c>] drm_atomic_helper_commit_planes+0x154/0x878
> [<ffffff9008f2fb70>] mtk_atomic_complete.isra.16+0xe80/0x19c8
> [<ffffff9008f30910>] mtk_atomic_commit+0x258/0x898
> [<ffffff9008ef142c>] drm_atomic_commit+0xcc/0x108
> [<ffffff9008ef7cf0>] drm_mode_atomic_ioctl+0x1c20/0x2580
> [<ffffff9008ebc768>] drm_ioctl_kernel+0x118/0x1b0
> [<ffffff9008ebcde8>] drm_ioctl+0x5c0/0x920
> [<ffffff900863b030>] do_vfs_ioctl+0x188/0x1820
> [<ffffff900863c754>] SyS_ioctl+0x8c/0xa0
>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Cc: stable@vger.kernel.org

missing a Fixes: line here

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl9HrzIRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZO7xAAm9sZr6+KnTpU/DKiIVja1ris7ncWwhNs
bxcz1Idubfaxfe+v/+u66DxuOhBSuJhvUo3jXEZdvvKIP7iEpU6Ei2VuCN3d6Shu
uImPZhqqio4JQVBAGDE5YOdLEQQt9tnJL0fH2MnE6IdaLSPuU9/FFtz6oa8iZrFa
JJqbs6iiJsgQUUJIO59Rh1eNJNAX4oU+aIKYjjU6zefSUIEJ+tGnYfjP14bCIZaN
lB90TrO96W26M65sZq1C16aF8+m6FWEqxB8vJDx9csJT1muiki1Gal4TB2X7+94v
bbJcZsOZQlsYeT9YXOxkxJcavVuByyH28W7HdjLEe8YIs21vSwla7L1YFrt9dNP6
7pzCsvnecuQtGRZACDFn5fPSQ12wLGlw0Tm1ViI6YLtZshfWWFeKYufk6cIHiksD
PILbl4ulERm2+GhEtJX2k9h4EypKjEmzsjdzzi+/CqF22qWphqP9IIwXClQ3ZOU1
RrM0M1eIR4UBW4pPUeOxAX1evZHmMU0kS1MyAYwzzGwwk3foMrtQd4h5jt/G06+/
E6yIjFoMrtUGMxcFQr/fFQwMYG1BJByE5XsS1l8p2JS7CfH3b7CadfA6sGrDCRqF
QVj0EgD7JKgrpwjgAm8pnTkskZAxxSWyFNMiJyWRhKfhCjfv0pmjYIaeJJAXtK3j
nR/RQXhFEv4=
=iB0O
-----END PGP SIGNATURE-----
--=-=-=--
