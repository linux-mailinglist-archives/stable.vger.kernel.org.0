Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF9622B90
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKIMb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiKIMbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:31:51 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568932528D
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:31:50 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n191so13746612iod.13
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 04:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QdeHWvDtThEWy0ecJxyjPz0+oqNqvgj2ge0f1LKWqus=;
        b=FAtT5MLB+T5TZXE5zkqmK56XbMWWFmz7jxWAdwlRvikt8DzCogT0sGH2+S2cW5tF3D
         FQu2iBtBiacDexjeTrj+1eNeKjmcL6A1rN2vyKyx7R+721R6fh66J5sqPx/bgdf/7uJj
         iksinP43A0DC+SuHkXXytEs8J4xUJNp/sBRYeMPdi2g7WpujoPDtXHPYQ6ZdB9OUykdU
         iDyzfz3qxSONtSgzU83T77E9tSudXkXaU1cfYDixULckxfOQ+0y/boB6BOHVrUzcCLQE
         nFA8YFnvkl/2P8w5uxyySqmrD85KjRenZSUVpeLC1+DkTjvf6NfZtZLHKztbbFHWjXDX
         nSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QdeHWvDtThEWy0ecJxyjPz0+oqNqvgj2ge0f1LKWqus=;
        b=0DLDxTbrOz7td3sRIkWV+m6gzZYZXixF6Pd6uhtMUwZZpkQTF0Wxss86lKPg+nMIHX
         ef8KOb8c5SFzv/FwNUc1DJN9fomZd0w9InmQDGkypJAkND/HWKt1CrTqa3UCOxjKnzYm
         eGC+wVVwVHU2X2cPpkr3pT3n/N/jb/rOYIubCt1Fw1wAKk938rMbbqLJTKIJJq3j9YqQ
         u4CX7ozbhGA2+fCZd3yHmdFAROwr/dtT4UJ5whMPjsqea1lirzQ7Onjy736FCiRwBXyj
         Ryg3VgVuAdNSOcZzscA3ZM+F5k81L0PIysZVgr3rNe3I7zma8EWALwcj1wztJ+jaQD6O
         ObQg==
X-Gm-Message-State: ACrzQf2MXCCh/N02uL95k2vk3EI0+uCIyUkJd6a5QE1y02Xd0GydyqMn
        Umgx95JHXL2Mr+ckQuwYj0WWqHSNXz98xYaQvea0Cw==
X-Google-Smtp-Source: AMsMyM6WIgbhPIffuYu2nJXpggadzifpgyzIo1PIr7J3wDOGwa3zOo4GgX76HqJHmnHwI5hSbwgqXzoHrOwPzI5/tCQ=
X-Received: by 2002:a6b:8dcd:0:b0:6d3:c9df:bc7d with SMTP id
 p196-20020a6b8dcd000000b006d3c9dfbc7dmr1645703iod.142.1667997109467; Wed, 09
 Nov 2022 04:31:49 -0800 (PST)
MIME-Version: 1.0
References: <20221027090342.38928-1-ndumazet@google.com> <Y2uPIItkmcYgDy6k@kroah.com>
In-Reply-To: <Y2uPIItkmcYgDy6k@kroah.com>
From:   Nicolas Dumazet <ndumazet@google.com>
Date:   Wed, 9 Nov 2022 13:31:33 +0100
Message-ID: <CANZQvtgQyATwCyomGqtdOhthnkVc4_jEHY_U-s1x4u4kp5YKow@mail.gmail.com>
Subject: Re: [PATCH v2] usb: add NO_LPM quirk for Realforce 87U Keyboard
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        Petar Kostic <petar@kostic.dev>,
        Oliver Neukum <oneukum@suse.com>, Ole Ernst <olebowle@gmx.com>,
        Hannu Hartikainen <hannu@hrtk.in>,
        Jimmy Wang <wangjm221@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000393c9205ed08d7d6"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000393c9205ed08d7d6
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 9, 2022 at 12:29 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Oct 27, 2022 at 11:03:42AM +0200, Nicolas Dumazet wrote:
> > Before adding this quirk, this (mechanical keyboard) device would not be
> > recognized, logging:
> >
> >   new full-speed USB device number 56 using xhci_hcd
> >   unable to read config index 0 descriptor/start: -32
> >   chopping to 0 config(s)
> >
> > It would take dozens of plugging/unpuggling cycles for the keyboard to
> > be recognized. Keyboard seems to simply work after applying this quirk.
> >
> > This issue had been reported by users in two places already ([1], [2])
> > but nobody tried upstreaming a patch yet. After testing I believe their
> > suggested fix (DELAY_INIT + NO_LPM + DEVICE_QUALIFIER) was probably a
> > little overkill. I assume this particular combination was tested because
> > it had been previously suggested in [3], but only NO_LPM seems
> > sufficient for this device.
> >
> > [1]: https://qiita.com/float168/items/fed43d540c8e2201b543
> > [2]: https://blog.kostic.dev/posts/making-the-realforce-87ub-work-with-usb30-on-Ubuntu/
> > [3]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1678477
> >
> > ---
> > Changes in v2:
> >   - add the entry to the right location (sorting entries by
> >     vendor/device id).
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Nicolas Dumazet <ndumazet@google.com>
> > ---
>
> By putting your s-o-b below the --- line, tools will drop it, how did
> you test this?
>
> Put the v2 stuff below the --- line, don't add a new one.  See the
> thousands of examples on the list for how to do this correctly (as well
> as the kernel documentation.)
>
> Can you fix this up and resend a v3 please?

Duh -- apologies for this rookie mistake. v3 sent your way.

>
> thanks,
>
> greg k-h

--000000000000393c9205ed08d7d6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPnwYJKoZIhvcNAQcCoIIPkDCCD4wCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz5MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
3THKPWAG9jcUnLFr5tdwMEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQCMAAwgZoGCCsG
AQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9jYS9n
c2F0bGFzcjNzbWltZWNhMjAyMDBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3J0MB8GA1UdIwQYMBaAFHzMCmjXouse
LHIb0c1dlW+N+/JjMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20v
Y2EvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQBMchz/m9DAzkDk
6JtxR1Ns3Ux0kJZKyIxCFNDOJpN4XUGpRlddEC/cWrtsX1AR5872/c9DekBJ9gQ7eZVBDR5VReKg
tpG21RU7CCXjAwBDtfLz+nkGxnuq1XJef2OwL1/Rr2xXJ+nraZV7EcpNW92RNDsKzTWI8kmsXyK9
XDDJDhNvFcAO3K4lbACkuxCfrE9tzdp9uG2Y/1aDALr2r8XZi9uiMb0js2p08tT7cCgh+WLF8pDP
Ng5Bs1uZYJrY+Lrgg0GsQFiFpBI/e0m8VwvFbDUEexpaPEWdBYP53cVDFD/R6kVj+rHiAI57DZ9k
0Bk/2Ylow6FBQrPzcK2D4OqEMYICajCCAmYCAQEwaDBUMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
R2xvYmFsU2lnbiBudi1zYTEqMCgGA1UEAxMhR2xvYmFsU2lnbiBBdGxhcyBSMyBTTUlNRSBDQSAy
MDIwAhABkqWti5VJYTIDwUw2I1HaMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCBQ
fpQpYfZbbo1wpniBg4s2UfVKvPxwolh+YB7qdTTZPTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMjExMDkxMjMxNDlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsG
CSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAV13+bwDT2rk+8lHF88lw
q5lpgmkVVYJrOFtusMH6rV7gIIHS1yGDhN+0r75sAYX0+CWlEiLCadV7tAGvgJsRkstNIql9SV0Q
ZIcp6cGSAfgtqH1Iji3WqJdiNItRhmMZNfbDWS/IwTMAsmumGGbQ7NQdKFYgMSGMTSUlLA1HC5E+
PAx2I7PwXzLKm6V3715mJifSkPXGIggwhIqcdsdXPQvDWezjB/ipjazI0QomJxthUmY+fR+UZGch
MFqNreSaQDVcA0/6R4+C3GgBqjzGoP1AtjMvm8hm2J+m0h4yfWMu9gWL9IbdpjdsdVVtHqL0hNSK
FDs6b3dE6mQzy6tYHw==
--000000000000393c9205ed08d7d6--
