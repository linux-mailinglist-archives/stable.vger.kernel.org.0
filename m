Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AADB34D415
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhC2Pgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:36:52 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:39022 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbhC2Pgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:36:46 -0400
Date:   Mon, 29 Mar 2021 15:36:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1617032204;
        bh=rqe9EJEDo6OVkZ/VB+6sIQKNjLvmWP/qQQn0EH+cucE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=HpGWtcbSc1BRR8C//YNHRfRX94i3nWsb+pdd14v2BmpPVcvRhqxYDP65AyfHLnKBx
         XK25WeJ9dMffhERinc9teknCpK13ACInH5U3ioLVaZYq/382YcQL+NgpbJ7CuiZS9D
         l9GStvSS6LFR40V0tBF9/4vQST+o2u0wEAbj0bEbP197GtioRyahLzh5sn1mwWFSto
         WZ2Zw3bg5NhoBydcrl7qRc/Pr+PP2nniZGuVzjF/rDIplNm/gkalM7ynbXNfkWIRtU
         g0vavMPE3d9XV44tE1OrBuEeqFNrG2nKO1b4hPD8kyui51GNCIqEIrZLxmVQk2tRXE
         Ma+1ySXRmzdIQ==
To:     Paul Cercueil <paul@crapouillou.net>
From:   Simon Ser <contact@emersion.fr>
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary plane
Message-ID: <f_BApfXCctltkOAAKup7ZXRsq8N81SZgbxIEFbHWzeoKZCo8z169Bkk4DDwk9WmMNKXpyxaMQCxbWzwVMgfNav0ZYVf3s_6bXRO89LKD_AM=@emersion.fr>
In-Reply-To: <TTLQQQ.OCR65URAWJVQ2@crapouillou.net>
References: <20210327112214.10252-1-paul@crapouillou.net> <20210329140731.tvkfxic4fu47v3rz@gilmour> <BoDZUOZSsZmHjkYkjHPb18dMl_t_U8ldrh8jZezjkA6a2O-IBkPGaER4wxZ2KlqRYuXlWM8xZwPnvweWEAATzoX-yuBJnBzjGKD3oXNfh5Y=@emersion.fr> <TTLQQQ.OCR65URAWJVQ2@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, March 29th, 2021 at 5:32 PM, Paul Cercueil <paul@crapouillou.net=
> wrote:

> Making the second plane an overlay would break the ABI, which is never
> something I'm happy to do; but I'd prefer to do it now than later.

Yeah, I wonder if some user-space depends on this behavior somehow?

> I still have concerns about the user-space being "clever" enough to
> know it can disable the primary plane. Can e.g. wlroots handle that?

wlroots will always pick the first primary plane, and will never use
overlays. The plan is to use libliftoff [1] to make use of overlay
planes. libliftoff should already support the scenario you describe.

I think Weston supports that too.

[1]: https://github.com/emersion/libliftoff
