Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100CA83C2D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfHFVkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:40:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43542 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729104AbfHFVgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 17:36:48 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so42213541pfg.10
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 14:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:from:cc:to:user-agent:date;
        bh=sBUBN0HUJIZIc0mN4TKD7pQCJPPlngOTzkG4tsBEHQ8=;
        b=dqYBXo2iI80lp7HI/aQ+4TEJ3+6YGbaMGSLfCX5yRQ1xyPIxYYF0jAIw7jAvfmZck+
         VVVLR3JPxdakG9bGLYORyCDvj1r8IyC2mfFa5yNhZJJURLDPhGkEBlicdkSZTffCF7Pb
         mG8cqcnXLUN7eRzGjzFocQxh52GYsCIsE8hKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:from:cc:to
         :user-agent:date;
        bh=sBUBN0HUJIZIc0mN4TKD7pQCJPPlngOTzkG4tsBEHQ8=;
        b=am6S2YhlP0HHGgqvevqJPuwFKzyhPC9TO6pMUcANstR00ItCI08KGjDrNxQ5sRz4XP
         4ii67GW+P8P+nduRS14/l76DCxeaOMAcyQHD3357U71sVmVvDRF0hi1dqxb/3Xxk70SA
         ygNbHuxKWqHeD+rRom8gyYCYcwS1xo3V/ewY3DF2kTKCdySSuERlHxUkIf8vMEMolydY
         AlcUQm6TJZwUlpPsd5+Wa55qO0Z8zlQPRA3MtDDq+nPif9l5PmbN3iJ9CPRfcQzbjdiI
         pqJphAdP2C1os3obgrjnC9PX9Z2k1P8jrxaaszZcLZRvhWFN6LwVdbnwHzIFxqZ+Vgc0
         lylQ==
X-Gm-Message-State: APjAAAU6YNDDiogtSLx441I/A95F/ZcbGWw3BJZDUbPoEl6fpGKNX3tz
        M6NtT0gFo74Ae1C8dzh28aZ9lB2WD0I=
X-Google-Smtp-Source: APXvYqx2v/Npwsw5HQ1lbRkveEdPoaGHJWsJF/WOnckfF74AKjXuJJIAxEcpNUNzYFEXHu6vs59ZxA==
X-Received: by 2002:a62:4d85:: with SMTP id a127mr5858389pfb.148.1565127406818;
        Tue, 06 Aug 2019 14:36:46 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id u23sm91643036pfn.140.2019.08.06.14.36.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 14:36:46 -0700 (PDT)
Message-ID: <5d49f2ee.1c69fb81.881ec.1cf7@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190806204752.GG17747@sasha-vm>
References: <20190806175940.156412-1-swboyd@chromium.org> <20190806204752.GG17747@sasha-vm>
Subject: Re: [PATCH 4.19] Revert "initramfs: free initrd memory if opening /initrd.image fails"
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoph Hellwig <hch@lst.de>
To:     Sasha Levin <sashal@kernel.org>
User-Agent: alot/0.8.1
Date:   Tue, 06 Aug 2019 14:36:45 -0700
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sasha Levin (2019-08-06 13:47:52)
> On Tue, Aug 06, 2019 at 10:59:40AM -0700, Stephen Boyd wrote:
> >This reverts commit 25511676362d8f7d4b8805730a3d29484ceab1ec in the 4.19
> >stable trees. From what I can tell this commit doesn't do anything to
> >improve the situation, mostly just reordering code to call free_initrd()
> >from one place instead of many. In doing that, it causes free_initrd()
> >to be called even in the case when there isn't an initrd present. That
> >leads to virtual memory bugs that manifest on arm64 devices.
> >
> >The fix has been merged upstream in commit 5d59aa8f9ce9 ("initramfs:
> >don't free a non-existent initrd"), but backporting that here is more
> >complicated because the patch is stacked upon this patch being reverted
> >along with more patches that rewrites the logic in this area.
> >
> >Let's just revert the patch from the stable tree instead of trying to
> >backport a collection of fixes to get the final fix from upstream.
>=20
> The only dependency for taking the fix, 5d59aa8f9ce9, into 4.19 is
> 23091e28735 ("initramfs: cleanup initrd freeing") which is not too
> scary.
>=20
> Is it the case that 25511676362d8 shouldn't have been backported to 4.19
> for some reason? If it fixes something on 4.19, I think it's better to
> take the dependency and the fix instead of reverting.
>=20

Ah thanks for taking a second look. I missed that we call free_initrd()
in one more case when unpack_to_rootfs() fails and goes into the else
statement. I suppose bringing in 23091e28735 ("initramfs: cleanup initrd
freeing") in addition to 5d59aa8f9ce9 works just as well, but I'll defer
to the persons working in this area.

