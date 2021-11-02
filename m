Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0757443794
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 21:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhKBVBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 17:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhKBVBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 17:01:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C8BC061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 13:58:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id o8so1995409edc.3
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 13:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=nQ4TmEGdHGtZ8eSf+30RVwu+EIEddOETeTJzWP6fwiQ=;
        b=gwwkiIsM5+3GLlRmF4qTBbMZG3V/4OzLTewFtpLdLeZe6frpH4lSZsGGbPZVwqZTj8
         JhkBQL5M8gwpzoMm4pKUWeWikD/G9IJzxTkrgxbik5+coZ7UOoBP+do0yBkctFVYBR/E
         Eai8VVpxXCiEKYqS0545+slZXWEnnAvCVf3rCO7piFuR9glxBIDZ3VR+reAaLdyRVnQq
         xVQ4R3rSvNxBI+c6raZWDJpdZQKbKxeNW9zO4n7K2bAXn0RbomFAY0IgiweXaZ4sn6NI
         ln6dsGIr6cxrYQJDJMAYxFPKItpeaoHX866UvET8VcRkhufl0R5XEnslL2lK1ZT/B7Dv
         xEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nQ4TmEGdHGtZ8eSf+30RVwu+EIEddOETeTJzWP6fwiQ=;
        b=aYZWvssOS7SNOlNa3YPsOUwYcRHLC/Xeb7s7ZXmEFrVg0lbPNmJTf0uiwRbVimgbIx
         zDSYWioMTqvkgexQrMAytfK+RGYhuog1Ln8kgIX9vRuTxhN/6gXeLHnRaGKPWymz9jqi
         x5o6bJOElETIOxVMxD9X7b4b8gpnGmp+Hxb3IhHA3pYNSqheicVv89qzNTp4Dgt4LqfH
         59mauf9SAn08OGtAhW63/8hh9CA/kzqEtmkF6T9dKCyNd2+ERP6yUojnE91fhX0DP6U1
         +vY55LgrJOdX0C9l3AHU/qOktU5J5CG288eYGL9UBsTLFGvBc9xakqqfl6yQ++/+8Yd6
         7jpw==
X-Gm-Message-State: AOAM531PMl5gLHWOtScZz5tvupRr6JojRj8Oet8OiPy8DPbjul1fuhKm
        +km5kJziXxDI3akqVPzbV1NxG1rXLgaMjScRhasuAcdYtQtxlA==
X-Google-Smtp-Source: ABdhPJwPJNeIWSW+peNKJSTsSWtZtYEXl3BC2cwp+rJardmpghlwN5aFiTNwb/HudIfZxPGp9vWbrADd8nowW9l4K1w=
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr24629431ejc.507.1635886713414;
 Tue, 02 Nov 2021 13:58:33 -0700 (PDT)
MIME-Version: 1.0
From:   Erik Ekman <erik@kryo.se>
Date:   Tue, 2 Nov 2021 21:58:22 +0100
Message-ID: <CAGgu=sBsiSVgr=uR95ZXFTtziLUO_LS4CW+6n2p2iBWxf2aq6A@mail.gmail.com>
Subject: sfc: Fix reading non-legacy supported link modes
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 041c61488236a5a84789083e3d9f0a51139b6edf

Initially this just fixed 50G and 100G modes which felt rare enough to
not apply this to stable (also it got merged before I really had
thought about it).

The testing mentioned in the change was actually from my development
of c62041c5ba ("sfc: Export fibre-specific supported link modes"). I
failed to mention the link between the two changes however and this
commit ended up in net-next (just merged) while the second ended up in
5.15 via the net branch. The result is that for 5.15 even 10G cards
only show 1G as supported:

$ ethtool ext
    Settings for ext:
    Supported ports: [ FIBRE ]
    Supported link modes:   1000baseT/Full
    Supported pause frame use: Symmetric Receive-only
[..]

So this commit is needed at least for 5.15 to fix that.

Fixes:  c62041c5ba ("sfc: Export fibre-specific supported link modes")

It can also be applied further back if we want to fix the 50/100G
modes (from v4.16 I believe):

Fixes: 5abb5e7f916 ("sfc: add bits for 25/50/100G supported/advertised speeds")

Thanks/
Erik
