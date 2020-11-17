Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936C82B5B2A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 09:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgKQInN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 03:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQInN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 03:43:13 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A783C0613CF;
        Tue, 17 Nov 2020 00:43:13 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id p12so15075687qtp.7;
        Tue, 17 Nov 2020 00:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vhcWJPRmwnyAktqJFg6VjCws4F5oNwFTI81s3btZ1OM=;
        b=DfezVDVfhb84xp/Km9GkegWy54khhoc9y0IusLI+wzxmpnqmxAzHU218ZXgkLkMIz5
         BsnRERpjSRFKAy+AtZdnde2f52C6HpAj2+ukXwAgDqLY+8OmX3pXpJboUKYiyzz5o5vs
         jPCkPbfIjqdT2oXOMJ5QPhD+y9pgSOBE5ELSP46UmNlKFNlxNKW1PAtqHjRmPpjb1pwJ
         d3e3y6QvymzJeMzAkN7xVEJhmxRRpHf8kCM9y4U370w3UR3BwRc4ObKe+LwaO02mTSPf
         2Op/zrs0dRmJPI3P6fozyP9tK4UR+AQujuwHiP5XvCA7Yc/MR6AQwJrmmSccG3wcvcun
         rH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vhcWJPRmwnyAktqJFg6VjCws4F5oNwFTI81s3btZ1OM=;
        b=VQ9y56zbU/q8t/sIpXSx+uuv10cSC3xkdnFt7MXx8SDFHikv0CFBf9I9iTiwFjaVKY
         WeBlctvZs2mRICPm6pEvHRZCtQk6RDbFTJb+XjCGys2QpXzOrEWYrbWySfFTFSs/6cNN
         QRaH3dqjDzjLpXk+nP1699rKVO+7mShgdnkVgUn6TEG141LTvRkYQdWvlMyBkpZ8SZH8
         PGCySZvQRY+0HLXgClJuyHZRdpZ5r5Fh5ya7rVViOK6dFacITjolxA1wlA2TkgYdrDf+
         cXXKnkkaKn5A+SDvpMeUHOG6+g2b17zdl1XsT8T2sRmM9RuRBSfQCE4NGXC9jLJ2Bnw4
         GEYw==
X-Gm-Message-State: AOAM530hXo8BZnXwY2Cb/rQnI2+1snUsSlEaHOLfz/ic4vgtXolSm6zx
        C2js2aK2aPRXJccEhG4Lbozr852IrGGoE4qnNrA=
X-Google-Smtp-Source: ABdhPJw21O9B1kvB74uYZQfaYMrQy566SAPOOyjE9UAiA9CMYhny4t8wfaCwDgDaCWhs4tg9Rv1oPIJc77zehB643vU=
X-Received: by 2002:aed:2843:: with SMTP id r61mr18312246qtd.166.1605602592483;
 Tue, 17 Nov 2020 00:43:12 -0800 (PST)
MIME-Version: 1.0
References: <20201116210530.26230-1-richard@nod.at> <bfea268f-b5c2-5467-7b17-5eef7b0269ce@huawei.com>
In-Reply-To: <bfea268f-b5c2-5467-7b17-5eef7b0269ce@huawei.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Tue, 17 Nov 2020 09:43:01 +0100
Message-ID: <CAFLxGvy4_H0rn085j9=o2kW2X0rHcRJVMSAbp8OyYVVFhTcXpg@mail.gmail.com>
Subject: Re: [PATCH] ubifs: wbuf: Don't leak kernel memory to flash
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 2:28 AM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
>
> Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>

Thanks for reviewing, highly appreciated!

-- 
Thanks,
//richard
