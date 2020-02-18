Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1085F162D20
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 18:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgBRRgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 12:36:32 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45551 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBRRga (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 12:36:30 -0500
Received: by mail-lj1-f193.google.com with SMTP id e18so23876985ljn.12
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 09:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ejn5UstmxF7lmN2AxfPRiO0l5wA0+kUDkpk4DTP/TNk=;
        b=BEZGdGO+K+CM8dnG/8KD7hitd4IDxMiSPgHJkRRJZDw97o+11Qbkvzpk38q2jJLsNY
         e8Xmr0kLH1BOqKRkok7gyQ3yQLJRWJmKpMsYQtr8L29SkIwjSlGqDIcKEmg/lRvanhR0
         YwYWAY6jQ3nzi1dL3iFw6Ug12aGV1djv1Up9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ejn5UstmxF7lmN2AxfPRiO0l5wA0+kUDkpk4DTP/TNk=;
        b=WuFIN/d9wQfSSdJ5HYh/mcKCLiB4lgBsJrGSe8JyvuFb0Kbp23SAMu0H2kZHnHhjvr
         oMNounrODuQSvsA99Evxlisyw+juSZuP7eGEv8bNhJmZ8/JZNzyOhhttWITeAHQ+jxyV
         EwlbUPesXxaknalSvHLYhkxbLkEM5+OJ3TiU7ywKPPld/yQZdBK5R7amV00OMZ84zJaw
         5kXcUD19STDOAmq35nlYwZDkWp5iRX8baxruj1IZWjU79qwfT+6BJLhWfvSKj1IczhTG
         rI2MnCSJKWG7MykVx2jHgSVT3H8msn/o3vKcceoT3Qdh9bk05vdaRwdPpKdd1k6jNrdZ
         YZtQ==
X-Gm-Message-State: APjAAAV0VOdql+UhuxOgL3/TP49oqiC0jwhD61ALMM+hfn9EPWZsCkIP
        HBCYPFlyu739x5rgFGyCStJ8Dv4SJAI=
X-Google-Smtp-Source: APXvYqwSjHE2ohlYfReMaibwICQt44rb7zvLDeSvrFsh/OzrBFJsGQ+w2N9NC3KuiR/cvf6t/3MFPQ==
X-Received: by 2002:a2e:8015:: with SMTP id j21mr13444320ljg.172.1582047386737;
        Tue, 18 Feb 2020 09:36:26 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id 188sm3033397lfc.54.2020.02.18.09.36.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 09:36:25 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id y19so15129679lfl.9
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 09:36:25 -0800 (PST)
X-Received: by 2002:a19:f514:: with SMTP id j20mr11135556lfb.31.1582047384649;
 Tue, 18 Feb 2020 09:36:24 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
In-Reply-To: <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 18 Feb 2020 09:36:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
Message-ID: <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Andrei Vagin <avagin@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000616ba8059edd1c62"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000616ba8059edd1c62
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 18, 2020 at 1:51 AM Andrei Vagin <avagin@gmail.com> wrote:
>
> This patch breaks one of CRIU tests. Here is a small reproducer:

Good catch.

> The quick fix looks like this:

That one works, but is not really right.

The things that change the number of readers or writers should simply
use "wake_up_all()".

I thought we did that already, but no - there _was_ one place where we
did it, but that was for the pipe buffer size case, and in that case
it's actually pointless. That case acts just like a "new space or data
was added"

So I think the right fix is the attached patch. Since you had such a
lovely test-case, let me go test it too ;)

                Linus

--000000000000616ba8059edd1c62
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_k6s65iuv0>
X-Attachment-Id: f_k6s65iuv0

IGZzL3BpcGUuYyB8IDEwICsrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMo
KyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcGlwZS5jIGIvZnMvcGlwZS5jCmlu
ZGV4IDVhMzRkNmMyMmQ0Yy4uNzZlN2Y2NmZlMmZlIDEwMDY0NAotLS0gYS9mcy9waXBlLmMKKysr
IGIvZnMvcGlwZS5jCkBAIC0xMDI2LDggKzEwMjYsOCBAQCBzdGF0aWMgaW50IHdhaXRfZm9yX3Bh
cnRuZXIoc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqcGlwZSwgdW5zaWduZWQgaW50ICpjbnQpCiAK
IHN0YXRpYyB2b2lkIHdha2VfdXBfcGFydG5lcihzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvICpwaXBl
KQogewotCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmcGlwZS0+cmRfd2FpdCk7Ci0Jd2FrZV91cF9p
bnRlcnJ1cHRpYmxlKCZwaXBlLT53cl93YWl0KTsKKwl3YWtlX3VwX2ludGVycnVwdGlibGVfYWxs
KCZwaXBlLT5yZF93YWl0KTsKKwl3YWtlX3VwX2ludGVycnVwdGlibGVfYWxsKCZwaXBlLT53cl93
YWl0KTsKIH0KIAogc3RhdGljIGludCBmaWZvX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGZpbGUgKmZpbHApCkBAIC0xMTQ0LDcgKzExNDQsNyBAQCBzdGF0aWMgaW50IGZpZm9fb3Bl
bihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkKIAogZXJyX3dyOgogCWlm
ICghLS1waXBlLT53cml0ZXJzKQotCQl3YWtlX3VwX2ludGVycnVwdGlibGUoJnBpcGUtPnJkX3dh
aXQpOworCQl3YWtlX3VwX2ludGVycnVwdGlibGVfYWxsKCZwaXBlLT5yZF93YWl0KTsKIAlyZXQg
PSAtRVJFU1RBUlRTWVM7CiAJZ290byBlcnI7CiAKQEAgLTEyNzEsOCArMTI3MSw4IEBAIHN0YXRp
YyBsb25nIHBpcGVfc2V0X3NpemUoc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqcGlwZSwgdW5zaWdu
ZWQgbG9uZyBhcmcpCiAJcGlwZS0+bWF4X3VzYWdlID0gbnJfc2xvdHM7CiAJcGlwZS0+dGFpbCA9
IHRhaWw7CiAJcGlwZS0+aGVhZCA9IGhlYWQ7Ci0Jd2FrZV91cF9pbnRlcnJ1cHRpYmxlX2FsbCgm
cGlwZS0+cmRfd2FpdCk7Ci0Jd2FrZV91cF9pbnRlcnJ1cHRpYmxlX2FsbCgmcGlwZS0+d3Jfd2Fp
dCk7CisJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwaXBlLT5yZF93YWl0KTsKKwl3YWtlX3VwX2lu
dGVycnVwdGlibGUoJnBpcGUtPndyX3dhaXQpOwogCXJldHVybiBwaXBlLT5tYXhfdXNhZ2UgKiBQ
QUdFX1NJWkU7CiAKIG91dF9yZXZlcnRfYWNjdDoK
--000000000000616ba8059edd1c62--
