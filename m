Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F83114EAD
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 11:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfLFKEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 05:04:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42379 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726070AbfLFKEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 05:04:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575626672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgnlzYKY1pFjNDboGEtQCPK9Swg2wnly8q0hWXylDHw=;
        b=B/4cVNYIG4LoC2FnDyPPjQTlBgNcp3Y7YoWOAmZeyPyYOs4qlqw3/ZpdIhtVNLt/JzwpRB
        /hHCAJ2orVhflOMLEAz8KrlO5FJeLBcj447QM/pB0XQmhl0rENyUDCIkXDRLh//G0mPzbI
        Ego4nmB0yh/s4BF/LovWJG29lzxXl00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-oygkoRwHNyOe1GOdZnBtvw-1; Fri, 06 Dec 2019 05:04:31 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 424ED800D54;
        Fri,  6 Dec 2019 10:04:28 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C388710013D9;
        Fri,  6 Dec 2019 10:04:26 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 0EE3B16E18; Fri,  6 Dec 2019 11:04:26 +0100 (CET)
Date:   Fri, 6 Dec 2019 11:04:26 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     john.p.donnelly@oracle.com, daniel.vetter@ffwll.ch,
        airlied@redhat.com, dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Sam Ravnborg <sam@ravnborg.org>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?utf-8?B?Sm9zw6k=?= Roberto de Souza <jose.souza@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Noralf =?utf-8?Q?Tr=C3=B8nnes?= <noralf@tronnes.org>
Subject: Re: [PATCH] drm/mgag200: Flag all G200 SE A machines as broken wrt
 <startadd>
Message-ID: <20191206100426.anifpqwckuutxxt4@sirius.home.kraxel.org>
References: <20191206081901.9938-1-tzimmermann@suse.de>
MIME-Version: 1.0
In-Reply-To: <20191206081901.9938-1-tzimmermann@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: oygkoRwHNyOe1GOdZnBtvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Several MGA G200 SE machines don't respect the value of the startadd
> register field. After more feedback on affected machines, neither PCI
> subvendor ID nor the internal ID seem to hint towards the bug. All
> affected machines have a PCI ID of 0x0522 (i.e., G200 SE A). It was
> decided to flag all G200 SE A machines as broken.

> -=09{ PCI_VENDOR_ID_MATROX, 0x522, PCI_VENDOR_ID_SUN, 0x4852, 0, 0,
> +=09{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>  =09=09G200_SE_A | MGAG200_FLAG_HW_BUG_NO_STARTADD},
> -=09{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0, G200_SE_=
A },

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

cheers,
  Gerd

