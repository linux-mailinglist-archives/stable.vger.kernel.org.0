Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E18117CDC
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 02:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfLJBEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 20:04:07 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:38891 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbfLJBEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 20:04:07 -0500
Received: by mail-qt1-f170.google.com with SMTP id z15so1177681qts.5
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 17:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=lvaBXglD3Me5cNqFIlUfSPJqoa/gW/7ZAnezNsBsRcI=;
        b=ISIo5rwAyov+eSUxja+pid6lib/Y081LMXa+YEfD9J3yhwio0Z64adkVhgRbUsW55u
         eMR8s/ZgcdepKCcnfrJsZuuQFTF4naW8mkKaqsjYKFStipeZcd8gFUdUYkTc/IaipJNe
         Ja9507Pgznp6rod7JJBPTFXWJaXv6S2fdO97TFMwwIREyPg4ofNIv2nP5YgwWWO48nDK
         Xcz9BsI8pLbib4DSzIk/fb+S+8z7Rb3HwBON8wUKpnPyL+4/pZR0Is34khSxjy8gflMF
         ukI3N+qG7UCy3uVEYY8RftCiSKQ/ZKyX17zt5eYJwxxnp6mnliXVs0/QnEP/xmObE9db
         NOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=lvaBXglD3Me5cNqFIlUfSPJqoa/gW/7ZAnezNsBsRcI=;
        b=RRfy6WEA3L1+zLCKdlQzGkcW7pVILt9U0EhyH2IpkV01iyMJrBkuLG6wVt8X6F4nMI
         byvmNSWpR0qrIldKlTpnhevlQIZMdAZXSLgMZIOb0ovcSLBtfLue7r2VfJU1iN+CZXE5
         AxjLx8TuoxYyd9DmgKQhSZeKwx+ucb8IWoJYBM7Qlz9IrSDinoWGHHjgvSS83q4Rvc3J
         c4qwUE367qcN7UFvqd/qJIbtWeAFq1XK9BxnzK3r9BkzaarxacoY/vC12Vx9iZX0RyGr
         rm5HB1PFFg15zZ5IsAuB/xWQet/q8tSlvZOPIHOQUAuG5CKYgp951XkCtPQHv6AYi9Fv
         blbA==
X-Gm-Message-State: APjAAAV5ZhGsvTuMHnfN/yQ766ZFBGZo8+QpYNKPuYyZopkuEwc+JWLa
        TngFmHAqAZB56f10FwHdyhQXO/rgYt3l2pfpMzPaBqbwN50=
X-Google-Smtp-Source: APXvYqxvwkJTFvmrAufvTWRY1jLKTJL9kpFOnkXPnP0T1TQBqOFhVjQfoUEInQLWA8RbYcCSAg3Pn7LBplM3dQloZNo=
X-Received: by 2002:ac8:327b:: with SMTP id y56mr27592885qta.161.1575939846135;
 Mon, 09 Dec 2019 17:04:06 -0800 (PST)
MIME-Version: 1.0
From:   Brian Norris <briannorris@google.com>
Date:   Mon, 9 Dec 2019 17:03:54 -0800
Message-ID: <CA+ASDXPfK7a8RYdg19nga59QwNkovo7Dt2VOqsCa5vLsc2F-SQ@mail.gmail.com>
Subject: [REQUEST TO BACKPORT] mwifiex: update set_mac_address logic
To:     stable <stable@vger.kernel.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        sharvari.harisangam@nxp.com,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'd like to request the following commit [1] go to -stable. It fixes a
regression (as far back as kernel v4.17) where the default MAC address
is computed incorrectly. This can have pretty nasty effects when
upgrading kernels, since people don't expect their HW MAC address to
change.

It probably should have had this tag, for the record:

Fixes: 864164683678 ("mwifiex: set different mac address for
interfaces with same bss type")

Thanks,
Brian

[1]
commit 7afb94da3cd8a28ed7ae268143117bf1ac8a3371
Author: Sharvari Harisangam <sharvari@marvell.com>
Date:   Wed Jun 12 20:42:11 2019 +0530

    mwifiex: update set_mac_address logic

    In set_mac_address, driver check for interfaces with same bss_type
    For first STA entry, this would return 3 interfaces since all priv's have
    bss_type as 0 due to kzalloc. Thus mac address gets changed for STA
    unexpected. This patch adds check for first STA and avoids mac address
    change. This patch also adds mac_address change for p2p based on bss_num
    type.

    Signed-off-by: Sharvari Harisangam <sharvari@marvell.com>
    Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org
