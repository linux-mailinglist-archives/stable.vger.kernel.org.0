Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C613EA945
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhHLRRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbhHLRRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:20 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44385C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:16:55 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id w20so14761502lfu.7
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xqu5QsUBWhsZQuDFWZyWN5xmhdGjzHzUF2uLpn9S7sM=;
        b=QUli+GNeE+g9unl1LvBz+AVQTmPd5eGdswKBBd7rAUbVHY2nMM8PUmo7FYnZoTSp+R
         YlPQSux8ysbTpnGXCAX5IsagKckVxjuxslBmW3N0c0YiHDcKo+GNj1cmzE1oU734hVZv
         /GENUwio4o89ZsqUTjNdF83W+K4d5SztfS5Fgntb743SwLVwkTd6L0YlQl7RGXLloS3V
         XOmiJ5rqPAjbPSdzrMyTJVYx/BqGiBPJQ+j1d4RL2gFsMqsg/vRhw9L7efxUi4P8SvHa
         lUVGS1lXHu2Nbr/OKu9+IKvC6a7uAAUMEgZCUwO0Exf05ni8g3puVnBK68t907sHi785
         wuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xqu5QsUBWhsZQuDFWZyWN5xmhdGjzHzUF2uLpn9S7sM=;
        b=GJA939Ex6nB3Qx3/TNBMo9ZtdgK/PLUZ2PKN3Ro1chbXEBOrmJ7dnBK5vw6weO+Lzv
         tUUb04MYR1Lj8s4lPslcRzqmA4bRR/N4FaxsjwulAC3odRLhL5VD/9G6h0MJSiwFL42E
         NtLaC7IHFcCE5L8AujaRxhPUKKJ7mCbnH7vvuY0FlI6bAe6qqOsF1t16TdNNTQGZBvKA
         NYVRIC1PVzRVoTFm7Ae6wOoSo6IJSQxdieVvUs2blZUFLPnBARUnm5oyiw7xf5iH1zW9
         8BDrS8UcDXRS6GlStGimVt955H2kGXrwXsDuzvpjU5OFZybOXfUCNCiHc4uui/KWGJeU
         We9A==
X-Gm-Message-State: AOAM533PD8AJL6L2+sNuFraanj5apOaYUsMLAZ7cgdevHxS9Npa2WsF4
        jMoiLE5S4UVqjwqB4RPwxKT/mw==
X-Google-Smtp-Source: ABdhPJxEC3rn/0fF0Zr7BjG9yEmToK8hrIjqG5NRWpFMig48aIuM+doInx7WLTkUcoJYgTWGctvQCg==
X-Received: by 2002:ac2:4db1:: with SMTP id h17mr3226493lfe.203.1628788613569;
        Thu, 12 Aug 2021 10:16:53 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id j2sm376856ljc.49.2021.08.12.10.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:16:53 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 0/7] usb: dwc3: Fix DRD role switch
Date:   Thu, 12 Aug 2021 20:16:45 +0300
Message-Id: <20210812171652.23803-1-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series pulls the patch ae7e86108b12 ("usb: dwc3: Stop active
transfers before halting the controller") and some fixes/dependencies
for that patch. It's needed to fix the actual panic I observed when
doing role switch with USB2.0 Dual Role Device controller. Next
procedure can be used to reproduce the panic:

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

Most of these patches are already applied in stable-5.10.

Wesley Cheng (7):
  usb: dwc3: Stop active transfers before halting the controller
  usb: dwc3: gadget: Allow runtime suspend if UDC unbinded
  usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
  usb: dwc3: gadget: Prevent EP queuing while stopping transfers
  usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable
  usb: dwc3: gadget: Disable gadget IRQ during pullup disable
  usb: dwc3: gadget: Avoid runtime resume if disabling pullup

 drivers/usb/dwc3/ep0.c    |   2 +-
 drivers/usb/dwc3/gadget.c | 118 +++++++++++++++++++++++++++++++-------
 2 files changed, 99 insertions(+), 21 deletions(-)

-- 
2.30.2

