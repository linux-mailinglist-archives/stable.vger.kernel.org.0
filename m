Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C02B30229B
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 08:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbhAYH5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 02:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbhAYH4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 02:56:41 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1D2C061786;
        Sun, 24 Jan 2021 23:55:46 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 19so11682723qkh.3;
        Sun, 24 Jan 2021 23:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HQfuLGY7+zwlDZhEg0OVcwQeT0assScp36yMfVSg3oQ=;
        b=CDAsSmmGGLHyrV7qmnqiaXRBNktT5aiE2Jq9jbYyXc7uncggROhQvZ9ZJmR4Xe452t
         y07O4FvZ287NIE/bjUM8hPOi2Zz5IZMbOXSQag6gNMbP0qkP7BibYQ74df/1mkbD1Lwj
         HdhJ805awRUoBSdzXnUjapwjeJj0wXidD4eU9jd9S1xy7iVzYheMKrjILck3v3INyKfn
         KbYeizeCSpXdGQt45JdkGkmQmQIaIsCuvcNLbxk0/iFguutGDeM+5MC9XU0P0k+Fziaw
         KCMxFOH0cAuovZnTFFADL0OsVZdV6a2QjE+3ehozQLqR06Ydtz0u1CWJttjwDihEl7y0
         ZoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HQfuLGY7+zwlDZhEg0OVcwQeT0assScp36yMfVSg3oQ=;
        b=oT/1wrnFZY3Du6HUScwQlt+5z8VOhRSx6O1EPFVugVgXzSelkVMioiS+KXA8jSUQG5
         rugYyKIL4DCr378CxylDMcg7fN+dQ1G92mAu7xzqvBKYIqmdZ6Bp1F7m+OmapBI8gSth
         nVSTALIFj/WttcbpZIxapucOyQ+LXGi1XtIf9PORApHIzGv09X86FrbmakuDn3O9p8x5
         BHjlKMhLQ2v6kU0RE0Yly9uH8utZRupdwklHQoEMIw4VxNAjPvymWIMIPFKBCixRmztX
         9U98SpyOjjD9dV+LeQgqa3bsPOz2M+DyARCLEIlLDsDF0tg14FSzLbU+Jqe2VaLKzsZv
         RhqA==
X-Gm-Message-State: AOAM531aOCW7MYTnP7qC3UtSP9stBUO/XGuEgp2LQhrwk+mnmh54fbxL
        qgWVq+5/VgVqFZhb5b4j6EsaSqLgvHzrxMjKpGFgn30yfNM=
X-Google-Smtp-Source: ABdhPJwmg2MPDDk4q2QlROEE2AVJmZ/FfSYRqacNcDz1SW3eQdSbnXPO0bwxNnEesXXxgl+uGB6FqbLDg5c2GZMGRPQ=
X-Received: by 2002:a05:620a:46:: with SMTP id t6mr1483533qkt.108.1611561345329;
 Sun, 24 Jan 2021 23:55:45 -0800 (PST)
MIME-Version: 1.0
References: <20210122212229.17072-1-richard@nod.at> <20210122212229.17072-4-richard@nod.at>
 <5b51ff9c-8f5e-c348-5195-c0a0bf60b746@huawei.com> <cca6ac4f-4739-76be-9b48-b3643017a556@huawei.com>
In-Reply-To: <cca6ac4f-4739-76be-9b48-b3643017a556@huawei.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Mon, 25 Jan 2021 08:55:34 +0100
Message-ID: <CAFLxGvyHL5AMWcfLQg2fS6Nbp255yjve5nJ83ELYHnPhKp6Wxw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ubifs: Update directory size when creating whiteouts
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        David Gstir <david@sigma-star.at>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 2:12 AM Zhihao Cheng <chengzhihao1@huawei.com> wrot=
e:
>
> =E5=9C=A8 2021/1/23 10:45, Zhihao Cheng =E5=86=99=E9=81=93:
>
> >> @@ -430,6 +433,7 @@ static int do_tmpfile(struct inode *dir, struct
> >> dentry *dentry,
> >>       return 0;
> >>   out_cancel:
> Still one question:
> > Does this need a judgment? Like this,

The idea was that in the !whiteout case, sz_change is always 0.

--=20
Thanks,
//richard
