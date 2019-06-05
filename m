Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29DD362B9
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 19:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfFERdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 13:33:02 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:42940 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFERdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 13:33:00 -0400
Received: by mail-lf1-f50.google.com with SMTP id y13so19705968lfh.9
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 10:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4dzrfT5QqLGh7VEyZ93DmM/B2JbZO0W27MdQC2tlHrw=;
        b=FKQTQdRiCtVECI1Ss50LEAri2FoYB4zuECl4MbKr7V1HG+/fgvFHO/XCFc4PclJL0f
         Wssk8CHwAJzxGg8oxI5A8N0uaT7yA0hPAHDf6vPUxygAINx56WVYQJa7UQsGrz55oPcZ
         ZbjDGAg20qL59d3Au7EHam6sThq+5CJLZeVEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4dzrfT5QqLGh7VEyZ93DmM/B2JbZO0W27MdQC2tlHrw=;
        b=W72y06w/oYlol9dobChDjHv2JfTwf+mVimwWPbY+RuzNL3WofghNw2c9g1xFmh4XXw
         E1O+V4G8rquS3b70YV3OMgclqsNfK3F/PQ3+gMHDsT4zYxADM1Is0rFaHMs2byyIoijr
         sCneqKubH4dO3XKhD1YfuWWKFFg2UBLydSFIxIC5t307aaAyhXl5i78mpaqPQDXWE8FS
         V+MWBBoGCWWwQ2QZldyxyd1YYkvdJFyVIHfkj9uwBIEn1dEP2SXr89IIhGj/tGWjBhFy
         I5Do/RtGlXnrwdmGYu7Z/jEdp5BsejuwwUXqxSPZBQM8kfhE1TFF2h5y1CXxTheagKJz
         pLqg==
X-Gm-Message-State: APjAAAXwjTXVMHhABdg4apIS5p4BxX06AU85qEWjY/2Tz81jxcrtk6Z2
        W1UYJHr9HUMdOgpVkbV0d47LHyzaLxs=
X-Google-Smtp-Source: APXvYqwkaZ/RgxFrVypRmnj9kBrfDd0gok67TTmMgpzvIuqHZhkUhO4W36hiB8pWVs58Ebmw9xhPOg==
X-Received: by 2002:ac2:4d17:: with SMTP id r23mr15248021lfi.130.1559755977600;
        Wed, 05 Jun 2019 10:32:57 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id c5sm4309260lfm.7.2019.06.05.10.32.57
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 10:32:57 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id 136so8170223lfa.8
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 10:32:57 -0700 (PDT)
X-Received: by 2002:ac2:5601:: with SMTP id v1mr7944437lfd.106.1559755503740;
 Wed, 05 Jun 2019 10:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com> <20190605155801.GA25165@redhat.com>
In-Reply-To: <20190605155801.GA25165@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Jun 2019 10:24:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
Message-ID: <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
Subject: Re: [PATCH -mm 0/1] signal: simplify set_user_sigmask/restore_user_sigmask
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Laight <David.Laight@aculab.com>
Content-Type: multipart/mixed; boundary="000000000000bcd942058a96e0bf"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000bcd942058a96e0bf
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 5, 2019 at 8:58 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> To simplify the review, please see the code with this patch applied.
> I am using epoll_pwait() as an example because it looks very simple.

I like it.

However.

I think I'd like it even more if we just said "we don't need
restore_saved_sigmask AT ALL".

Which would be fairly easy to do with something like the attached...

(Yes, this only does x86, which is a problem, but I'm bringing this up
as a RFC..)

Is it worth another TIF flag? This sure would simplify things, and it
really fits the concept too: this really is a do_signal() issue, and
fundamentally goes together with TIF_SIGPENDING.

                Linus

--000000000000bcd942058a96e0bf
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jwji3ph10>
X-Attachment-Id: f_jwji3ph10

IGFyY2gveDg2L2VudHJ5L2NvbW1vbi5jICAgICAgICAgICAgfCAyICstCiBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS90aHJlYWRfaW5mby5oIHwgMiArKwoga2VybmVsL3NpZ25hbC5jICAgICAgICAgICAg
ICAgICAgICB8IDEgKwogMyBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9lbnRyeS9jb21tb24uYyBiL2FyY2gveDg2L2Vu
dHJ5L2NvbW1vbi5jCmluZGV4IGE5ODZiM2M4Mjk0Yy4uZWI1MzhlY2Q2NjAzIDEwMDY0NAotLS0g
YS9hcmNoL3g4Ni9lbnRyeS9jb21tb24uYworKysgYi9hcmNoL3g4Ni9lbnRyeS9jb21tb24uYwpA
QCAtMTYwLDcgKzE2MCw3IEBAIHN0YXRpYyB2b2lkIGV4aXRfdG9fdXNlcm1vZGVfbG9vcChzdHJ1
Y3QgcHRfcmVncyAqcmVncywgdTMyIGNhY2hlZF9mbGFncykKIAkJCWtscF91cGRhdGVfcGF0Y2hf
c3RhdGUoY3VycmVudCk7CiAKIAkJLyogZGVhbCB3aXRoIHBlbmRpbmcgc2lnbmFsIGRlbGl2ZXJ5
ICovCi0JCWlmIChjYWNoZWRfZmxhZ3MgJiBfVElGX1NJR1BFTkRJTkcpCisJCWlmIChjYWNoZWRf
ZmxhZ3MgJiAoX1RJRl9TSUdQRU5ESU5HIHwgX1RJRl9SRVNUT1JFX1NJR01BU0spKQogCQkJZG9f
c2lnbmFsKHJlZ3MpOwogCiAJCWlmIChjYWNoZWRfZmxhZ3MgJiBfVElGX05PVElGWV9SRVNVTUUp
IHsKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RocmVhZF9pbmZvLmggYi9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oCmluZGV4IGY5NDUzNTM2ZjliYi4uZDc3YTlm
ODQxNDU1IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oCisr
KyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RocmVhZF9pbmZvLmgKQEAgLTkyLDYgKzkyLDcgQEAg
c3RydWN0IHRocmVhZF9pbmZvIHsKICNkZWZpbmUgVElGX05PQ1BVSUQJCTE1CS8qIENQVUlEIGlz
IG5vdCBhY2Nlc3NpYmxlIGluIHVzZXJsYW5kICovCiAjZGVmaW5lIFRJRl9OT1RTQwkJMTYJLyog
VFNDIGlzIG5vdCBhY2Nlc3NpYmxlIGluIHVzZXJsYW5kICovCiAjZGVmaW5lIFRJRl9JQTMyCQkx
NwkvKiBJQTMyIGNvbXBhdGliaWxpdHkgcHJvY2VzcyAqLworI2RlZmluZSBUSUZfUkVTVE9SRV9T
SUdNQVNLCTE4CS8qIFJlc3RvcmUgc2F2ZWQgc2lnbWFzayBvbiByZXR1cm4gdG8gdXNlciBzcGFj
ZSAqLwogI2RlZmluZSBUSUZfTk9IWgkJMTkJLyogaW4gYWRhcHRpdmUgbm9oeiBtb2RlICovCiAj
ZGVmaW5lIFRJRl9NRU1ESUUJCTIwCS8qIGlzIHRlcm1pbmF0aW5nIGR1ZSB0byBPT00ga2lsbGVy
ICovCiAjZGVmaW5lIFRJRl9QT0xMSU5HX05SRkxBRwkyMQkvKiBpZGxlIGlzIHBvbGxpbmcgZm9y
IFRJRl9ORUVEX1JFU0NIRUQgKi8KQEAgLTEyMiw2ICsxMjMsNyBAQCBzdHJ1Y3QgdGhyZWFkX2lu
Zm8gewogI2RlZmluZSBfVElGX05PQ1BVSUQJCSgxIDw8IFRJRl9OT0NQVUlEKQogI2RlZmluZSBf
VElGX05PVFNDCQkoMSA8PCBUSUZfTk9UU0MpCiAjZGVmaW5lIF9USUZfSUEzMgkJKDEgPDwgVElG
X0lBMzIpCisjZGVmaW5lIF9USUZfUkVTVE9SRV9TSUdNQVNLCSgxIDw8IFRJRl9SRVNUT1JFX1NJ
R01BU0spCiAjZGVmaW5lIF9USUZfTk9IWgkJKDEgPDwgVElGX05PSFopCiAjZGVmaW5lIF9USUZf
UE9MTElOR19OUkZMQUcJKDEgPDwgVElGX1BPTExJTkdfTlJGTEFHKQogI2RlZmluZSBfVElGX0lP
X0JJVE1BUAkJKDEgPDwgVElGX0lPX0JJVE1BUCkKZGlmZiAtLWdpdCBhL2tlcm5lbC9zaWduYWwu
YyBiL2tlcm5lbC9zaWduYWwuYwppbmRleCAzMjhhMDFlMWEyZjAuLmEzMzQ2ZGExYTRmNSAxMDA2
NDQKLS0tIGEva2VybmVsL3NpZ25hbC5jCisrKyBiL2tlcm5lbC9zaWduYWwuYwpAQCAtMjg3Nyw2
ICsyODc3LDcgQEAgaW50IHNldF91c2VyX3NpZ21hc2soY29uc3Qgc2lnc2V0X3QgX191c2VyICp1
c2lnbWFzaywgc2lnc2V0X3QgKnNldCwKIAogCSpvbGRzZXQgPSBjdXJyZW50LT5ibG9ja2VkOwog
CXNldF9jdXJyZW50X2Jsb2NrZWQoc2V0KTsKKwlzZXRfdGhyZWFkX2ZsYWcoVElGX1JFU1RPUkVf
U0lHTUFTSyk7CiAKIAlyZXR1cm4gMDsKIH0K
--000000000000bcd942058a96e0bf--
