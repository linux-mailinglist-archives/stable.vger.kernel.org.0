Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44ED73949C5
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 03:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhE2BMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 21:12:05 -0400
Received: from mail-0301.mail-europe.com ([188.165.51.139]:42491 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229563AbhE2BMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 21:12:05 -0400
Date:   Sat, 29 May 2021 01:10:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1622250625;
        bh=+w5DrFGtQT7qGSjGuDnH/5/WNWgRUzVCn8cxpkKg+UU=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=R9WETm0fyZJzkJ3UkIhI88VJVw2PneoVEsKtpATIg/MSMvGzx9WW/J/YwW0XLLhju
         w586zYWrm7sLSPr6V9af+jdYDQUAI4r9sbtk+FZbUx2wn62l/Htz2dz0mtbBEWy3tp
         ylZwW0a2r55zLl7TcHcxCkwy4RyfOxjDlc+NTflY=
To:     "namjae.jeon@samsung.com" <namjae.jeon@samsung.com>,
        "sj1557.seo@samsung.com" <sj1557.seo@samsung.com>
From:   Aidan MacDonald <amachronic@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: Aidan MacDonald <amachronic@protonmail.com>
Subject: exFAT unexpected handling of filenames ending with dots
Message-ID: <WCLW4rMlL5bsun3xz4lbVpKFcjJnaWwoKKvl-QPTF1YEaDtDX5uS3Pj472UxXuxgBnDbznfc0MpYj5fsCzLuhnbStgEN7jHv8Q_Ynxy3kFk=@protonmail.com>
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

Hi, Namjae and Sungjong,

Recently, I was made aware of a problem with how the exFAT driver handles f=
ilenames ending with dots.

Original bug report was against an audio player supported by Rockbox:
https://www.rockbox.org/tracker/task/13293

Upon further investigation it turned out to be a Linux kernel issue. Note t=
he audio player referenced there runs Linux 3.10 or so and uses some versio=
n of the Samsung exFAT driver -- so I guess this has been an issue for a _l=
ong_ time. I was able to reproduce it on my laptop running v5.10.39!

It appears that any number of trailing dots are stripped from the end of th=
e filename, causing some interesting bugs.

The behaviour I am observing is this:

1. If creating a file, the name is stripped of all trailing dots and the st=
ripped name is used to create the file (original name is silently discarded=
).

2. If accessing a file within a directory, the stripped filename is used to=
 conduct the search, ie. if you enter 'A...' the driver will actually searc=
h using the name 'A'.

It is this second part which causes problems. If you have a file named "A."=
 on an exFAT filesystem, it will show up in directory listings but if you t=
ry to access it, you get 'file not found'. That is because the driver is ac=
tually looking for "A" even though you think you are looking for "A." -- an=
d even worse, if "A" does exist, the driver will silently access "A" instea=
d!

Clearly due to the first part, you cannot get into this situation without u=
sing another driver -- like the exFAT FUSE driver -- to create the problema=
tic filenames. (That's how the Rockbox bug reporter managed to run into thi=
s.)

Now, a function called exfat_striptail_len() in fs/exfat/namei.c is respons=
ible for the filename stripping, it simply removes all the trailing dots fr=
om a name and I guess it is the cause of this problem. So this 'feature' wa=
s intentionally added in.

I've only skimmed the exFAT spec but I can find nothing in it about strippi=
ng dots from the end of a filename. The FUSE-based exFAT driver appears to =
treat dots as significant too.

It seems Windows suffers the same trailing dots bug, silently accessing the=
 wrong files despite listing all names correctly. But I obviously can't say=
 whether that is due to filesystem drivers or issues higher up the stack.

To be honest I have no idea what the purpose of this 'dot stripping' is... =
even if it was for the sake of "Windows compatibility" -- ie. mimicking Win=
dows bugs -- there are names that Windows normally rejects which the in-ker=
nel exFAT driver will accept, such as names with trailing spaces.

Personally, I don't see any issue with how the FUSE driver behaves. It also=
 seems to be correct with respect to Microsoft's official spec. I don't see=
 why Linux should deviate from the spec, especially in a way that makes it =
_less_ robust.

I did search for any other reports of this issue, but it seems to be such a=
 corner case that nobody's mentioned it anywhere. Nor can I find any discus=
sion or rationale for the dot stripping behaviour.

Kind regards,
Aidan
