Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8475F1490
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 23:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiI3VMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 17:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiI3VLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 17:11:43 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E46ECE6F6;
        Fri, 30 Sep 2022 14:10:12 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-324ec5a9e97so55863867b3.7;
        Fri, 30 Sep 2022 14:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=M1w1EWPn1vLoOId55Q91gnxn8wS8AwPmtHIhCGOHN0M=;
        b=REbiTCxqzTXXjShheYbGyeOylXALyVd3WWejaZI1kZe1D+P0wnqNuB3hXoSpZfK4Fa
         JnWc8punZ2lcrdDg5a5hNaNxNBTwaLGc75orEzHnYlq9F7mRhGQPJGMswayT9rSgIkk1
         UrzlwX/md/fIxSk48OXrH0uTZc7DhiLOEYA03R8OzCqCIwIEulWd7z737PgqMUaTwmrW
         Ai2H7An1NPeX8HiuDxhKx792lD2bGFalMewrK2z8z8+0Fnp0VMMrX1HmVrDuJ5A8orgF
         7XdUPCT6pbKngPw9cb8qTXq3yBBY0vFca3wYvqy/WejC6aK/xITzxH/PeCIFFvD4BZxj
         mCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=M1w1EWPn1vLoOId55Q91gnxn8wS8AwPmtHIhCGOHN0M=;
        b=fZaJAEahEjO2OpjqpbTOxuZyFLoyce4qDwMbm0o+pimnV2xg4FLRUAHE2psETF5eZ0
         Vn+y8quXCUkjBBAdL6AhkJf3ANvulywh9EYMTEnaF0ax7/22UkwJIF/FdBuQTR7E/OVA
         zmvbaKdEQLaUu2sbBkVohrT4fgDMgSNbIuRX/jRFxiaqIyDTUBfftFlPZghGo2SlpQMp
         ryrCuKAD7Se2l3ArIteZjjJdJeTiiiZhMqExuvkm/dKeMbE9ysKlw4vWuxZjmjtOnM9T
         qtqWRZBqb1Qypbt5ppczhpwhnLESr3PZ1UlIbBSab7MhMWPip4WS037MaoH8rnpXtHqw
         80CA==
X-Gm-Message-State: ACrzQf3l7ElQ5twzO1MnfzqY26VMKtcALbVb9njBLFw1VnzPN/fz8EZD
        ZTtBB2B/7IcvNlmLM3douHi0IUNwUpjUkP5rXXgGjjjZKNL/J/tsiCM=
X-Google-Smtp-Source: AMsMyM4a+PlK5rozN6GTpMcjF7T3JXqNFGUhpP5HbCOi8rUxczy4AxJq4KL4QkhOwDL95P8jdmXP2Rrw+SQKqI4sgWg=
X-Received: by 2002:a0d:e581:0:b0:356:cd48:a936 with SMTP id
 o123-20020a0de581000000b00356cd48a936mr2920874ywe.397.1664572211698; Fri, 30
 Sep 2022 14:10:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220819200928.401416-1-kherbst@redhat.com> <YymY+3+C2aI7T3GU@eldamar.lan>
 <CACO55ts7rpbyYv3ovWt1iCfkGsChCUVitmHqtzAwFpfbPEZGYQ@mail.gmail.com> <YymrJSfXe4LaXmkA@eldamar.lan>
In-Reply-To: <YymrJSfXe4LaXmkA@eldamar.lan>
From:   Computer Enthusiastic <computer.enthusiastic@gmail.com>
Date:   Fri, 30 Sep 2022 23:09:59 +0200
Message-ID: <CAHSpYy1mcTns0JS6eivjK82CZ9_ajSwH-H7gtDwCkNyfvihaAw@mail.gmail.com>
Subject: Re: [PATCH] nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Karol Herbst <kherbst@redhat.com>, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000061ec3805e9eb6b35"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000061ec3805e9eb6b35
Content-Type: text/plain; charset="UTF-8"

Hello,

Il giorno mar 20 set 2022 alle ore 13:59 Salvatore Bonaccorso
<carnil@debian.org> ha scritto:
[..]
> Computer Enthusiastic, can you verify the problem as well in a
> non-Debian patched upstream kernel directly from the 5.10.y series
> (latest 5.10.144) and verify the fix there?
>
> Regards,
> Salvatore

I've tested the vanilla kernel 5.10.145 (it was the latest one week
ago) without Debian kernel patches, but using the kernel config file
from the latest kernel for Debian Stable:
- without the Karol's patch: it always fails both suspend to ram and
hibernate to disk with the usual behavior (a very long time to suspend
or hibernate, then it fails on resume with a garbled screen)
- with the Karol's patch: it succeeds both suspend and hibernate and
it correctly resumes afterwards.

The kernel was tested using the following graphic adapter:
Graphics:  Device-1: NVIDIA G96CM [GeForce 9600M GT] driver: nouveau v: kernel
          Device-2: Suyin Acer HD Crystal Eye webcam type: USB driver:
uvcvideo
          Display: x11 server: X.Org 1.20.11 driver: loaded:
modesetting unloaded: fbdev,vesa
          resolution: 1280x800~60Hz
          OpenGL: renderer: NV96 v: 3.3 Mesa 20.3.5

Therefore, 5.10.y series of the kernel need to be patched to work
correctly at least with the aforementioned graphic card.

The script I used to compile the kernel are attached for further
reference and verification.

Hope that helps.

--00000000000061ec3805e9eb6b35
Content-Type: application/octet-stream; name="vanilla-kernel-build-5.10.145"
Content-Disposition: attachment; filename="vanilla-kernel-build-5.10.145"
Content-Transfer-Encoding: base64
Content-ID: <f_l8oz7w3z0>
X-Attachment-Id: f_l8oz7w3z0

IyBEb3dubG9hZCBzb3VyY2UgY29kZQp3Z2V0IC1uYyBodHRwczovL2Nkbi5rZXJuZWwub3JnL3B1
Yi9saW51eC9rZXJuZWwvdjUueC9saW51eC01LjEwLjE0NS50YXIueHoKdGFyIHhmIGxpbnV4LTUu
MTAuMTQ1LnRhci54egoKIyBBdXRvbWF0ZSBzdWJ2ZXJzaW9uIGluZGV4ClNVQlZFUlNJT05fSU5E
RVg9IjEiCgojIERlbGV0ZSBmcm9tIHByZXZpb3VzIGJ1aWxkcwpjZCBsaW51eC01LjEwLjE0NQpy
bSAtcmYgLi9kZWJpYW4Kcm0gLXJmIC4uL2xpbnV4Lm9yaWcvCnJtIC1yZiAuLi9saW51eC11cHN0
cmVhbSoKCmNwIC9ib290L2NvbmZpZy01LjEwLjAtMTgtYW1kNjQgLmNvbmZpZwptYWtlIG9sZGRl
ZmNvbmZpZwoKc2NyaXB0cy9jb25maWcgLS1kaXNhYmxlIFNZU1RFTV9UUlVTVEVEX0tFWVJJTkcK
c2NyaXB0cy9jb25maWcgLS1zZXQtc3RyIFNZU1RFTV9UUlVTVEVEX0tFWVMgJycKCiMgQnVpbGQg
a2VybmVsCnRpbWUgbWFrZSAtaiA4IGRlYi1wa2cgTE9DQUxWRVJTSU9OPS12YW5pbGxhIEtERUJf
UEtHVkVSU0lPTj0kKG1ha2Uga2VybmVsdmVyc2lvbiktJFNVQlZFUlNJT05fSU5ERVgKCmV4aXQg
MAo=
--00000000000061ec3805e9eb6b35
Content-Type: application/octet-stream; 
	name="vanilla-kernel-build-5.10.145-patched"
Content-Disposition: attachment; 
	filename="vanilla-kernel-build-5.10.145-patched"
Content-Transfer-Encoding: base64
Content-ID: <f_l8oz7w5a1>
X-Attachment-Id: f_l8oz7w5a1

IyBEb3dubG9hZCBzb3VyY2UgY29kZQp3Z2V0IC1uYyBodHRwczovL2Nkbi5rZXJuZWwub3JnL3B1
Yi9saW51eC9rZXJuZWwvdjUueC9saW51eC01LjEwLjE0NS50YXIueHoKdGFyIHhmIGxpbnV4LTUu
MTAuMTQ1LnRhci54egoKIyBnZXQgcGF0Y2gKd2dldCBuYyAtTyBub3V2ZWF1LnBhdGNoIGh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC5n
aXQvcGF0Y2gvP2lkPTM2NDBjZGNjYmU3NWI4OTIyZTViZmMwMTkxZGQzN2UzYWFhMjQ4MzMKCiMg
QXV0b21hdGUgc3VidmVyc2lvbiBpbmRleApTVUJWRVJTSU9OX0lOREVYPSIxIgoKIyBEZWxldGUg
ZnJvbSBwcmV2aW91cyBidWlsZHMKY2QgbGludXgtNS4xMC4xNDUKcm0gLXJmIC4vZGViaWFuCnJt
IC1yZiAuLi9saW51eC5vcmlnLwpybSAtcmYgLi4vbGludXgtdXBzdHJlYW0qCgpjcCAvYm9vdC9j
b25maWctNS4xMC4wLTE4LWFtZDY0IC5jb25maWcKbWFrZSBvbGRkZWZjb25maWcKCnNjcmlwdHMv
Y29uZmlnIC0tZGlzYWJsZSBTWVNURU1fVFJVU1RFRF9LRVlSSU5HCnNjcmlwdHMvY29uZmlnIC0t
c2V0LXN0ciBTWVNURU1fVFJVU1RFRF9LRVlTICcnCgojIEFwcGx5IHBhdGNoCnBhdGNoIC1wIDEg
PCAuLi9ub3V2ZWF1LnBhdGNoIHx8IGV4aXQgMQoKIyBCdWlsZCBrZXJuZWwKdGltZSBtYWtlIC1q
IDggZGViLXBrZyBMT0NBTFZFUlNJT049LXBhdGNoZWQgS0RFQl9QS0dWRVJTSU9OPSQobWFrZSBr
ZXJuZWx2ZXJzaW9uKS0kU1VCVkVSU0lPTl9JTkRFWAoKZXhpdCAwCg==
--00000000000061ec3805e9eb6b35--
