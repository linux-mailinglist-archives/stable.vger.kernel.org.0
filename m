Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474052293A8
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 10:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgGVIfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 04:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGVIfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 04:35:31 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB75FC0619DC;
        Wed, 22 Jul 2020 01:35:30 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j21so846683lfe.6;
        Wed, 22 Jul 2020 01:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=m0cslrJGydovPyO53eS2KxHEtjsODpHbA7i+KHpI3/c=;
        b=pTG9y9abllHPo58k0/xNjdNHEx7rHI7AEqsyUgbVtPXFkKgHGtmgXp0ySl1i95yTYN
         iigqbnSw6xffqB2Wlmi7GNyWIw+cyDO2X56ONNyySVRK8Ovtll2S9GqdY7DKc6oqIV20
         9Vzbg0f7mAG0akhAWPMhzZ6nRKqKW4V8PUTyJxzembfhyowGlTIbnW5uVwcJMfQHvikE
         8nZ4Lio0S+KvGceMc1VGmuTyJ4iu9gBfMoodZYexCkBIcO0voe5gyRuL2LW7X8Hk/F5c
         ZhN8EUT9htA9rjHC8DhEssSk0WheiS/jZ7/ggEvvxl+8wj5ZEawYyUYDYiqhji9rPcmJ
         CL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=m0cslrJGydovPyO53eS2KxHEtjsODpHbA7i+KHpI3/c=;
        b=HELquOm0sJfISDVGlJf4eKkVXLQ5+9yTmfpbpryrBxCFWGtaeqDQ96emCr/FPLA6dZ
         pdY/kPJlw023yx8mTskcVZlbhIiG34RMVamKWUXdJapNfvpOI2UEgYNidLm3jU52bfmE
         2ajHkwAzSGvK3x0/UfKPcRCO+O1+MTFZDyPEYwal2NMaLilRoLt41phFrj+32TEua1+r
         q9jGDuHMzItQKgi98MDWT2oKIi4koehg01kIymJXZE/crXMkwOuI8Ha6ydHDtUj4cjrh
         5+h4nu4AC3c9KSbqzDPstDlRHLvVCUlTJnBm7Gp9CiCkhvV7SXDVNlBhiEmBLon0XEtw
         Wz/Q==
X-Gm-Message-State: AOAM532kHh/BTez4pDxgKgURuJAGtQKZrV2T3aNIbN4LAYXRhNd9QgCF
        pCpYLAUs72nt4RoYVVmxT1qP9dIExHSzmg==
X-Google-Smtp-Source: ABdhPJy1rGcAM7U+Ak5kM+dM9X+47Bsc+6UQSgckl3Ca+9bnPT0E403R3xu/9Q7oUo3bdyjafsPdAQ==
X-Received: by 2002:a19:5c2:: with SMTP id 185mr9627484lff.38.1595406929051;
        Wed, 22 Jul 2020 01:35:29 -0700 (PDT)
Received: from saruman (91-155-214-58.elisa-laajakaista.fi. [91.155.214.58])
        by smtp.gmail.com with ESMTPSA id z12sm7586586lfh.61.2020.07.22.01.35.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jul 2020 01:35:28 -0700 (PDT)
From:   Felipe Balbi <balbi@kernel.org>
To:     Peter Chen <peter.chen@nxp.com>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint
In-Reply-To: <20200722030619.14344-1-peter.chen@nxp.com>
References: <20200722030619.14344-1-peter.chen@nxp.com>
Date:   Wed, 22 Jul 2020 11:35:23 +0300
Message-ID: <87zh7sne0k.fsf@kernel.org>
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

Peter Chen <peter.chen@nxp.com> writes:

> During the endpoint dequeue operation, it changes dequeued TRB
> as link TRB, when the endpoint is disabled and re-reabled, the
                                                 ^^^^^^^^^^
                                                 re-enabled?

I'll fix while applying

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl8X+kwACgkQzL64meEa
mQajAhAAi+vOGkzkBjwjAW875KPebN4mawejgYv+kzAghQ/ZSLXTWKZChsy5T5Vu
jRvemvLCjLQx6pexxFjD+Xem/jsb1ze/KFi13wX5q6M+74yqPivKMOGiXaJ4qhYi
Xoki12x52STKLd49FAKx8JK+/bEbI9r17uk/+t1ll5tASU+SNve6ZcVROAayXt3e
6ZxiPzRcEwFIRuvqGrXaF2Mm3y3mNVR2xQFoc9QbJNtgs7b7EzXPajhXQcMSaDA0
DdGRmKuyX7KPUo+ojMDdIfcpFOzFcMB743suDZKtqW0wBLXCUGzWEKCdGj8gxjIg
X06DEBsXcEl5D6AKNV4ghYQ8ks+V5nE1yBmB+FuhpFnDgTv36yKfOQ6ONfR7DMcu
AfC+Y0ZhtwXtoIOT/R81fqhkIM0juXYZJ/dUsNnl0qcFl7bHrKjW+kRM5oZnqFTX
rMgvcOOp3TcTFcckP/2D2FfcpDc8wrkdpZ5N8+sII2N6rfUkEN0yRliaeC8QP0yc
YT/d6hrxMPM8rH6N1xx6zW6dMo6xdVwJi2Za5SFIs5+C/rIXWSPhXywQRVZH/3In
e8zVbQap/PGuaUvIUmnK/GwxrUlo3LDAEDfAU0uiW5KLNQW9D0yT8zyGojw/kphD
64MzcXXsI2jkyAvnk74HLcLTXj+9ZD/DL2ZEtiezP9msM1aEzzk=
=Y//I
-----END PGP SIGNATURE-----
--=-=-=--
