Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E04BBEEF
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 19:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbiBRSFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 13:05:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbiBRSFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 13:05:04 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D65E177E57
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:04:47 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id z16so2910593pfh.3
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:04:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/dGNExtEWUtpB0Je9MbDKe5uZz/BEfHGlBDv4b2V+U8=;
        b=CGFuBrugsYYuPSS7cikxz2Q/OXnqG8VspF2ClcJE8eV2+P/os2s2Kwx2yAnJMPjPdw
         XqwfDQ21KYK0/i5rvZ5SS7BY7X/j9JIXbAYiOlgrZ6thE7RrRoDjUx6ZT2jENRzo7AkB
         rD2efEafJFGzl+mFEAITWPJtCsQtxnLRQjiVEBMFOmaTd8d51HOtANJ+glDqXXsInz0i
         VCbxiFO7MvmJO0QGd8P1xPtBB1c90Z6K6HuHdbR4ivDJ1l8GR/bnVAuf0NwvPgueBZ4x
         RkMeSAUjE5xQcozE6jsupVAAMCrANaPcRRFvW0q26dyKqcHNU0B4xiBBfHiSvueYPAe3
         lfBw==
X-Gm-Message-State: AOAM531dxkOA9V5ovRkVhBcp+U3G+QIuK8sU8QZ3esIB8HW+DHbmaBz1
        vsgCQJQpfSDbmRsEU7YbMGE=
X-Google-Smtp-Source: ABdhPJy4J1PGed2bFRntO9OC9p+veKupPMwSyjzG+083o8uWmWmJ18LYY9mdEdPPCHHxBewht9Eajg==
X-Received: by 2002:a62:8c44:0:b0:4c4:8072:e588 with SMTP id m65-20020a628c44000000b004c48072e588mr8733591pfd.11.1645207486543;
        Fri, 18 Feb 2022 10:04:46 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q21sm3808745pfu.188.2022.02.18.10.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:04:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Backport an UFS error handler fix to the 5.15 stable tree
Date:   Fri, 18 Feb 2022 10:04:37 -0800
Message-Id: <20220218180439.19858-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This series includes two patches:
- A backport of "scsi: ufs: Remove dead code".
- A backport of "scsi: ufs: Fix a deadlock in the error handler"

Although the first patch is a code cleanup patch, I have included it in this
series because the second patch depends on it.

An Android developer requested a backport of the second patch to the
android13-5.15 stable tree.

Please consider these patches for inclusion in the 5.15 stable tree.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: ufs: Remove dead code
  scsi: ufs: Fix a deadlock in the error handler

 drivers/scsi/ufs/ufshcd.c | 58 ++++++++++-----------------------------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 16 insertions(+), 44 deletions(-)

