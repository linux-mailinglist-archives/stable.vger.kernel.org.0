Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C762D69A6
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393979AbgLJVV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393297AbgLJVVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:21:53 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741A2C0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:21:13 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c79so5343552pfc.2
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3P4J43+ehtFx7qHH6tCR2NZRZdFtqddtnJ71Uw8Q0/E=;
        b=NIpFnsoaCGXdOfpqT7XVKlnAmwR64rHl9I0SnLEANtL/io0xSwZ/8XwILx3n/FWODc
         ZOt7izXy03bcIZYS1Rb5zToVL+5En+7+aJWJe8V57Q8JUKbZ2X5vNEhfKwVzoxtCECiZ
         k6yahKRKDK9AGqs8b/gAKgOS/tOrpXAh8XCjK1nwzAhW1X2OvVQOGaa2QZy23WpRr2ze
         ISOMTekJ8HdFUWZkQ5UEMgLw/lZQ9KmoMvY4LO3a0yH7AgC6qN5sappv6EWhYyahAyzo
         +s9dhhGkAUYgY1Z0+i7fFiQQ5eOQB18jI8ZzUlfmHqVf1bVdTeT31qMwCxic1MxIdEyD
         nRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3P4J43+ehtFx7qHH6tCR2NZRZdFtqddtnJ71Uw8Q0/E=;
        b=OCagSBmQvDMfYr2a7ytcnVm3Mg84LCTp7XR6ERlqbcrpVjhcQKSMSB+KVOgwV4/4U0
         HugUXvQHNNa24hOR1/u2oP2Ra+BqwAc+v39UUfv45Kyuysnm4S7YRosGMbRshA8cncqr
         B4jmFsF1pQKU+KHmlH2wirHgvcK/r/ySELnCZ7e59/G2hHMghe00tA+tYHfeljMCO+Up
         SQ8GMZeAcTluejsNxqGA+aEZME7y1nkDMg1Az+bPkXUIrJ5IyDl2gQ1j56R/rDUClk99
         WQYTC1OYG4ynNpKTz55g4ZRikln05/bWW7/39aETJ4Q9EX0VVCyblfRt59eqceaqb1XP
         UTIw==
X-Gm-Message-State: AOAM530f3uvLKJKf6ZmyrfF7z71hZ83LT+TK+2zqrCEowISFNic+dCSu
        ZtvO0/p+qqrptV061u4FRBYH9fTSh176mKfqRncc0oBSQNc=
X-Google-Smtp-Source: ABdhPJxLtyCMAfUmLshTkhD7HDKIW9XAoaD7Jme1ZlCyz1A7xDLEFml0PotT4qYKB2UBg5TWX3EyWDHKYYM2EEJaXzA=
X-Received: by 2002:a63:a902:: with SMTP id u2mr8535280pge.263.1607635272756;
 Thu, 10 Dec 2020 13:21:12 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com>
 <X9CuL4Kdl1dw2gws@kroah.com>
In-Reply-To: <X9CuL4Kdl1dw2gws@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 10 Dec 2020 13:21:00 -0800
Message-ID: <CAKwvOdkN85dnAEUCvjULh8-gojwmK-e4-aVhNbO0RdyXsO_H2w@mail.gmail.com>
Subject: Re: 5.4 and 4.19 warning fix for LLVM_IAS
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Dmitry Golovin <dima@golovin.in>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jian Cai <jiancai@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>
Content-Type: multipart/mixed; boundary="0000000000005d127905b622c114"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000005d127905b622c114
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 9, 2020 at 2:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 08, 2020 at 04:43:34PM -0800, Nick Desaulniers wrote:
> > Dear stable kernel maintainers,
> > (Woah, two in one day; have I exceeded my limit?)
> >
> > Please consider the attached patch for 5.4 and 4.19 for commit
> > b8a9092330da ("Kbuild: do not emit debug info for assembly with
> > LLVM_IAS=1"), which fixes a significant number of warnings under arch/
> > when assembling a kernel with Clang.
>
> I also need a version of this for 5.9.y before we can take this for
> older kernels.  Can you provide that as well?

Yes, apologies.  It's similar to the 5.4.y patch, but with a shorter
set of conflicts as noted in the commit message.  Attached.
-- 
Thanks,
~Nick Desaulniers

--0000000000005d127905b622c114
Content-Type: application/octet-stream; name="b8a9092330da.5.9.patch"
Content-Disposition: attachment; filename="b8a9092330da.5.9.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kijchnt40>
X-Attachment-Id: f_kijchnt40

RnJvbSBhZmIxMDEwNmE2YjhlYTk3OTQ2M2RhZjBhNjEzMzUyYmZkZjY0MmYzIE1vbiBTZXAgMTcg
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
b25mbGljdHMgZnJvbToKICBjb21taXQgNjk1YWZkM2Q3ZDU4ICgia2J1aWxkOiBTaW1wbGlmeSBE
RUJVR19JTkZPIEtjb25maWcgaGFuZGxpbmciKV0KLS0tCiBNYWtlZmlsZSB8IDMgKysrCiAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtl
ZmlsZQppbmRleCBiOThiNTQ3NThiMjAuLjhmOGEzOTYyNDMyMCAxMDA2NDQKLS0tIGEvTWFrZWZp
bGUKKysrIGIvTWFrZWZpbGUKQEAgLTgyMSw4ICs4MjEsMTEgQEAgREVCVUdfQ0ZMQUdTCSs9IC1n
c3BsaXQtZHdhcmYKIGVsc2UKIERFQlVHX0NGTEFHUwkrPSAtZwogZW5kaWYKK2lmbmVxICgkKExM
Vk1fSUFTKSwxKQogS0JVSUxEX0FGTEFHUwkrPSAtV2EsLWdkd2FyZi0yCiBlbmRpZgorZW5kaWYK
KwogaWZkZWYgQ09ORklHX0RFQlVHX0lORk9fRFdBUkY0CiBERUJVR19DRkxBR1MJKz0gLWdkd2Fy
Zi00CiBlbmRpZgotLSAKMi4yOS4yLjU3Ni5nYTNmYzQ0NmQ4NC1nb29nCgo=
--0000000000005d127905b622c114--
