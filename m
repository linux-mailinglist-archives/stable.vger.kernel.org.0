Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A31C6224
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 22:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgEEUfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 16:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728512AbgEEUfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 16:35:47 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7585C061A10
        for <stable@vger.kernel.org>; Tue,  5 May 2020 13:35:46 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h26so3222678qtu.8
        for <stable@vger.kernel.org>; Tue, 05 May 2020 13:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gucw+xNvFuGxkaf7YhzJotzzLqpsyiATfWzq48O+kmM=;
        b=eTh4AJxtb2W+XCpyUMjVrZTZaLspYae2kjNhEPwzDGg7UlSiNtDWOF7hmSDXAENm9B
         N5wzfWYIzlEutMAWIFCOwA8cpOsXLzPdTCnbyYVCQpzRRRMOLtSVk9AQKIw08UGuAzt7
         CnXJgnh1vXpr/ymcHhiwjmyPRoEkfI5fxUkKqQtEAFQmJMWhBVOCME1v4e6kmAE5ONC1
         Oy0a97xhPenP+O+gRNs41Kz+UsvOdjazFB4NwDUBOxKuGD/pdiCyF/JGRWacZhDQNHgw
         HY2MAi6TMB70OtPSTJ9hCJv6US6kSsC+0BtupBVlvLvpVjWrC924VCqtKF7Spsbmy8tt
         w3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gucw+xNvFuGxkaf7YhzJotzzLqpsyiATfWzq48O+kmM=;
        b=TTlJYds1Y5m4jkh/FT9VP4Jlw9x755//72GmJnoQhol16jw3tsgWIz0cDC3wbPsOE5
         Wopu36Kjtq4cZ02CCSheJ9eDiCp1HwuGEF6TF/F/OTzf325o59saqXbRpOlEMg/Qgnoy
         HW/uGEvMW9nuQZoZaF5oE4/uLewJ8sUj25RVxrHT3pB3ks7vjHfAl+3vbub1TnY22txQ
         RbFRpPFzfRxRcTnzDphhaVYUXJo57N6DW0WpRufdF0biCl6DVblrFlOBAQS8n73aQqro
         C1T0/7wAzfpmwkiwc/acP11o6Ndu5cbdnfj/bg4hF8FcN+KkTqVfNygc299u/c+jytbr
         Gp9Q==
X-Gm-Message-State: AGi0PubfPV3MZsMdxVsA9l6PYwbxZERhBOa+VQJKlmAFEc2ewoVdCCTk
        S7ykyAjBFE+5D+0fXrPUNNax5PoxB5OgDY0Aq4pgFQ==
X-Google-Smtp-Source: APiQypL+7UscQbmRBHWrH8NdOndOCVOXNz1vyQHcPPi4an6UYcA0QN5lg2HueQHtrlZAnQ03coblSGKkUc7pWCJ5o1Y=
X-Received: by 2002:ac8:3488:: with SMTP id w8mr4874608qtb.378.1588710945678;
 Tue, 05 May 2020 13:35:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200505084049.1779243-1-rpenyaev@suse.de> <a9898eaefa85fa9c85e179ff162d5e8d@suse.de>
 <20200505130357.04566dee5501c3787105376f@linux-foundation.org>
In-Reply-To: <20200505130357.04566dee5501c3787105376f@linux-foundation.org>
From:   Khazhismel Kumykov <khazhy@google.com>
Date:   Tue, 5 May 2020 13:35:34 -0700
Message-ID: <CACGdZYKyVEA3vF8A6cq+gM5CtsRi4gcxyCyRazqpxjTgqcuZ2w@mail.gmail.com>
Subject: Re: [PATCH 1/1] epoll: call final ep_events_available() check under
 the lock
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Roman Penyaev <rpenyaev@suse.de>, Jason Baron <jbaron@akamai.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009b6f9f05a4ec97d2"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000009b6f9f05a4ec97d2
Content-Type: text/plain; charset="UTF-8"

On Tue, May 5, 2020 at 1:04 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 05 May 2020 10:42:05 +0200 Roman Penyaev <rpenyaev@suse.de> wrote:
>
> > May I ask you to remove "epoll: ensure ep_poll() doesn't miss wakeup
> > events" from your -mm queue? Jason lately found out that the patch
> > does not fully solve the problem and this one patch is a second
> > attempt to do things correctly in a different way (namely to do
> > the final check under the lock). Previous changes are not needed.
>
> Where do we stand with Khazhismel's "eventpoll: fix missing wakeup for
> ovflist in ep_poll_callback"?
>
> http://lkml.kernel.org/r/20200424190039.192373-1-khazhy@google.com
>

My understanding is - we need the ep_poll_callback fix on a logical
level (ovfllist was never triggering wakeup), and the two follow-ups
close races - in both how we add/remove from the wait queue, and how
we observe the ready list, which are needed if we only wake when we
add events, where before we were also waking when we were splicing
ovflist events when reading the ready list. As well, the first two
together are needed for epoll60 to pass in my testing.

Khazhy

--0000000000009b6f9f05a4ec97d2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPBgYJKoZIhvcNAQcCoIIO9zCCDvMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggxpMIIEkjCCA3qgAwIBAgINAewckktV4F6Q7sAtGDANBgkqhkiG9w0BAQsFADBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjAeFw0xODA2MjAwMDAwMDBaFw0yODA2MjAwMDAwMDBaMEsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSEwHwYDVQQDExhHbG9iYWxTaWduIFNNSU1FIENB
IDIwMTgwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCUeobu8FdB5oJg6Fz6SFf8YsPI
dNcq4rBSiSDAwqMNYbeTpRrINMBdWuPqVWaBX7WHYMsKQwCOvAF1b7rkD+ROo+CCTJo76EAY25Pp
jt7TYP/PxoLesLQ+Ld088+BeyZg9pQaf0VK4tn23fOCWbFWoM8hdnF86Mqn6xB6nLsxJcz4CUGJG
qAhC3iedFiCfZfsIp2RNyiUhzPAqalkrtD0bZQvCgi5aSNJseNyCysS1yA58OuxEyn2e9itZJE+O
sUeD8VFgz+nAYI5r/dmFEXu5d9npLvTTrSJjrEmw2/ynKn6r6ONueZnCfo6uLmP1SSglhI/SN7dy
L1rKUCU7R1MjAgMBAAGjggFyMIIBbjAOBgNVHQ8BAf8EBAMCAYYwJwYDVR0lBCAwHgYIKwYBBQUH
AwIGCCsGAQUFBwMEBggrBgEFBQcDCTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRMtwWJ
1lPNI0Ci6A94GuRtXEzs0jAfBgNVHSMEGDAWgBSP8Et/qC5FJK5NUPpjmove4t0bvDA+BggrBgEF
BQcBAQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9yb290cjMw
NgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIzLmNybDBn
BgNVHSAEYDBeMAsGCSsGAQQBoDIBKDAMBgorBgEEAaAyASgKMEEGCSsGAQQBoDIBXzA0MDIGCCsG
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
BQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wUQYIKwYBBQUHAQEE
RTBDMEEGCCsGAQUFBzAChjVodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3Nt
aW1lY2EyMDE4LmNydDAfBgNVHSMEGDAWgBRMtwWJ1lPNI0Ci6A94GuRtXEzs0jA/BgNVHR8EODA2
MDSgMqAwhi5odHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dzc21pbWVjYTIwMTguY3JsMA0G
CSqGSIb3DQEBCwUAA4IBAQCM37MMrUvgKBlbkfClP3kSaljmhqmtbhA855Dxg0ExJEaXMLDnSEod
BZm4+79Rcp/gCP67jOVlkJHRSTPco73qpOMg8Q9aXMbcysY/rm3bul1wpALN1dQh8STLYiDdNBXJ
LJZxf7nC3+xcLEb0+RTU05lUVCzmixKU665YZspUCQttLL7LxY8k7vpLtXeX7+OP6mxVsEOca9CI
fEybv+pk4+vHfIg3XiUK2Qs4qTHSFZ09OuPSRqkO1CY/AET8DPwXkO2ByN/gdUYo1po23haQT7kB
qhSVsP/BmQ7F6qER6f8mDR3F0uH26W4ZFxa/htst/Pb0qoQnkyDXLPSLJa9UMYICYTCCAl0CAQEw
XzBLMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEhMB8GA1UEAxMYR2xv
YmFsU2lnbiBTTUlNRSBDQSAyMDE4AhABiQs/r7YF6iuE/NQrZF28MA0GCWCGSAFlAwQCAQUAoIHU
MC8GCSqGSIb3DQEJBDEiBCCPB7JBGPWXEzvmI6+qkW04NwddgBWY9wJPycoyzBwfhzAYBgkqhkiG
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA1MDUyMDM1NDZaMGkGCSqGSIb3
DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcN
AwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAE
ggEAgXA7etQPygilhOlUl4xAgxL22LrJJp3gHd/uYUpJecNRkLIrQ/pF3kUE5Mbihx1QsJD7Lmi+
R940ZnPZxvPMG2UQ5j9VHWELETbJQK8KFr0Uz/wOEWooaMUT8RwTg42uX8xdhMyZy/abTNIeSbrm
wz5XvrAlgeDxHGJgW2ZnTvzWzVh74AF90lFUiHjzHZ+m6koU65RV+5cizgR+LvrEnvdfCyr2FlOM
EMba3dJOhXwOYN18sUclNma4/vlpGJHUiPvgewLRlvmX07WFgmLW1RpxhfK31pNS3b7fX8XQRj1p
ozNF6zhgngcsIsA+xgAeaPBD3MoyVNsWPTp9dDBzVg==
--0000000000009b6f9f05a4ec97d2--
