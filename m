Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569E932AEDD
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhCCAGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:50 -0500
Received: from mail-qk1-f177.google.com ([209.85.222.177]:33136 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376833AbhCBINV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 03:13:21 -0500
Received: by mail-qk1-f177.google.com with SMTP id l4so4621477qkl.0
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 00:12:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9+p2yapZHjTorbNIBdyIx0x6qypDFshQK6cKT6IUEH4=;
        b=DoCTiUYPJ9zS67/Uf+VgWYXYpubUpa5q+k9n7QNTRG83DNxvCldpYVJadauA1oOqiA
         4qdDBF7o5c8L7JsIpU3ekyLveCBvC9Ohf8Fn8RZmJrXB6KF8eA5KTKFOfccxwaz+oaZe
         wCv5AnychuRw0o0WIbqH4chq1LP/1PcRpr+5soOEN8pHmJX4JXPHih8fsic9fXyW62Ww
         ELtuauAWrMklWQBBY4yxkEDRKCm+SYxLbF8aoqZJLPqSV9MBQ0MvHOCDPV4yWh3gc9Sg
         URFmdfuS1EEk3RDevFF3w3Qp+Xr50yD2rCfRADWdMgSro1CpmMHK+gUEH2+qUWicA3cg
         x1YA==
X-Gm-Message-State: AOAM531F3PTIqnFD/oEzYpSdG5onswiUA3IjlJbePzGNXbbRc610lhj1
        4et+SxJQn0im00M88kKaAKomVDQX/g1wlw9QLT4JY5zG
X-Google-Smtp-Source: ABdhPJyBMkXKBu0FD9QQmvAKs5oZ/jaOhzdrQ5lK9az/DxBEyj3WcLBJX8jLp8EMQ/NUKhCdPbZ+oUEFPCm/84BRDpw=
X-Received: by 2002:a37:8506:: with SMTP id h6mr18325058qkd.134.1614672154125;
 Tue, 02 Mar 2021 00:02:34 -0800 (PST)
MIME-Version: 1.0
From:   YunQiang Su <syq@debian.org>
Date:   Tue, 2 Mar 2021 16:02:22 +0800
Message-ID: <CAKcpw6Xo9ZsDFP40PH1h9zETwD8MFY=aZ7gDCqV4s4Ld9UVViw@mail.gmail.com>
Subject: backport binfmt_misc: pass binfmt_misc flags to the interpreter
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.12-rc1&id=2347961b11d4079deace3c81dceed460c08a8fc1
This patch can be apply to 5.10 and 5.11 directly.

binfmt_misc: pass binfmt_misc flags to the interpreter

It can be useful to the interpreter to know which flags are in use.

For instance, knowing if the preserve-argv[0] is in use would allow to
skip the pathname argument.

This patch uses an unused auxiliary vector, AT_FLAGS, to add a flag to
inform interpreter if the preserve-argv[0] is enabled.

Note by Helge Deller:
The real-world user of this patch is qemu-user, which needs to know if
it has to preserve the argv[0]. See Debian bug #970460.

Signed-off-by: Laurent Vivier <laurent@vivier.eu>
Reviewed-by: YunQiang Su <ysu@wavecomp.com>
URL: http://bugs.debian.org/970460
Signed-off-by: Helge Deller <deller@gmx.de>
