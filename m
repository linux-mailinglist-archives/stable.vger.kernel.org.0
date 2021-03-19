Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0236F342933
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 00:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhCSX5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 19:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhCSX4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 19:56:30 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D76C061760
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 16:56:30 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id d191so6256970wmd.2
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 16:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=E68Z9qdAJD/qGpbFLT/yIIqmWpjvQ3RSNWgCpTxieT8=;
        b=m/CBoo+jYaMnpUavn0NWnggHCFfsgBaWWeD0kG+/EI0G5l9Chzi1Gkbvu7lnW9cDu6
         Py/gkm7RJalEAPWVO4xfKOcQZAL/L2TWaI/RT/En+AcRfbo8fxQLUQs7ZuTBJRtgn0JD
         zZTLDBfehnLSQon7IwFepDfQDkAtJLbWNr0GSx2tKTG1r/E0BZO/8poWX32HbJBG2Rra
         D/SxjvgOtd6ZDci+CD8bZyai4/g9+jEZM8JXX+2mSRocnMu92+d4poOFOQE5/XnaDZCM
         BNue1f5bbd97sNRPXNa1SWVVs0kuQXmccg2D211VUAdKR0yV3iA5VlU2Cp4gcRX+UQMM
         h+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=E68Z9qdAJD/qGpbFLT/yIIqmWpjvQ3RSNWgCpTxieT8=;
        b=LSTgd1Md3r1R/QpvopLyb1w2eM+apNg0ZblUBf+N4Mow0svKBFgLkrKWHSUQS02Wzl
         fANr6qFFiVyjxyutPI3eD70MBriVws1GyW8PRADxlsY2J4FXe+vBEDl6hKXO/TTFaasN
         /9ZhOzx47hBhU+khqRzWIIfPdq8r+JVvelMHhaBq1RiXfRvjxR4Os+aGiDKkFWJjd1cZ
         2K39ilonv81a3fMR6EKXdSrYDTKlvrm+QBUj6mAXMGBqQfKdgeJ3oSGMkSMfoDJ1Uo77
         MmMwM8kwn1wtZpjs2y/FDFZ+GbdW36rrDYmQmoxAtXaFh6buBeaCB2SGbe3s+XGKyARn
         6Xww==
X-Gm-Message-State: AOAM532r1D63+FLXXVwFxouOZv4v9Ad8rJbIluwF0D090x3ygrbOHx12
        E2jwz4BIjZnf1dcksLD57lA0Lt/eI1tMah8Urhsq7zG/s3uyxzAZ
X-Google-Smtp-Source: ABdhPJxPzKCCxuSFSj+uZGqUotme0dSVpAsbltHLYl1JYntIYCnGM6rWbyW3abJLasvA7xcqriKMsqf+mtCVeW3GK88=
X-Received: by 2002:a1c:df8a:: with SMTP id w132mr5655961wmg.53.1616198188951;
 Fri, 19 Mar 2021 16:56:28 -0700 (PDT)
MIME-Version: 1.0
From:   Piotr Krysiuk <piotras@gmail.com>
Date:   Fri, 19 Mar 2021 23:56:18 +0000
Message-ID: <CAFzhf4qk9aFhhEtraUo0b9Si2y5taYDgdGwVZoSJ9Yj-59RGrw@mail.gmail.com>
Subject: bpf speculative execution fixes for 4.14.y
To:     gregkh@linuxfoundation.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000f0d7c905bdec76eb"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000f0d7c905bdec76eb
Content-Type: text/plain; charset="UTF-8"

I noticed that bpf speculative execution fixes are already queued for
4.14.y except for f232326f6966 ("bpf: Prohibit alu ops for pointer
types not defining ptr_limit").

It is important that for all patches from this series to be applied
together, so we avoid introducing a new vulnerability.

For the missing patch, I see conflicting lines in the context diffs
due to API change that apparently caused import to fail.

I'm attaching a copy of the patch that is backported to 4.14.y. The
only change comparing with version queued for newer version is that
"verbose" API does not take "env" parameter.

Please queue or let me know how to proceed.

Thanks,

Piotr

--000000000000f0d7c905bdec76eb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-bpf-Prohibit-alu-ops-for-pointer-types-not-defining-.patch"
Content-Disposition: attachment; 
	filename="0001-bpf-Prohibit-alu-ops-for-pointer-types-not-defining-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmgynwpg0>
X-Attachment-Id: f_kmgynwpg0

RnJvbSBmMjMyMzI2ZjY5NjZjZjJhMWQxZGI3YmM5MTdhNGNlNWY5ZjU1Zjc2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQaW90ciBLcnlzaXVrIDxwaW90cmFzQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAxNiBNYXIgMjAyMSAwOTo0NzowMiArMDEwMApTdWJqZWN0OiBicGY6IFByb2hpYml0
IGFsdSBvcHMgZm9yIHBvaW50ZXIgdHlwZXMgbm90IGRlZmluaW5nIHB0cl9saW1pdAoKRnJvbTog
UGlvdHIgS3J5c2l1ayA8cGlvdHJhc0BnbWFpbC5jb20+Cgpjb21taXQgZjIzMjMyNmY2OTY2Y2Yy
YTFkMWRiN2JjOTE3YTRjZTVmOWY1NWY3NiB1cHN0cmVhbS4KClRoZSBwdXJwb3NlIG9mIHRoaXMg
cGF0Y2ggaXMgdG8gc3RyZWFtbGluZSBlcnJvciBwcm9wYWdhdGlvbiBhbmQgaW4gcGFydGljdWxh
cgp0byBwcm9wYWdhdGUgcmV0cmlldmVfcHRyX2xpbWl0KCkgZXJyb3JzIGZvciBwb2ludGVyIHR5
cGVzIHRoYXQgYXJlIG5vdCBkZWZpbmluZwphIHB0cl9saW1pdCBzdWNoIHRoYXQgcmVnaXN0ZXIt
YmFzZWQgYWx1IG9wcyBhZ2FpbnN0IHRoZXNlIHR5cGVzIGNhbiBiZSByZWplY3RlZC4KClRoZSBt
YWluIHJhdGlvbmFsZSBpcyB0aGF0IGEgZ2FwIGhhcyBiZWVuIGlkZW50aWZpZWQgYnkgUGlvdHIg
aW4gdGhlIGV4aXN0aW5nCnByb3RlY3Rpb24gYWdhaW5zdCBzcGVjdWxhdGl2ZWx5IG91dC1vZi1i
b3VuZHMgbG9hZHMsIGZvciBleGFtcGxlLCBpbiBjYXNlIG9mCmN0eCBwb2ludGVycywgdW5wcml2
aWxlZ2VkIHByb2dyYW1zIGNhbiBzdGlsbCBwZXJmb3JtIHBvaW50ZXIgYXJpdGhtZXRpYy4gVGhp
cwpjYW4gYmUgYWJ1c2VkIHRvIGV4ZWN1dGUgc3BlY3VsYXRpdmVseSBvdXQtb2YtYm91bmRzIGxv
YWRzIHdpdGhvdXQgcmVzdHJpY3Rpb25zCmFuZCB0aHVzIGV4dHJhY3QgY29udGVudHMgb2Yga2Vy
bmVsIG1lbW9yeS4KCkZpeCB0aGlzIGJ5IHJlamVjdGluZyB1bnByaXZpbGVnZWQgcHJvZ3JhbXMg
dGhhdCBhdHRlbXB0IGFueSBwb2ludGVyIGFyaXRobWV0aWMKb24gdW5wcm90ZWN0ZWQgcG9pbnRl
ciB0eXBlcy4gVGhlIHR3byBhZmZlY3RlZCBvbmVzIGFyZSBwb2ludGVyIHRvIGN0eCBhcyB3ZWxs
CmFzIHBvaW50ZXIgdG8gbWFwLiBGaWVsZCBhY2Nlc3MgdG8gYSBtb2RpZmllZCBjdHgnIHBvaW50
ZXIgaXMgcmVqZWN0ZWQgYXQgYQpsYXRlciBwb2ludCBpbiB0aW1lIGluIHRoZSB2ZXJpZmllciwg
YW5kIDdjNjk2NzMyNjI2NyAoImJwZjogUGVybWl0IG1hcF9wdHIKYXJpdGhtZXRpYyB3aXRoIG9w
Y29kZSBhZGQgYW5kIG9mZnNldCAwIikgb25seSByZWxldmFudCBmb3Igcm9vdC1vbmx5IHVzZSBj
YXNlcy4KUmlzayBvZiB1bnByaXZpbGVnZWQgcHJvZ3JhbSBicmVha2FnZSBpcyBjb25zaWRlcmVk
IHZlcnkgbG93LgoKRml4ZXM6IDdjNjk2NzMyNjI2NyAoImJwZjogUGVybWl0IG1hcF9wdHIgYXJp
dGhtZXRpYyB3aXRoIG9wY29kZSBhZGQgYW5kIG9mZnNldCAwIikKRml4ZXM6IGIyMTU3Mzk5Y2M5
OCAoImJwZjogcHJldmVudCBvdXQtb2YtYm91bmRzIHNwZWN1bGF0aW9uIikKU2lnbmVkLW9mZi1i
eTogUGlvdHIgS3J5c2l1ayA8cGlvdHJhc0BnbWFpbC5jb20+CkNvLWRldmVsb3BlZC1ieTogRGFu
aWVsIEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4KU2lnbmVkLW9mZi1ieTogRGFuaWVs
IEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4KQWNrZWQtYnk6IEFsZXhlaSBTdGFyb3Zv
aXRvdiA8YXN0QGtlcm5lbC5vcmc+Ci0tLQoga2VybmVsL2JwZi92ZXJpZmllci5jIHwgMTYgKysr
KysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDYgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi92ZXJpZmllci5jIGIva2VybmVsL2JwZi92
ZXJpZmllci5jCmluZGV4IDQxOTJhOWU1NjY1NC4uMWM4Y2JlZjdjYzE0IDEwMDY0NAotLS0gYS9r
ZXJuZWwvYnBmL3ZlcmlmaWVyLmMKKysrIGIva2VybmVsL2JwZi92ZXJpZmllci5jCkBAIC01OTM0
LDYgKzU5MzQsNyBAQCBzdGF0aWMgaW50IHNhbml0aXplX3B0cl9hbHUoc3RydWN0IGJwZl92ZXJp
Zmllcl9lbnYgKmVudiwKIAl1MzIgYWx1X3N0YXRlLCBhbHVfbGltaXQ7CiAJc3RydWN0IGJwZl9y
ZWdfc3RhdGUgdG1wOwogCWJvb2wgcmV0OworCWludCBlcnI7CiAKIAlpZiAoY2FuX3NraXBfYWx1
X3Nhbml0YXRpb24oZW52LCBpbnNuKSkKIAkJcmV0dXJuIDA7CkBAIC01OTQ5LDEwICs1OTUwLDEz
IEBAIHN0YXRpYyBpbnQgc2FuaXRpemVfcHRyX2FsdShzdHJ1Y3QgYnBmX3ZlcmlmaWVyX2VudiAq
ZW52LAogCWFsdV9zdGF0ZSB8PSBwdHJfaXNfZHN0X3JlZyA/CiAJCSAgICAgQlBGX0FMVV9TQU5J
VElaRV9TUkMgOiBCUEZfQUxVX1NBTklUSVpFX0RTVDsKIAotCWlmIChyZXRyaWV2ZV9wdHJfbGlt
aXQocHRyX3JlZywgJmFsdV9saW1pdCwgb3Bjb2RlLCBvZmZfaXNfbmVnKSkKLQkJcmV0dXJuIDA7
Ci0JaWYgKHVwZGF0ZV9hbHVfc2FuaXRhdGlvbl9zdGF0ZShhdXgsIGFsdV9zdGF0ZSwgYWx1X2xp
bWl0KSkKLQkJcmV0dXJuIC1FQUNDRVM7CisJZXJyID0gcmV0cmlldmVfcHRyX2xpbWl0KHB0cl9y
ZWcsICZhbHVfbGltaXQsIG9wY29kZSwgb2ZmX2lzX25lZyk7CisJaWYgKGVyciA8IDApCisJCXJl
dHVybiBlcnI7CisKKwllcnIgPSB1cGRhdGVfYWx1X3Nhbml0YXRpb25fc3RhdGUoYXV4LCBhbHVf
c3RhdGUsIGFsdV9saW1pdCk7CisJaWYgKGVyciA8IDApCisJCXJldHVybiBlcnI7CiBkb19zaW06
CiAJLyogU2ltdWxhdGUgYW5kIGZpbmQgcG90ZW50aWFsIG91dC1vZi1ib3VuZHMgYWNjZXNzIHVu
ZGVyCiAJICogc3BlY3VsYXRpdmUgZXhlY3V0aW9uIGZyb20gdHJ1bmNhdGlvbiBhcyBhIHJlc3Vs
dCBvZgpAQCAtNjEwMyw3ICs2MTA3LDcgQEAgc3RhdGljIGludCBhZGp1c3RfcHRyX21pbl9tYXhf
dmFscyhzdHJ1Y3QgYnBmX3ZlcmlmaWVyX2VudiAqZW52LAogCWNhc2UgQlBGX0FERDoKIAkJcmV0
ID0gc2FuaXRpemVfcHRyX2FsdShlbnYsIGluc24sIHB0cl9yZWcsIGRzdF9yZWcsIHNtaW5fdmFs
IDwgMCk7CiAJCWlmIChyZXQgPCAwKSB7Ci0JCQl2ZXJib3NlKCJSJWQgdHJpZWQgdG8gYWRkIGZy
b20gZGlmZmVyZW50IG1hcHMgb3IgcGF0aHNcbiIsIGRzdCk7CisJCQl2ZXJib3NlKCJSJWQgdHJp
ZWQgdG8gYWRkIGZyb20gZGlmZmVyZW50IG1hcHMsIHBhdGhzLCBvciBwcm9oaWJpdGVkIHR5cGVz
XG4iLCBkc3QpOwogCQkJcmV0dXJuIHJldDsKIAkJfQogCQkvKiBXZSBjYW4gdGFrZSBhIGZpeGVk
IG9mZnNldCBhcyBsb25nIGFzIGl0IGRvZXNuJ3Qgb3ZlcmZsb3cKQEAgLTYxNTgsNyArNjE2Miw3
IEBAIHN0YXRpYyBpbnQgYWRqdXN0X3B0cl9taW5fbWF4X3ZhbHMoc3RydWN0IGJwZl92ZXJpZmll
cl9lbnYgKmVudiwKIAljYXNlIEJQRl9TVUI6CiAJCXJldCA9IHNhbml0aXplX3B0cl9hbHUoZW52
LCBpbnNuLCBwdHJfcmVnLCBkc3RfcmVnLCBzbWluX3ZhbCA8IDApOwogCQlpZiAocmV0IDwgMCkg
ewotCQkJdmVyYm9zZSgiUiVkIHRyaWVkIHRvIHN1YiBmcm9tIGRpZmZlcmVudCBtYXBzIG9yIHBh
dGhzXG4iLCBkc3QpOworCQkJdmVyYm9zZSgiUiVkIHRyaWVkIHRvIHN1YiBmcm9tIGRpZmZlcmVu
dCBtYXBzLCBwYXRocywgb3IgcHJvaGliaXRlZCB0eXBlc1xuIiwgZHN0KTsKIAkJCXJldHVybiBy
ZXQ7CiAJCX0KIAkJaWYgKGRzdF9yZWcgPT0gb2ZmX3JlZykgewotLSAKMi4yNS4xCgo=
--000000000000f0d7c905bdec76eb--
