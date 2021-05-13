Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4022037FB95
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 18:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhEMQge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 12:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhEMQge (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 12:36:34 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7048C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 09:35:23 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i4so35474447ybe.2
        for <stable@vger.kernel.org>; Thu, 13 May 2021 09:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TlRlP7YKH2QMXyR3xRYQiQ1jumOJCzW7hcQmt41t87A=;
        b=bmLhxktRxdupUSqvsOCBKj71FVJHf5rJVbZdyhR6/spfk+qUT3rUmlM9Pga3H6n/RG
         tKch7abtRAqgVSoBofpzCdzghtsM5oYqfOs2BdY8FTqu9BDSp9FDuFJ2BP0r86lOnN/U
         y0f/pNI2FVlhS4slS+bicWtwxD27oK7Xv9VFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TlRlP7YKH2QMXyR3xRYQiQ1jumOJCzW7hcQmt41t87A=;
        b=iX+wLacbBbKCNk/LZIf5YqHUGZZwYQtcIF0FslFZLWH3qxl8pZ0JCfOrisBg1OTMul
         fGxrVO56nAUtsWQLupax/p4FHemw+C9pvUtQO4Uc61pWmrOOfTrSsCyr0MSdlY81ZdvY
         XCv4KH/t6EkoS/G7Atw2xhgrrWW/DAnS0Z+XUaGjQWSlW3dM8kya9arDdos134OuPwtM
         fbyw3asiTWB4Ykkxent12R+8tnQ6kY93wEZg7ToDDoMKSioeotUZTZxk6R53JPMvICE9
         VyfVHMPQztvZcXZYpKwBR16ggkwzZ6D3egi1tHh7HwJmA+hjB2ssfjD0SM1uKvU85pt8
         pz2g==
X-Gm-Message-State: AOAM531GmeFFGNDh3Oj+oWzuQawPCWEro7fm3WBNKGf/4XwXEBQ2SMK6
        2odYwwMnxdx3cwAYZHDQoA1FzTncBPfnj7KrQSG+zM6eELeyJQ==
X-Google-Smtp-Source: ABdhPJzBZ5lHvlDZFTGY/aevZfeikG4DqZj0gCoefhwQJ63WrYtg357d9g8+mydl3lzJtJY8tjJhjTruJBJ4Dv20oy0=
X-Received: by 2002:a25:ae8e:: with SMTP id b14mr46685344ybj.148.1620923722811;
 Thu, 13 May 2021 09:35:22 -0700 (PDT)
MIME-Version: 1.0
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Thu, 13 May 2021 09:34:46 -0700
Message-ID: <CAKOOJTwPx5MTU=rjNmmBMD9u22AdSwgiGcf38C5Dj6064XEwaQ@mail.gmail.com>
Subject: RDMA/i40iw: Avoid panic when reading back the IRQ affinity hint
To:     stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Andrew Boyer <andrew.boyer@dell.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Henry Orosco <henry.orosco@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bc2c2405c238b6bf"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000bc2c2405c238b6bf
Content-Type: text/plain; charset="UTF-8"

Hello stable team,

Please consider adding the following upstream commit to the 4.14 stable series:

commit 43731753c4b7d832775cf6b2301dd0447a5a1851
Author: Andrew Boyer <andrew.boyer@dell.com>
Date:   Mon May 7 13:23:38 2018 -0400

RDMA/i40iw: Avoid panic when reading back the IRQ affinity hint

The current code sets an affinity hint with a cpumask_t stored on the
stack. This value can then be accessed through /proc/irq/*/affinity_hint/,
causing a segfault or returning corrupt data.

Move the cpumask_t into struct i40iw_msix_vector so it is available later.
...
...
...
Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
Signed-off-by: Andrew Boyer <andrew.boyer@dell.com>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>

Note, the fixes tag above appears to be incorrect. The problem was
introduced in:

commit e69c5093617afdbd2ab02c289d0adaac044dff66
Author: Henry Orosco <henry.orosco@intel.com>
Date:   Wed Nov 9 21:24:48 2016 -0600

i40iw: Use vector when creating CQs

Assign each CEQ vector to a different CPU when possible, then
when creating a CQ, use the vector for the CEQ id. This
allows completion work to be distributed over multiple cores.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Henry Orosco <henry.orosco@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>

Thus, affected kernels range from 4.10 to pre 4.17.

Regards,
Edwin Peer

--000000000000bc2c2405c238b6bf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
CdFrNJPZh3pPkCH0IKX6CImmyf+CyRknDRWPFgQvGmDe4kLDdPKXPTfXE0pGT27moNdaDiXvUvxt
XeKr13glJBx57n5ozOGoTKmI3V/0Pm+lfngViwIDAQABo4IB2DCCAdQwDgYDVR0PAQH/BAQDAgWg
MIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUFBzABhjVo
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMDBNBgNV
HSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2ln
bi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAiBgNVHREEGzAZ
gRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAW
gBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUoRyjOYXxPkXMBZPbsbAaSBKr4MEwDQYJ
KoZIhvcNAQELBQADggEBALIQiUvJC5+niEMS+nj0JKY9DdbREqHy2QyKJokwEbvuTemRjzzAad8x
oFtYsqkKca5WMV9A7zKalx2I2pRFK7xU5CwvSmNyfULHPxHb9B9KPuZ0htbtYptYPuygXLS5UrU6
nAO/qVpSFm11J9qSg2Tf6jN7yyAx/HLoM8uxnF3csFNBVyLssCrOJIkzQfRVgccOkm4EheBIXZZ+
/rXxlnHpIINzM6psnEe5UxvnwD6al47UBF9KswS5uyI2kJWzVw2/5iDRmJn6dhhWah3W8KDsTBl0
Ubfa6OVikUM8sf9aZkU2j4JEpaSTHAAj6fRPAgBYM1E4CbU2QeL/wpDwlI4xggJtMIICaQIBATBr
MFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9i
YWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwl1owS4QyKKm0xatYwDQYJYIZI
AWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKZSlMFEyI2iWqz8igEqB8Baa0sDn5zBWa/AYdtv
niQxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDUxMzE2MzUy
M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkq
hkiG9w0BAQEFAASCAQBR8eLDdnXl/5PX3ZALopobr8ffaL0xlSvPYEasDg3dcBs9Pfq+NuVRcvcR
C2z9/MMwi0pEOZEHy0G+HsHxG6RIdG/Jlk1gjLbEkJbWp/0FP9TgQyykCGKqZF+FUCYkxuEiY0nV
LdYTUBDnc/IsFDPMtIdoAI1xRQAQmgYR0WWvr6cSYfRgs8JK4Jv/Wox1tREH9HrJ/aV+zQs+54Pg
kpOeaQceYKJiLY3/tRizoNwPAMFIJjzvwhm3M5vcWSc7cX0c78v7NCUA88SnUPGZsPRwgAsZ0vDc
mZdMp1v+u6nNnA5GV1bfQvygZlXwvxlBPP4QVSVJOqmcuI0sE+crG4ik
--000000000000bc2c2405c238b6bf--
