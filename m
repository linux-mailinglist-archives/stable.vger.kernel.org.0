Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B4B6A0DEB
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 17:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbjBWQ0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 11:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbjBWQ03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 11:26:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E05F5650C;
        Thu, 23 Feb 2023 08:26:28 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y2so9329012pjg.3;
        Thu, 23 Feb 2023 08:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2Xji7gaTx/R4sRwqxpyLRMUl1kvpggWWzZgEu+h2Hs=;
        b=RO70MKzA7RmhMWEv2zjrKPH5Yy1OxQOTNPTODAzW4FobJuXmUZCOuOYFAo/hubtAzl
         YVbrPxPegwF85wSifBkR8m0j/lALw9JhwUqHwm31LwwgstaTaiH1cixhovOxhQORcCBB
         lgROqT9E6SBqwsia7sxjZrhCrb5pP36Rc1+AY1ilLEZwis+vOHAfKU2TnIEBcXqDcwfI
         61FcwVXPRswgtcSKumKhG/CJwZHDz7uLPDIkBfGs4ASR4jDIVwzu04uDDeVIzSNwt8Gm
         +VMYyVHmey6fgprul9h30H48pYj7f4NYmMV13abg346ANdJ2TxVa1q+EV9ItEmb9/BiU
         QY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2Xji7gaTx/R4sRwqxpyLRMUl1kvpggWWzZgEu+h2Hs=;
        b=nM8QTmPRZV5YjlhMfFCXmF8Gse0SdLsOH454eSuAFXdyiwH8nJFSm53HQmT6p2ICFW
         5eaXcMe7fJ61O0iqMaNa+ASlYTClXxQtR4w29Dpe3btLGJrUjj5WB22ZoZDKN32Lnrcc
         3hp6RiQDaQW1TUBlOCMZ3u9jeKr+9AhO2a32dGcbuh6GXOzki+oo5VD1zQDXTMWXoT0D
         8sa1LlyiSdMGMtMJAEVrl4rImaPZaMchzU8aQvxvaXQEjlviRONpcSajIlgIJXdeR8cq
         8uL8rlvgKOyhop6qH2dUFN20jzQfxNCSy/8u7nzH2ScXJApcUcmOSCyE1MYzqOlrtG+2
         ECXQ==
X-Gm-Message-State: AO0yUKXotbQD9w45NwRnUJqBSxvTNbx96w/oIU3nH/MYR4sILDZ/GoIe
        xEJNKRmMK9/ESUjwWCpYj1E=
X-Google-Smtp-Source: AK7set85+Kcb7ih/En+3zMTceGG9ViGIQOVexUYm5kpeiI5Xqhk3mTRS1c49TRskgTscezorfZ1m/w==
X-Received: by 2002:a17:903:2289:b0:19a:ae30:3a42 with SMTP id b9-20020a170903228900b0019aae303a42mr12864712plh.21.1677169587839;
        Thu, 23 Feb 2023 08:26:27 -0800 (PST)
Received: from localhost.localdomain (42-3-59-214.ptr.netvigator.com. [42.3.59.214])
        by smtp.gmail.com with ESMTPSA id iw15-20020a170903044f00b00199190b00efsm3736210plb.97.2023.02.23.08.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 08:26:27 -0800 (PST)
From:   youling257 <youling257@gmail.com>
To:     mathias.nyman@linux.intel.com
Cc:     gregkh@linuxfoundation.org, hhhuuu@google.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/7] usb: xhci: Check endpoint is valid before dereferencing it
Date:   Fri, 24 Feb 2023 00:26:17 +0800
Message-Id: <20230223162617.31845-1-youling257@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
References: <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I used type-c 20Gbps USB3.2 GEN2x2 PCIe Expansion Card, may be this patch cause USB3.2 GEN2x2 PCIe Expansion Card not work.

[    0.285088] xhci_hcd 0000:09:00.0: hcc params 0x0200ef80 hci version 0x110 quirks 0x0000000000800010
[    0.285334] usb usb7: We don't know the algorithms for LPM for this host, disabling LPM.
[    0.285347] xhci_hcd 0000:09:00.0: xHCI Host Controller
[    0.285407] hub 7-0:1.0: USB hub found
[    0.285415] hub 7-0:1.0: 4 ports detected
[    0.285783] xhci_hcd 0000:09:00.0: new USB bus registered, assigned bus number 8
[    0.285787] xhci_hcd 0000:09:00.0: Host supports USB 3.2 Enhanced SuperSpeed
[    0.285889] hub 4-0:1.0: USB hub found
[    0.285901] hub 4-0:1.0: 1 port detected
[    0.285988] usb usb8: We don't know the algorithms for LPM for this host, disabling LPM.
[ 3277.156054] xhci_hcd 0000:09:00.0: Abort failed to stop command ring: -110
[ 3277.156091] xhci_hcd 0000:09:00.0: xHCI host controller not responding, assume dead
[ 3277.156103] xhci_hcd 0000:09:00.0: HC died; cleaning up

may be this patch cause "xhci_hcd 0000:09:00.0: HC died; cleaning up" problem.
