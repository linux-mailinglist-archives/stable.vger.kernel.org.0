Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD0C2ABFEA
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgKIPgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgKIPgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:36:03 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF387C0613CF;
        Mon,  9 Nov 2020 07:36:02 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id o24so4160965ljj.6;
        Mon, 09 Nov 2020 07:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BymDspjX5fE026/nOFhq1/SuadQ0sbpLGiRBs6f6gSw=;
        b=FdiddKT1BZP9CyX2MZT/+xXv0n0hSlf0um5B5Zjn0i9uN79eaRrqDjzrX51g9Hg67r
         2K2DYl8OwMiMVrvVo3Z5sddJDBpwDh4DvrjXSRZy0AGDcxSYX4pAximuisJe5/aAXb2z
         2+eTDypzKihTIBJ7ohOwJ3CKEv4LgvZPBWvdd92bKZDnHsrvqCGCan/q/FlOEBoNRLXT
         /tLjAmIWrxmArt9y1MxLeBlZyK4rvAGuxt2VTwiZtkhMGPOXWqqSs6KbA6WmcOOIqFXy
         avX+PKkIXecCovJweQQo46f3fYq5evbjhkCxjVmPrivCoUYKrXc7jz13mSo4O5Mg+CH5
         KzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BymDspjX5fE026/nOFhq1/SuadQ0sbpLGiRBs6f6gSw=;
        b=kGwM7DJjctW4L7afJJWsrgBqatOnes2tXpNXqdXoG0mX/sVCocx/YZMrkvPFubSYVH
         LrjlSkHx2wNZBEWS9XcxQX+8ip2FiDtaLQqcJvEbMUsrNVbntYinTQFhdGYBOxlFr7Sa
         wB2gUqSsve2XvzdQ2S6JAzg3YJyLGq63tm0fmwA/MCVTcmSPK79Pvb3yfM/5kB3YYGpU
         zUqWlcoM1p9+yw/634iQj51NazGVPVGNOup51NQy7FhUOT8AoBLBQOseOq4rx1xSjup6
         uECjP7DbxS9HpK3Zimtb0w4npHd6vU8SbsVQo0lGplSGnwdgLgLPaoV42mmXmyi177BY
         j/sw==
X-Gm-Message-State: AOAM532pJJzIAZ83Kon4aEh8NYyextPxKMQaD98EyQdwMGdXhcZeRWWP
        5itJ+Ug/tCgQVVJ7UXOhLrycDOFCXsGbmx1hPQg=
X-Google-Smtp-Source: ABdhPJw3Nyyo9wLHpw7H6lRN4lD8FYXR9hfq9Uc9UfFcJWrpjboXLm93ZZBabu7Of1oPhQftuYznEkwT+/Pn+/e/xrM=
X-Received: by 2002:a05:651c:512:: with SMTP id o18mr5951618ljp.315.1604936161129;
 Mon, 09 Nov 2020 07:36:01 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201109084225epcas1p3522cb6e6b277e76055403b83f6b55a2b@epcas1p3.samsung.com>
 <20201109083533.2701-1-namjae.jeon@samsung.com> <87v9eetxz0.fsf@suse.com>
In-Reply-To: <87v9eetxz0.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 9 Nov 2020 09:35:49 -0600
Message-ID: <CAH2r5mvirJ-ROh=qKUZW4SaWT1=CL3nvAeByBaYD0zcFEENMTw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix a memleak with modefromsid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Nov 9, 2020 at 8:18 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
