Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A96793A7
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 10:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjAXJGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 04:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjAXJGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 04:06:50 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30BE3D0BC
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:06:48 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f132-20020a636a8a000000b00473d0b600ebso6697033pgc.14
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XrKog+F0GMoFJ0ZxV3vJmxILSZuvCfBOAthzkzpCF1M=;
        b=N4L8qThNnmYTJn1fu9XFDo0BImxXW53v7/pqQ04TX3B3OQM99DhR4k+Cu/z+csz/jf
         LtvY6uLFLURDClgCv523Kn6Fl0pYHoDyHZuXiRZUjq20TFPeVg/+Fp55WgmXW2HV2acV
         4YfhwBMzUaXpjvRO9Fzh9O1Bk6fhWuL7+NNCCzdLCFIYMqFlnenD85bh0jIqGQF0dpl/
         V1QccuUxhj55rTLJmAxasvEyuY1SYqly3l5yugLlZ+M5cDWkyeU2NN3CdmPGfrQgDUAH
         6dcqzvKXeny0snxSVALg1jHicavm4Y+UfiAOIi9olc363vNZZd1V5qsLWFkBjFBuMrOw
         JKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XrKog+F0GMoFJ0ZxV3vJmxILSZuvCfBOAthzkzpCF1M=;
        b=q3Nd4owDDWVJHsE2Ig1/GeSxWY+8/Wn0OTM4l3mBwpgnWckpEP5swtus9vpgru985i
         zCBoaeVuyvAKS3wD771RvJPggZY4BpaDw1UYHY9Xmu80bKI5J+FKcjeKQTNkhtVkVrUa
         vBPJOOeEIvgilLkHHU/x8QLnjfPmFerjGKEB2HyYPjWdHGT9qKw3Ct3YTf5udVTkxhnb
         ctu0PnFkOUNUFEDvE72oAivy2LCs5AuVCcnfnmepIu/LkfjuJROnorDe7cFJL+C7mrZO
         /aJ+tsIZJDVhjd+rx8YBa2QSyGow47muHiJd/miqPaWBM/gtYBADRCDxdaTo2DfUlWUq
         lV4g==
X-Gm-Message-State: AFqh2krXswKQQiLK2sVTEX4njtbA8DW/mIEI8N/QGkXB+je56+h5Umjv
        F/Wau6+buj1HMqxOIv7ju/XqlX94JXYtOsdeZJsaL65lIPHPeR//lnEfoaQQkA8ARx7OuDriqds
        MKslHf4H5kLSX4+QYwGwnsqM3f/F+3gjhZw93xiw/IafngN/7mvaHrw==
X-Google-Smtp-Source: AMrXdXsAZ58JXsNgybi3FpSPt5Rcu8fmT1h7gvNfcf9PzQWylCgOE/wpIIHkR/zjaTm8AK17+3+TDlA=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a17:902:b217:b0:194:7c22:1885 with SMTP id
 t23-20020a170902b21700b001947c221885mr2587297plr.26.1674551207960; Tue, 24
 Jan 2023 01:06:47 -0800 (PST)
Date:   Tue, 24 Jan 2023 09:06:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230124090632.4185289-1-ovt@google.com>
Subject: [PATCH 5.15 0/1] ext4: backport online resize fix
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     stable@vger.kernel.org
Cc:     Oleksandr Tymoshenko <ovt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following patch is required to fix the ext4 online resize in 5.15.

Baokun Li (1):
  ext4: fix bad checksum after online resize

 fs/ext4/resize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.39.0.246.g2a6d74b583-goog

