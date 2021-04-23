Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACD536985A
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 19:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbhDWR3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 13:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243395AbhDWR3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 13:29:23 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C8C061574
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 10:28:45 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso44031484otb.13
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 10:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WINQSE4n8WgwcJi1pzBEzAMfZcLpiFVcDom3BjdFl4c=;
        b=eCu59b1uXkBlKlanxAQZddn2bf3BdZWmZyi/KoZ7XAPCeiIclWoX9tVMc0YIXwNztC
         vTyzqaoimmUS/MeKhvwDM1BxEx9kyUTfgCl0+MRNZ9COH4jL2Ks9PwAz1pTCy9glgbl1
         d+6HxCwMIqZz40kYCgpXOdqLL7zuA0ksS3drxlcGNKMcWiXydUO0iaYMLKYhX9nTzgqr
         Ub8bnpmqGLugroG9dzwiwP52lge2+6w/rSz53Lne/mnCMJFnsIBP4pa9McW0viuStF5y
         YDfZxyKsEz3/BpDzHPAypCl1gBv1v/L3rdoFdd84GAccvTmynzNyMi4g5ga13HE4R/2J
         C+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WINQSE4n8WgwcJi1pzBEzAMfZcLpiFVcDom3BjdFl4c=;
        b=BqYP5/FIJjDT0XDL0rz1U+b2hUIvhIDjrL4jVhGTMkDZs0+3mmz7G5omUU5doW65sY
         /e83XcqwYo+VI0nbQtNZMPjfqFsSnvG2dIDitstuhUJNuqHnc5D6az5njwbW3Ym9Kwig
         MB6XC/GOU7WD73hNXkvUpZgutq+wOINx9jRprFrme8t4YRosz+x4v872tHQjeXZknY6X
         oylB+q4rH84b2ldAF/ugIz4BqAWp975PvoBEUFIf4U0bE6SZG4zYpE57jE6l8Abhqy3c
         wYMXCqy2KUINZVBlGxvtFeWZNA/sa9aQp0W4j5dOzZ59+MOqDQUCHJinQrEBpYFkQJH3
         r7/g==
X-Gm-Message-State: AOAM5320VrUjqR4QBt3KPg4STzgrRM0bSXKJHeL2Gfb/pNZRqCeGNzic
        scX5mz5qmFCdGH4VO3iYCuYRDJp+BO/iJZ9dvGz6m5W3nXa04A==
X-Google-Smtp-Source: ABdhPJxut0vC40puZMMkcU+W3L1IOmKmVeFKhxHuoW4dGp0VWzK8NVgbiqohSuHUcF89WNX1C6dj5AIPeEi8u9qhg6Y=
X-Received: by 2002:a05:6830:154f:: with SMTP id l15mr4109885otp.182.1619198924571;
 Fri, 23 Apr 2021 10:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com> <YG2q6Tm58tWRBtmK@kroah.com>
 <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com> <YILkSsR4ejv5CraF@kroah.com>
In-Reply-To: <YILkSsR4ejv5CraF@kroah.com>
From:   Jianxiong Gao <jxgao@google.com>
Date:   Fri, 23 Apr 2021 10:28:32 -0700
Message-ID: <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> How?  Anything that installed 5.10 when it was released never had this
> working, they had to move to 5.12 to get that to work.

I wasn't clear. The bug is not specific to SEV virtualization. We
simply encountered it while working on SEV virtualization. This is a
pre-existing bug.

Briefly, the NVMe spec expects a page offset to be retained from the
memory address space to the IO address space.

Before these patches, the SWIOTLB truncates any page offset.

Thus, all NVMe + SWIOTLB systems are broken due to this bug without
these patches.

I searched online and found what appeared to be a very similar bug
from a few years ago [1]. Ultimately, it was fixed in the device
firmware. However, it began with NVMe + SWIOTLB resulting in similar
issues to what we observed without these patches.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1402533
-- 
Jianxiong Gao
