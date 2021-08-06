Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8773E2B49
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhHFNZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 09:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbhHFNZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 09:25:44 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7A6C061798
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 06:25:29 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id m1so2058283vko.3
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 06:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mAp/YU7YbZhVHcagsnEsyD+GOIbUBv7qqxlx4NSPZhY=;
        b=MCV8YEZcM7FAkpHW7E5Gmfs2DaEeDauO59XvCg6+OAtpHw4/174ErcDZaP1d42Xq3Z
         vP3/68lyi5sbjZVe2iAoxp3jQIM7T5FFoQnpCzFEwbuUWZV7aOQMBatIc94nbRLAgwvf
         oH+gnOXpSrjqeEElmdo59U7JFiLkIp0yLGUeiOf/7gY9LoJYOsSx+7/S1my1AHzEevPm
         2LHEf5ZnPFbGt6qlRpcrSEq9bzB5vSIHYexW/Hyj4aYNh6u2FhQT0MlK3ZIRe2+RO8Zs
         dCozbLWwDeZ+71OwXti4jAtHoSXh5UbcaZ9zymWn4515AGAz+G7sCVRwCbkfyIGWluQM
         U4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mAp/YU7YbZhVHcagsnEsyD+GOIbUBv7qqxlx4NSPZhY=;
        b=G2O+vR+6W6kGNAHyDNn5Vc3MPkatx3pAE86qd2Z/IpaGfBU1dHpY5kelyWYYWZQLSu
         uwKaHZnAap4pkcOPrmtwXsAcfDWyAKNhjSiheStdfpQjOpnrrBPSOBMEjLr8qv7q3Qce
         SeQ2EWH/aPDOUuch952OI+DTsKfnxKRYXs5epGEQs4w/7e8bEFVeB2GJftoRfUPX6EoG
         bz1VbPVzSxWtlMzCnMxUteJ1fg1qmsXIvrNHx1gd7VwqFcPtkQPoLBFheKKd5RKuaTIb
         AlAN7FtnyLKUKE6aFiVm/bE2e5UYZV4Xfgw8V8zCl+raVA2a7KhPL3BW+DwzrV6T5uGs
         3JkQ==
X-Gm-Message-State: AOAM532eRMI0wgJqC3Yzso8j6TxUAIyZ5+JwBxkj2ZA0Gt//2t8x8x3I
        mErUZxNR+QLTMNc5SqISHsZwBmkbOvJE7Q5mCDkn/gMTuzHdH2pp
X-Google-Smtp-Source: ABdhPJzeSRzBMv0m6HdMA/pPnc8v24xIlKSgP/J8CHil+F8D4JKH8O0hlMJW3sTdv/KIg+u7rHY4SL4uaB9aikvdm9E=
X-Received: by 2002:a1f:3651:: with SMTP id d78mr7698018vka.0.1628256328354;
 Fri, 06 Aug 2021 06:25:28 -0700 (PDT)
MIME-Version: 1.0
From:   Sam Protsenko <semen.protsenko@linaro.org>
Date:   Fri, 6 Aug 2021 16:25:17 +0300
Message-ID: <CAPLW+4nyWAp99CTVy+wJ0rnbs9JpDvNaQaVityJi=sVPTkyDSA@mail.gmail.com>
Subject: Add "usb: dwc3: Stop active transfers before halting the controller"
 to 5.4-stable
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Wesley Cheng <wcheng@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Suggest including next patch (available in linux-mainline) to
5.4-stable branch: commit ae7e86108b12 ("usb: dwc3: Stop active
transfers before halting the controller"). It's also already present
in 5.10 stable. Some fixes exist in 5.10-stable for that patch too.

This patch fixes panic in case of using USB2.0 Dual Role Device
controller, as described below.

1. Boot in peripheral role
2. Configure RNDIS gadget, perform ping, stop ping
3. Switch to host role
4. Kernel panic occurs

Kernel panic happens because gadget->udc->driver->disconnect() (which
is configfs_composite_disconnect()) is not called from
usb_gadget_disconnect() function, due to timeout condition in
dwc3_gadget_run_stop(), which leads to not called rndis_disable(). And
although previously created endpoints are not valid anymore,
eth_start_xmit() gets called and tries to use those, which leads to
invalid memory access. This patch fixes timeout condition, so next
call chain doesn't fail anymore, and RNDIS uninitialized properly on
gadget to host role switch:

<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>
    usb_role_switch_set_role()
        v
    dwc3_usb_role_switch_set()
        v
    dwc3_set_mode()
        v
    __dwc3_set_mode()
        v
    dwc3_gadget_exit()
        v
    usb_del_gadget_udc()
        v
    usb_gadget_remove_driver()
        v
    usb_gadget_disconnect()
        v
    // THIS IS NOT CALLED because gadget->ops->pullup() =
    // dwc3_gadget_pullup() returns -ETIMEDOUT (-110)
    gadget->udc->driver->disconnect()
    // = configfs_composite_disconnect()
        v
    composite_disconnect()
        v
    reset_config()
        v
    foreach (f : function) : f->disable
        v
    rndis_disable()
        v
    gether_disconnect()
        v
    usb_ep_disable(),
    dev->port_usb = NULL
<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>

Thanks!
