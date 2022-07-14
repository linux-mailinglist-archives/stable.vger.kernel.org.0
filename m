Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324835757C9
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 00:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiGNWn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 18:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiGNWn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 18:43:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F7B1571D
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 15:43:55 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090ab88800b001ef81869167so4285553pjr.2
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 15:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=jPuwyA9accF3i+2887ENqHyiJ/YmPYGo472FzrDMtI8=;
        b=QRtCpWF/vDO6KwMvoOyAuDf5ZfJT6/IrIijQyRW1D+d9e4csxioy+AuUbPgONN90oj
         OaCH8g0xBUELrT+/JYJ35ogr7aXFESP2cqF7G5I/Ks1S3eQDy+XifjyVoWCUqtko2BOD
         Y5DXyzEB5Gu7IJRJdgc5fsPua2kVtI5V4wI93FPiK4QMtfpFs6EAULG+WWesnW9AtgLr
         gHcw2p+kTP408I6lVXe1y+AFCF2nnrcAtx9ogDiCwFjgWsBaN4KxfZaggRu4UfUGe3oK
         YPv8LT7ILczxyuxD9DiXBqU81vpI+uGBcc6WEndPZAIfMZy9IKSYDeFtvrJbX9rzD5fo
         EerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=jPuwyA9accF3i+2887ENqHyiJ/YmPYGo472FzrDMtI8=;
        b=rNp7pTNZvKtAzkY8W394uAc0nVpszArx2/Q0z/os/0X/F6XyKitSvuH/WRhj8vE8Zt
         mOnSwRWyhUkvVVOPycig3XyBpURTU9qq3taWHuD10fG+P2xjF84t0v1VXSdIKOmSBbe4
         sjjTAX1/IWb5o7asAUYfNgIcdNkEFoY9DN+eT7rdopU/Rv+x6SM/2pYcMMJsRuSTIuCv
         9exp7u++uHRZZvwxwVEuegW9EycsH249HW6iFFc4MyKftsd5+h1XdLk0IZWoCGLCfVsx
         AvqiY/tH2fJh2a+vM55vocUn6EMzOcBYtiKk6joKiCs1wdqwDtb1tUSM5NOQsSblsAc3
         66Dw==
X-Gm-Message-State: AJIora+PpIm8+uZuHEc7TS2HLNVxVZSZHyye2h3OrAXkfTeLaoCUMJet
        8GqKZrUZV+tyI5PM98XOWNHSVhs=
X-Google-Smtp-Source: AGRyM1tsVZcYAW/AHMwQQLtJ0buUBC4TthSmfrFf9U41nM5g5M3AsZCOZsp2Pf6dORewVavf8OHUIE4=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a17:902:6b42:b0:16b:f27c:1c17 with SMTP id
 g2-20020a1709026b4200b0016bf27c1c17mr10270655plt.152.1657838634989; Thu, 14
 Jul 2022 15:43:54 -0700 (PDT)
Date:   Thu, 14 Jul 2022 22:43:51 +0000
In-Reply-To: <20220510130743.305503241@linuxfoundation.org>
Message-Id: <20220714224351.1469186-1-ovt@google.com>
Mime-Version: 1.0
References: <20220510130743.305503241@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: Re: [PATCH 5.15 101/135] selftest/vm: verify remap destination
 address in mremap_test
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     gregkh@linuxfoundation.org
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

This commit is the second backport of the upstream commit 18d609da
("selftest/vm: verify remap destination address in mremap_test"). It
re-introduces function is_remap_region_valid and breaks vm selftest
target build with the following diagnostics:

  mremap_test.c:126:13: error: redefinition of =E2=80=98is_remap_region_val=
id=E2=80=99

The original backport to 5.15 was done as commit 2688d967. This one
(0b4e1609) should be reverted.

The same happend with the upstream commit 9c85a9ba ("selftest/vm:
verify mmap addr in mremap_test"). Original backport: a17404fc,
repeated backport with just the new function added: e8b99895.
Build error message:

  mremap_test.c:147:27: error: redefinition of =E2=80=98get_mmap_min_addr=
=E2=80=99


Thank you
