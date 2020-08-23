Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2D624EF61
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 21:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgHWTKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 15:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgHWTKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 15:10:40 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CFAC061573;
        Sun, 23 Aug 2020 12:10:40 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id x142so1519822vke.0;
        Sun, 23 Aug 2020 12:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fixgxjlxG7QIXPN2YxGkMRUK38NeMqUp1q0BJiriqbQ=;
        b=o6X078F9Vb4O2HdbhUp4hPe9uGR1cNzRDBlHAOgBld/Jt2QkD4Yjm+LCFZ7YwP50oA
         C4KnFGhz6QjN9I1JTKyej5Yw/t2Mr6BhPpQGz+cM+Z3cctEBNqK7Cz+lIOUVmSCrm4NM
         DUKNib2DZulPwClSk8r+VSavYfZzBnA75hLcEa9/UedL0vXxoyCayOkziKLvpienRzki
         +pSG5DAq5XzXLQMB7HH5MgYvWdqIxds7Jqpxr0olzIhh4RIHphFdTOIR6c1VDGm1EA50
         xK0FKPoV7/xU1vNuGdPTUEk3iqd1IAQGKZ14+6OjjoQ6CuhLPh8lP+CQAi6NwpU4ePWg
         5RLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fixgxjlxG7QIXPN2YxGkMRUK38NeMqUp1q0BJiriqbQ=;
        b=sD8fEJXI9SFchfVTo7jcf60+VSJK2bICjE9Dhtre//ipbtkQhZo2x7laTQa/iDqFiN
         BEdKaGoJ/TbkHF1wAAMXSlriP9QkpGLYLOMmc3jg8zWY44eRQd6lEHgr0znDczADXYJr
         LIMfgN2/+4Gu4bTJNe9oSWNNSw8ga3WvGDdLJrm3aJBd3V6IST4i29oH4HFG7zqV+NyW
         Q0N99xqx36kRlLaCDF10v0BBgIXVN9jwvH+lBeFjIjABb4SL9wKhvw9DN0EjO3fWfuGI
         EQHWIcb7kzY0lx04Cc2/nDfcBEnAb2j8mhZIhnZnuTXdk9d9xl/+k6f5ihaydDD3+Olm
         5FfQ==
X-Gm-Message-State: AOAM533FvRbGq7Kbj+BxrVYXNstUWt1ant8+scCWGmko+eVrIcfvBuzV
        6M+MNQJKexDssQal3s7E4ZvWVx2BpOU9zM1/dTyQOIV3ypI=
X-Google-Smtp-Source: ABdhPJwmDqC+ZQlbXBXeT3R9Gfjh/ah+Or2kyGL6qa63ZORihLmlGDsR8lJSysSVo0Cdz1G/obICbLNeN+EXfzefHes=
X-Received: by 2002:a1f:1ad6:: with SMTP id a205mr936226vka.67.1598209836836;
 Sun, 23 Aug 2020 12:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200821181731.94852-1-christian.gmeiner@gmail.com> <4dbee9c7-8a59-9250-ab13-394cbab689a8@jm0.eu>
In-Reply-To: <4dbee9c7-8a59-9250-ab13-394cbab689a8@jm0.eu>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Sun, 23 Aug 2020 21:10:25 +0200
Message-ID: <CAH9NwWdLnwb0BiR6qAHKFexFm2NJkpHv7Z7YAdQ7fJBVxjGH4w@mail.gmail.com>
Subject: Re: [PATCH] drm/etnaviv: fix external abort seen on GC600 rev 0x19
To:     "Ing. Josua Mayer" <josua.mayer@jm0.eu>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        The etnaviv authors <etnaviv@lists.freedesktop.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

> I have formally tested the patch with 5.7.10 - and it doesn't resolve
> the issue - sadly :(
>
> From my testing, the reads on
> VIVS_HI_CHIP_PRODUCT_ID
> VIVS_HI_CHIP_ECO_ID
> need to be conditional - while
> VIVS_HI_CHIP_CUSTOMER_ID
> seems to be okay.
>

Uhh.. okay.. just send a V2 - thanks for testing :)

-- 
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
