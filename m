Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F2C2D37E9
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 01:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgLIAo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 19:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729223AbgLIAo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 19:44:26 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90237C061793
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 16:43:46 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 4so30855plk.5
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 16:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DsEub29Fehvc45mIJG7tZWSfnrCimKfcRjRwnCs/e+w=;
        b=AvLYT/yUAhSYC5femfUz4kHIwylIG466HT23bm5oq79H6ITvvnsFxHSKLIo47OvFVl
         dRY5YQeoB8DThr93GCkwOPVTQ7sin1crJ1C64Y+PXRcCncooB86AwNFQVSJAiv3WSlBz
         aTV/+JqPSR7p8onoxHedp6jKj0WB4xQRw0bT8mOHEZ/cfIViTwB67jYTh/FE7uaOsN/N
         276zlkF35kUN1VeLDRLGWM6iEH+qQFzhI+paxyzqznu12H0xScXEfIzcKVFu3h6ze8Uu
         2GR2Y2yJUJP8ILp19OpTH1lwLkvHHNFyk4XYcyz2akKpAuwkCzdg+r5f2LdMbeHpYzyg
         8V/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DsEub29Fehvc45mIJG7tZWSfnrCimKfcRjRwnCs/e+w=;
        b=ePEJIkaZPLKNFXhb0DTfEokE4QhCBQCCyzsGVnJtO+4G3o+zcVF7rvgNTaPTmaEPux
         qxIKrlJmZr0NA2F/ibg1Yy52T5rat0pWZfuRqaQIxJPSPzSvIQau5tFTrDfvBKzidj2e
         H1Jt+y3X9yD67SjCyphA4F4Nl6BAF525HW0JENxj7m8H1QKRWCOCsjtYkT5AtPEhrtEF
         CVnca7skLVuzd1ckaOWEg7udKa1w9pGdmuxXwAlDzOpf59Sm39CI0F8SGKaKBb/lTv0n
         g0igivx33nvK8kAhzreDq9hDRJddvv24Kcv4wXY4I18Jqu+TB44CvbSfNWiqKLSdbmXo
         +YwQ==
X-Gm-Message-State: AOAM532kIZEwYJT3ubUjNfgL9fW4xZmahTBddlu4wHJj64SbbSr54bnY
        iLopI8UhE2z/fYTNZeULYB5lTA7hNQgB6hLKbeifO/AC3lrKxg==
X-Google-Smtp-Source: ABdhPJwCnc1Tcw3+zobpntN7x9Uv5FyCAMXkg5BxujqkPQHZqRvCxe6qoFXuPc+oLkMjgG0lUo4AoAlROm9Zj44nmq4=
X-Received: by 2002:a17:902:26a:b029:da:af47:77c7 with SMTP id
 97-20020a170902026ab02900daaf4777c7mr53021plc.10.1607474625688; Tue, 08 Dec
 2020 16:43:45 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 8 Dec 2020 16:43:34 -0800
Message-ID: <CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com>
Subject: 5.4 and 4.19 warning fix for LLVM_IAS
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Dmitry Golovin <dima@golovin.in>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jian Cai <jiancai@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>
Content-Type: multipart/mixed; boundary="0000000000000d712005b5fd5ae3"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000000d712005b5fd5ae3
Content-Type: text/plain; charset="UTF-8"

Dear stable kernel maintainers,
(Woah, two in one day; have I exceeded my limit?)

Please consider the attached patch for 5.4 and 4.19 for commit
b8a9092330da ("Kbuild: do not emit debug info for assembly with
LLVM_IAS=1"), which fixes a significant number of warnings under arch/
when assembling a kernel with Clang.

These backports have already been shipped in Android; I would like to
revert them and take them from syncing with stable. CrOS also has the
patches staged, but I would prefer for them to sync them from stable
as well.

b8a9092330da just landed in v5.10-rc7.  I recently read
https://lwn.net/Articles/838819/, which mentions a discussion about
letting patches have more time to soak in mainline, so I accept if
your decision is to wait, though I'll note these have been soaking in
Android for 2 days shy of one month (Nov 10).

There were minor conflicts due to missing Kbuild support for
compressed debug info, which is a feature I implemented but don't plan
to backport to stable.

We plan to use Clang's integrated assembler for Android and CrOS for 4.19+.

See also: https://github.com/ClangBuiltLinux/linux/issues/716.
-- 
Thanks,
~Nick Desaulniers

--0000000000000d712005b5fd5ae3
Content-Type: text/plain; charset="US-ASCII"; name="b8a9092330da.5.4.patch.txt"
Content-Disposition: attachment; filename="b8a9092330da.5.4.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kigonqnb0>
X-Attachment-Id: f_kigonqnb0

RnJvbSAxMjViY2QxODY3ZTZiNTlmNGViMzY0NTIyMjc2YmMyNzNlMjY0OGUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogTW9uLCA5IE5vdiAyMDIwIDEwOjM1OjI4IC0wODAwClN1YmplY3Q6IFtQQVRD
SF0gS2J1aWxkOiBkbyBub3QgZW1pdCBkZWJ1ZyBpbmZvIGZvciBhc3NlbWJseSB3aXRoIExMVk1f
SUFTPTEKCmNvbW1pdCBiOGE5MDkyMzMwZGEyMDMwNDk2ZmYzNTcyNzJmMzQyZWI5NzBkNTFiIHVw
c3RyZWFtLgoKQ2xhbmcncyBpbnRlZ3JhdGVkIGFzc2VtYmxlciBwcm9kdWNlcyB0aGUgd2Fybmlu
ZyBmb3IgYXNzZW1ibHkgZmlsZXM6Cgp3YXJuaW5nOiBEV0FSRjIgb25seSBzdXBwb3J0cyBvbmUg
c2VjdGlvbiBwZXIgY29tcGlsYXRpb24gdW5pdAoKSWYgLVdhLC1nZHdhcmYtKiBpcyB1bnNwZWNp
ZmllZCwgdGhlbiBkZWJ1ZyBpbmZvIGlzIG5vdCBlbWl0dGVkIGZvcgphc3NlbWJseSBzb3VyY2Vz
IChpdCBpcyBzdGlsbCBlbWl0dGVkIGZvciBDIHNvdXJjZXMpLiAgVGhpcyB3aWxsIGJlCnJlLWVu
YWJsZWQgZm9yIG5ld2VyIERXQVJGIHZlcnNpb25zIGluIGEgZm9sbG93IHVwIHBhdGNoLgoKRW5h
YmxlcyBkZWZjb25maWcrQ09ORklHX0RFQlVHX0lORk8gdG8gYnVpbGQgY2xlYW5seSB3aXRoCkxM
Vk09MSBMTFZNX0lBUz0xIGZvciB4ODZfNjQgYW5kIGFybTY0LgoKQ2M6IDxzdGFibGVAdmdlci5r
ZXJuZWwub3JnPgpMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vQ2xhbmdCdWlsdExpbnV4L2xpbnV4
L2lzc3Vlcy83MTYKUmVwb3J0ZWQtYnk6IERtaXRyeSBHb2xvdmluIDxkaW1hQGdvbG92aW4uaW4+
ClJlcG9ydGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwuY29t
PgpTdWdnZXN0ZWQtYnk6IERtaXRyeSBHb2xvdmluIDxkaW1hQGdvbG92aW4uaW4+ClN1Z2dlc3Rl
ZC1ieTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGVjaGFuY2VsbG9yQGdtYWlsLmNvbT4KU3VnZ2Vz
dGVkLWJ5OiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpSZXZpZXdlZC1ieTog
RmFuZ3J1aSBTb25nIDxtYXNrcmF5QGdvb2dsZS5jb20+ClJldmlld2VkLWJ5OiBOYXRoYW4gQ2hh
bmNlbGxvciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBOaWNrIERl
c2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xlLmNvbT4KU2lnbmVkLW9mZi1ieTogTWFzYWhp
cm8gWWFtYWRhIDxtYXNhaGlyb3lAa2VybmVsLm9yZz4KW25kOiBiYWNrcG9ydCB0byBhdm9pZCBj
b25mbGljdHMgZnJvbToKICBjb21taXQgMTBlNjhiMDJjODYxICgiTWFrZWZpbGU6IHN1cHBvcnQg
Y29tcHJlc3NlZCBkZWJ1ZyBpbmZvIikKICBjb21taXQgN2IxNjk5NDQzN2M3ICgiTWFrZWZpbGU6
IEltcHJvdmUgY29tcHJlc3NlZCBkZWJ1ZyBpbmZvIHN1cHBvcnQgZGV0ZWN0aW9uIikKICBjb21t
aXQgNjk1YWZkM2Q3ZDU4ICgia2J1aWxkOiBTaW1wbGlmeSBERUJVR19JTkZPIEtjb25maWcgaGFu
ZGxpbmciKV0KLS0tCiBNYWtlZmlsZSB8IDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRleCBlNTIwZGVlMzQ0
OTAuLmY4Yzc2NmIzNWI3MSAxMDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAg
LTgwMiw4ICs4MDIsMTEgQEAgREVCVUdfQ0ZMQUdTCSs9IC1nc3BsaXQtZHdhcmYKIGVsc2UKIERF
QlVHX0NGTEFHUwkrPSAtZwogZW5kaWYKK2lmbmVxICgkKExMVk1fSUFTKSwxKQogS0JVSUxEX0FG
TEFHUwkrPSAtV2EsLWdkd2FyZi0yCiBlbmRpZgorZW5kaWYKKwogaWZkZWYgQ09ORklHX0RFQlVH
X0lORk9fRFdBUkY0CiBERUJVR19DRkxBR1MJKz0gLWdkd2FyZi00CiBlbmRpZgotLSAKMi4yOS4y
LjU3Ni5nYTNmYzQ0NmQ4NC1nb29nCgo=
--0000000000000d712005b5fd5ae3
Content-Type: text/plain; charset="US-ASCII"; name="b8a9092330da.4.19.patch.txt"
Content-Disposition: attachment; filename="b8a9092330da.4.19.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kigonqnm1>
X-Attachment-Id: f_kigonqnm1

RnJvbSAxNzM2OWVkNmZhYTJlYmRmNGMxMGFjY2ZkNmNhOTA3NWZkY2JiNGEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogTW9uLCA5IE5vdiAyMDIwIDEwOjM1OjI4IC0wODAwClN1YmplY3Q6IFtQQVRD
SF0gS2J1aWxkOiBkbyBub3QgZW1pdCBkZWJ1ZyBpbmZvIGZvciBhc3NlbWJseSB3aXRoIExMVk1f
SUFTPTEKCmNvbW1pdCBiOGE5MDkyMzMwZGEyMDMwNDk2ZmYzNTcyNzJmMzQyZWI5NzBkNTFiIHVw
c3RyZWFtLgoKQ2xhbmcncyBpbnRlZ3JhdGVkIGFzc2VtYmxlciBwcm9kdWNlcyB0aGUgd2Fybmlu
ZyBmb3IgYXNzZW1ibHkgZmlsZXM6Cgp3YXJuaW5nOiBEV0FSRjIgb25seSBzdXBwb3J0cyBvbmUg
c2VjdGlvbiBwZXIgY29tcGlsYXRpb24gdW5pdAoKSWYgLVdhLC1nZHdhcmYtKiBpcyB1bnNwZWNp
ZmllZCwgdGhlbiBkZWJ1ZyBpbmZvIGlzIG5vdCBlbWl0dGVkIGZvcgphc3NlbWJseSBzb3VyY2Vz
IChpdCBpcyBzdGlsbCBlbWl0dGVkIGZvciBDIHNvdXJjZXMpLiAgVGhpcyB3aWxsIGJlCnJlLWVu
YWJsZWQgZm9yIG5ld2VyIERXQVJGIHZlcnNpb25zIGluIGEgZm9sbG93IHVwIHBhdGNoLgoKRW5h
YmxlcyBkZWZjb25maWcrQ09ORklHX0RFQlVHX0lORk8gdG8gYnVpbGQgY2xlYW5seSB3aXRoCkxM
Vk09MSBMTFZNX0lBUz0xIGZvciB4ODZfNjQgYW5kIGFybTY0LgoKQ2M6IDxzdGFibGVAdmdlci5r
ZXJuZWwub3JnPgpMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vQ2xhbmdCdWlsdExpbnV4L2xpbnV4
L2lzc3Vlcy83MTYKUmVwb3J0ZWQtYnk6IERtaXRyeSBHb2xvdmluIDxkaW1hQGdvbG92aW4uaW4+
ClJlcG9ydGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwuY29t
PgpTdWdnZXN0ZWQtYnk6IERtaXRyeSBHb2xvdmluIDxkaW1hQGdvbG92aW4uaW4+ClN1Z2dlc3Rl
ZC1ieTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGVjaGFuY2VsbG9yQGdtYWlsLmNvbT4KU3VnZ2Vz
dGVkLWJ5OiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpSZXZpZXdlZC1ieTog
RmFuZ3J1aSBTb25nIDxtYXNrcmF5QGdvb2dsZS5jb20+ClJldmlld2VkLWJ5OiBOYXRoYW4gQ2hh
bmNlbGxvciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBOaWNrIERl
c2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xlLmNvbT4KU2lnbmVkLW9mZi1ieTogTWFzYWhp
cm8gWWFtYWRhIDxtYXNhaGlyb3lAa2VybmVsLm9yZz4KW25kOiBiYWNrcG9ydCB0byBhdm9pZCBj
b25mbGljdHMgZnJvbToKICBjb21taXQgMTBlNjhiMDJjODYxICgiTWFrZWZpbGU6IHN1cHBvcnQg
Y29tcHJlc3NlZCBkZWJ1ZyBpbmZvIikKICBjb21taXQgN2IxNjk5NDQzN2M3ICgiTWFrZWZpbGU6
IEltcHJvdmUgY29tcHJlc3NlZCBkZWJ1ZyBpbmZvIHN1cHBvcnQgZGV0ZWN0aW9uIikKICBjb21t
aXQgNjk1YWZkM2Q3ZDU4ICgia2J1aWxkOiBTaW1wbGlmeSBERUJVR19JTkZPIEtjb25maWcgaGFu
ZGxpbmciKV0KLS0tCiBNYWtlZmlsZSB8IDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRleCA3MWU1NWM1Y2Q3
NGEuLjRjNmFjM2M2OTk1ZiAxMDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAg
LTc0NSw4ICs3NDUsMTEgQEAgS0JVSUxEX0NGTEFHUyAgICs9ICQoY2FsbCBjYy1vcHRpb24sIC1n
c3BsaXQtZHdhcmYsIC1nKQogZWxzZQogS0JVSUxEX0NGTEFHUwkrPSAtZwogZW5kaWYKK2lmbmVx
ICgkKExMVk1fSUFTKSwxKQogS0JVSUxEX0FGTEFHUwkrPSAtV2EsLWdkd2FyZi0yCiBlbmRpZgor
ZW5kaWYKKwogaWZkZWYgQ09ORklHX0RFQlVHX0lORk9fRFdBUkY0CiBLQlVJTERfQ0ZMQUdTCSs9
ICQoY2FsbCBjYy1vcHRpb24sIC1nZHdhcmYtNCwpCiBlbmRpZgotLSAKMi4yOS4yLjU3Ni5nYTNm
YzQ0NmQ4NC1nb29nCgo=
--0000000000000d712005b5fd5ae3--
