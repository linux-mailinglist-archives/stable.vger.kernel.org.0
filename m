Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A359418720
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 09:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhIZHZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 03:25:17 -0400
Received: from mail-0301.mail-europe.com ([188.165.51.139]:57863 "EHLO
        mail-0301.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbhIZHZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 03:25:17 -0400
Date:   Sun, 26 Sep 2021 07:23:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1632641018;
        bh=A7IcFfvvEgZya5vztjRz7mrm+5JR+9oCS8iFEgJnedg=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=ch48N3+QmTMiKyizs2fVCt0oWGiPjAmsDqHPZoKcXyW/Zd9o1rOtPDmf7fCVfAtSX
         4xPCAr9v1GqVSwPJEYQhkKDYuu1fwOQrtIwMZ5PqiJ5CqYRy10ToC+dlReXAENw1OA
         nZqbr/bqqjq8n2E8MizHs8JI6NcoBl+4NfajTcrg=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: glibc VETO for kernel version SUBLEVEL >= 255
Message-ID: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Earlier this year there was some discussion about kernel version numbers
after 4.9.255 and 4.4.255. Problem was 8-bit limitation for SUBLEVEL
number in stable kernel versions. The fix was to freeze LINUX_VERSION_CODE
number at x.x.255 and to continue incrementing SUBLEVEL number. Seems
there are more more fallout from that decision. At least some versions of
glibc do not play well with larger SUBLEVEL numbers.


# uname -s -r -m
Linux 4.9.283-QEMU armv6l
# apt upgrade
Reading package lists... Done
Building dependency tree
Reading state information... Done
Calculating upgrade... Done
The following packages will be upgraded:
 [SNIP]
Fetched 145 MB in 1min 57s (1244 kB/s)
Reading changelogs... Done
Preconfiguring packages ...
(Reading database ... 39028 files and directories currently installed.)
Preparing to unpack .../libc6-dbg_2.28-10+rpt2+rpi1_armhf.deb ...
Unpacking libc6-dbg:armhf (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
Preparing to unpack .../libc6-dev_2.28-10+rpt2+rpi1_armhf.deb ...
Unpacking libc6-dev:armhf (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
Preparing to unpack .../libc-dev-bin_2.28-10+rpt2+rpi1_armhf.deb ...
Unpacking libc-dev-bin (2.28-10+rpt2+rpi1) over (2.28-10+rpi1) ...
Preparing to unpack .../linux-libc-dev_1%3a1.20210831-3~buster_armhf.deb ..=
.
Unpacking linux-libc-dev:armhf (1:1.20210831-3~buster) over (1:1.20210527-1=
) ...
Preparing to unpack .../libc6_2.28-10+rpt2+rpi1_armhf.deb ...
ERROR: Your kernel version indicates a revision number
of 255 or greater.  Glibc has a number of built in
assumptions that this revision number is less than 255.
If you\'ve built your own kernel, please make sure that any
custom version numbers are appended to the upstream
kernel number with a dash or some other delimiter.

dpkg: error processing archive /var/cache/apt/archives/libc6_2.28-10+rpt2+r=
pi1_armhf.deb (--unpack):
 new libc6:armhf package pre-installation script subprocess returned error =
exit status 1
Errors were encountered while processing:
 /var/cache/apt/archives/libc6_2.28-10+rpt2+rpi1_armhf.deb
E: Sub-process /usr/bin/dpkg returned an error code (1)



Above upgrade works normally if I edit top level Linux source Makefile to
say "SUBLEVEL =3D 0" and re-compile new kernel.

I am not pointing any fingers here, but it seems that either glibc code or
stable kernel versioning is messed up.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

