Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5781D146280
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 08:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAWHXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 02:23:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43294 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWHXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 02:23:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so2034472ljm.10;
        Wed, 22 Jan 2020 23:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gDItKQODNCo3RItGu1dOVyk4407nhjcjRPWOwl5ZOSY=;
        b=Oaq2E/4zpGFCt/KRakEbVrU4qyRq6N2u9zZab0zGVl4LdK3zowHLnbHczXFu9tipby
         we/0TqqkEA40bFJ5wKL1cRLKbFT3mzyl+ASCC/FvUro3URHlS7j5epLkqsFKWJcijckU
         oZlFxbsg7AUU2NhQF82CzLWnYjym7UsfJqyu5A1QoZ6HS681cRy6eCM+O3lHgh9tLxXb
         y75s1ueIZDtaUvLX0mz1m9+IDvJGnimVdsgVta73PzHV6cj7Uw/4LrSchabqYR8bMere
         No3xmgQz4IsiRuTBIxuMa0j3jhan2qE4GyZfRQSkaUyHzxROoVMa1Qwmc1f6hlbHbQiU
         jGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=gDItKQODNCo3RItGu1dOVyk4407nhjcjRPWOwl5ZOSY=;
        b=Apt+uAeNpUzAckcxNYbuJ5jz7lcmxU/HQKTTT4hDl8UU5VuIuWFW7DA6+j9miAe6ya
         597y7L91YfE7K87nEphFpHgAA3aAnRqonEU7RnpdQZT4DOsNmGS5Quw7ZQ+G5IOc3YEh
         Hf0DOyITsP/2pqE1cuE4OHuK2F0PJ0rn0wz7KwnVNbLBvchXd5JOVjSgh+8pgv/+g4mD
         V/Fm/DgYF9fmnXbJ22fOoTzgRxJLdPuMk1m/SherPXRuD6+PYvAFa3LTYBCR2hzZ5z83
         db99AaBdv5ACUTUQSkttkt67NcQd3tJjrSR5u+fqbMOlyo2ZmRIT9JEBNLQYa51kTMAV
         G7JQ==
X-Gm-Message-State: APjAAAXP7sVrwUwQ7zd1v0kj4c3ZDggSbnrZ9O21imNp4ml0ydnvb/K8
        xF1CnL9CPQOml1peFo8u/6o=
X-Google-Smtp-Source: APXvYqyCcm21ptR/gV7N5UyDN/60CxAedcvdaOjjjZP/JU0Hp3CjJXKL8y1aL9t5JzLZJofMsliRTQ==
X-Received: by 2002:a2e:8603:: with SMTP id a3mr21337802lji.210.1579764208666;
        Wed, 22 Jan 2020 23:23:28 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id k1sm604109lji.43.2020.01.22.23.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jan 2020 23:23:27 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 1/2] usb: dwc3: gadget: Check for IOC/LST bit in both event->status and TRB->ctrl fields
In-Reply-To: <20200122222645.38805-2-john.stultz@linaro.org>
References: <20200122222645.38805-1-john.stultz@linaro.org> <20200122222645.38805-2-john.stultz@linaro.org>
Date:   Thu, 23 Jan 2020 09:24:17 +0200
Message-ID: <87tv4m4ov2.fsf@kernel.org>
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

John Stultz <john.stultz@linaro.org> writes:

> From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>
> The present code in dwc3_gadget_ep_reclaim_completed_trb() will check
> for IOC/LST bit in the event->status and returns if IOC/LST bit is
> set. This logic doesn't work if multiple TRBs are queued per
> request and the IOC/LST bit is set on the last TRB of that request.
> Consider an example where a queued request has multiple queued TRBs
> and IOC/LST bit is set only for the last TRB. In this case, the Core
> generates XferComplete/XferInProgress events only for the last TRB
> (since IOC/LST are set only for the last TRB). As per the logic in
> dwc3_gadget_ep_reclaim_completed_trb() event->status is checked for
> IOC/LST bit and returns on the first TRB. This makes the remaining
> TRBs left unhandled.
> To aviod this, changed the code to check for IOC/LST bits in both
     avoid

> event->status & TRB->ctrl. This patch does the same.

We don't need to check both. It's very likely that checking the TRB is
enough.

> At a practical level, this patch resolves USB transfer stalls seen
> with adb on dwc3 based HiKey960 after functionfs gadget added
> scatter-gather support around v4.20.

Right, I remember asking for tracepoint data showing this problem
happening. It's the best way to figure out what's really going on.

Before we accept these two patches, could you collect dwc3 tracepoint
data and share here?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4pSiEACgkQzL64meEa
mQZYGA//d2Ww8m08gOCrieOfXT+35bsGS2RrQfTLzF0DAHJV2hrTVtRoJMpZwRwu
6MECo4hpg+smuTY0Xgj0QwZCQLUKCdLHetmTd+EC8cyPjGFnt24XxxXIpfyG+y4E
OZuUEngwW3PVkcBbg3WwIfWVPGQ4tEpf9Q/nwCKUSFEj/djTdOuLl8DlgHvC9oq3
lsBdNIkIvjRzpjUpXUIvQbgrxgrJAJ4EHAqoUO+1djmaOcCj+HNRhSFWKTGUjbjl
xsKprp2ZjZH088ebQbrbmqFbKk0+Yw9krSc+BHK2ZIMZJFMKLoNtL6Th/X4qVpu/
quAHCskQYrv/PlmJsteBfSpCimz3R4iYyCQdjWLkld8ESAnDnuWst4p7o7Lvt3SQ
c9ZibfWrnP5NmbL4Ejh7O0LtEk+IAVdRCyFE2rxFfzwXVGrBtxKJv/I3GUc6Mn3F
ZiE8U96hjjM9hDSoZ95AySYEZM5vAblbdR938ZJPlbEZLz16XpBlFvaTlGiuyGlg
esqPEmFUlKnlv5FgK13avIdz4GGUpUXQdR7cQs41BaWoa+gKPmMKg3m0c35naiTf
84QTLsgXNwSGo5w9vpNQ04ris1pDxPk5m8afm59to6soaxfb2fjhRhXumSN80cuK
KZxKs54yC44wiNHkotOyrG/x2wRhjqyvvWpQ8yynx72rZwpkytA=
=IQai
-----END PGP SIGNATURE-----
--=-=-=--
