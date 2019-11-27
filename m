Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6AB10B33B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 17:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfK0Q37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 11:29:59 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:36578 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfK0Q36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 11:29:58 -0500
Received: by mail-ua1-f67.google.com with SMTP id z9so7181514uan.3
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 08:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bcix32G0tgykSxIltBtEjuGiYBdfoRiMoTeeuu5U0cU=;
        b=Xw3n9URwQ+esLlizGMiw6j97bspLZyo3owETL0OIqUDmPLSLCTrX6KCjarc4G0bszb
         B4wwlIDd39vpU0f7ELzgls9oqL41GQecMpMIbokgDq9FABg0i1i7M45y3V28cscDscDg
         SqvlT4bdudzXTDrzi/kpzhyCnb/OTw+QVMIGgCkYVC1+8gNbcikmz9dVLNiGofs+XAuw
         zNTyNrJDiC+Q5Odaezj6RuEPmETXkFmluy9/V/OpY1pHPbP55GtkO9feZIxSfDvx81db
         stL7xnxsYv6N5azE08J++9p7N27lTLX6sTQYP8FcBKNB47YEE+n4o9qKCpPDBaw/53VV
         UDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bcix32G0tgykSxIltBtEjuGiYBdfoRiMoTeeuu5U0cU=;
        b=kTbx9yxzXDCfGXwd/hAcDdXyCdc/y95ka8A6AKaml7E6faBzPfR2S7Zo3N6XuYTX2f
         52BUWil9YI1UpEEJPT5ZA9u62kj7uVfsU8PPI7cs20PpyDa1UwKkwno8pQLaX+iiYrGD
         gaAVxxuUWKMVbL7KE31tfJ8skDhC2jWgcEuEGqQgBYjuNLc0E+qezAnFNGlJnwaeoReG
         yyVOsRgf6c7zX+thmlgkb69GKvwA/sTeRRb1U1c71z1t2M2gn41+KpncMZtsKEB6IyHG
         uAo7Ky0+KIm+2qXEBQjNaMOyAJhIM4jlw6ssF++aFuwZaIj5Ol56F22xnmIYfBFfJs2t
         YsrA==
X-Gm-Message-State: APjAAAV1nWcMPFCvuGzrIn4WtsQiX4iLPPSU0KrGj7yf86eMdhYBE/oh
        3EYt7ZVxoZ+8jbFckpGqQDKzevo2amnrQ7/f3jw=
X-Google-Smtp-Source: APXvYqwOreYScDS0yoAVjXch7dRpLUG6q4gRdUeSBZot2OVv0PNIF0JuStzljdZVmTc/RO1LKIIzkFTQfbMh7zG+teE=
X-Received: by 2002:ab0:28c9:: with SMTP id g9mr3467498uaq.46.1574872197870;
 Wed, 27 Nov 2019 08:29:57 -0800 (PST)
MIME-Version: 1.0
References: <20191126101529.20356-1-tzimmermann@suse.de> <20191126101529.20356-2-tzimmermann@suse.de>
In-Reply-To: <20191126101529.20356-2-tzimmermann@suse.de>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Wed, 27 Nov 2019 16:29:06 +0000
Message-ID: <CACvgo52_L9RRCh6rKBCqkCuBwmH40NPnGQkCtqpR-T1feKC_5w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] drm/mgag200: Extract device type from flags
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
        john.p.donnelly@oracle.com, Gerd Hoffmann <kraxel@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Jos=C3=A9_Roberto_de_Souza?= <jose.souza@intel.com>,
        "# 3.13+" <stable@vger.kernel.org>,
        Emil Velikov <emil.velikov@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

On Tue, 26 Nov 2019 at 10:15, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>
> Adds a conversion function that extracts the device type from the
> PCI id-table flags. Allows for storing additional information in the
> other flag bits.
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 81da87f63a1e ("drm: Replace drm_gem_vram_push_to_system() with kunmap + unpin")

Are you sure the fixes tag is correct? Neither the commit summary nor
the patch itself seems related to the changes below.

HTH
Emil
