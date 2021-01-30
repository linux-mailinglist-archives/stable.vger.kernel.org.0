Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5393092EC
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 10:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhA3EVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 23:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhA3EGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 23:06:37 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6054AC061794
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 19:40:44 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id g69so12216428oib.12
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 19:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Yj6zG2TXVdd+CCj4l0fOPqKE8LHYpPsYri/NcE0ve+Q=;
        b=A1FkhXNDyXJuX0prLj8Bn++oTDx1B4UoYhNOTvGX5MRDSF+XeyBhDwPTK3oXt100su
         dkPBFkJ0CElfacyPoYr18dT3l93V4IKoozKoXENZnjZquAoEdBV2om+yW/Ya8+gf8s/Z
         3TBhWCEUK44pKlztZ1mNrWzr8e/IQcQjrz2N3Y3nb+Y5bgkiWdaSZ3pT3waYUHx7IPJX
         ZyIcKEsWjHGEg+DZuUx6x37o5lNBtbxIOmBaPOptchiOIfQbH6JOwxKvuL0OWZKe5Kau
         5zluf1p04envE1QGVD6ul3teN8aLhQm2jIJg476vpfnKsMDTUdYFjCMC/Fc6d2Vgn2+j
         xszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Yj6zG2TXVdd+CCj4l0fOPqKE8LHYpPsYri/NcE0ve+Q=;
        b=qjzF1jJOCBc/CFR5mNZiOtwnvD9jlkpP0UKUm/5LBMaDvnl3FEYG9qeE33eTp88MXA
         J1hSp38WrXSf6SCW87uIzgLdlydJjlAJhzADHElWmNec5fA0vbr/i1VYnKm+DhWMm9D2
         o+m7QPXKH67JsY4kyK2hL7Old2LA1lfE8WI5vV9yvfVtqBR6u5NVkY16lMeq8VGEgHEv
         YamPribDnJeYB6mstpL35laX14phahbn+hkBbe0U6Oa5UVra+rOV5QUs2KbQLRwB4hNm
         uoyE3EQNFp6SAN4jCdZoyMVoLzZHXVITi1eg/NRxzpWCHR7jnEe1bx5ZzoFBsvRBKYYg
         Vuhw==
X-Gm-Message-State: AOAM532i3aq8FsFPcFP+//9OwDkjLJWeLMTW+UUnWvPeZ2GZXfAkZ9Ji
        VGhOsuiV9w+U43Bq9XXq6Wcu4MPqr55Tx0hpIAJww7yr/e0Htw==
X-Google-Smtp-Source: ABdhPJySeYMOS/ELpM1KwM31MKNXWAsxypvVK0piVQLaca+WtHLixraH1WM4T6NzaspHlLospCx2WrPZag0Fi0gNc3c=
X-Received: by 2002:aca:31c1:: with SMTP id x184mr4417654oix.74.1611978043689;
 Fri, 29 Jan 2021 19:40:43 -0800 (PST)
MIME-Version: 1.0
From:   Robert Hancock <hancockrwd@gmail.com>
Date:   Fri, 29 Jan 2021 21:40:33 -0600
Message-ID: <CADLC3L3RS-fYZXqPB_oZwfoFgBRou8O+5-1p4DetwQTH1UssyA@mail.gmail.com>
Subject: Patch for stable: iwlwifi: provide gso_type to GSO packets
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm told netdev patches are going through the regular stable queue
now, so I'd like to nominate this commit from mainline, if it hasn't
been picked up already (I don't see it in the queue currently).

This patch is reported to fix a severe upload speed regression in many
Intel wireless adapters existing since kernel 5.9, as described in
https://bugzilla.kernel.org/show_bug.cgi?id=209913 .

commit 81a86e1bd8e7060ebba1718b284d54f1238e9bf9
Author: Eric Dumazet <edumazet@google.com>
Date:   Mon Jan 25 07:09:49 2021 -0800

    iwlwifi: provide gso_type to GSO packets

    net/core/tso.c got recent support for USO, and this broke iwlfifi
    because the driver implemented a limited form of GSO.

    Providing ->gso_type allows for skb_is_gso_tcp() to provide
    a correct result.

    Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Reported-by: Ben Greear <greearb@candelatech.com>
    Tested-by: Ben Greear <greearb@candelatech.com>
    Cc: Luca Coelho <luciano.coelho@intel.com>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=209913
    Link: https://lore.kernel.org/r/20210125150949.619309-1-eric.dumazet@gmail.com
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>
