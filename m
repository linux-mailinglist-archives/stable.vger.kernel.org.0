Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AED36CB846
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 09:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjC1HgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 03:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjC1HgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 03:36:03 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5839B3ABA;
        Tue, 28 Mar 2023 00:35:22 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so3437755wmq.3;
        Tue, 28 Mar 2023 00:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679988917;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QpTm2L5JRTJWnRrYOFZ1oTyRRIMrct2qL0Q0OWL4jCs=;
        b=bfil3+1/J5hTDseb4xv/CaddMReJKG3TMrl5FN/bShBWfyhefkzVs+RAKmluVgBttk
         Jd1NKH1P/fy6pLo3zGeus80OO7SoozvL3hC9WG7gVkd9eyRH1JqlsqJVSCaYJxyg5VlW
         72C61IAjs0QB9GrKVSJDHQCvBwLr5ZcfrqZ5n+HZGTaL+s3kLJh25VtyFE7Z2u4YTgA+
         PqlWzIjjZZD5JHuRY4kLHzBAfHIIY4nxnRFbywA/sXBqFAl9Y9gmjTisU8jNabhMtVZA
         oxLTWPW3J35wzoEKvlSKPR//SyvUJunH9Q9e0htI4cOk93C8mlsh7QiLxAhJUp2TIZZv
         JrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679988917;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QpTm2L5JRTJWnRrYOFZ1oTyRRIMrct2qL0Q0OWL4jCs=;
        b=Pvqh3sGrnzDyQeJIxAFHoYPupOhR/s3gAL8dMZUjUZzIUz9z1rAZmBL9wTygMKadGl
         1mpC2MCUiZ0ptCSCjVjPiCLpkspbzpimCXP3ySdDy7RjA+tlSjRPGukBT6D0Pxpl1gno
         kLJFantU/hfeT9xwmyLeLUkMbBrPLJPfXIDbkqTisk9GmcWuD6rJ0Rivs+4TRCwb7DEi
         eSEakmnRc6Gn4lqUSF04hF4kEyttKKlsEW6cPEl/rIfsclGUWrro6GxRlPgRL4ZjjPEY
         v8DCK/otK52zcsuZqYQkoYQGxuq75sYcYiMWDZirrF/rmWIfTPFpneIjO7VOzaKfWp/+
         cH7Q==
X-Gm-Message-State: AO0yUKV+sP17dqhwkCmkb6XrTrq7jUytskw7r6VQc56UYfFkUD8vEmEi
        OZFRwoFG1u13mJZ6OwNa+M0=
X-Google-Smtp-Source: AK7set/e4wbEcQek6DSRu1KAl6X0qh/zaflxNFU4TF7ScA1PgyxnJj7qH7uuFDRdbY4234uly6EQHQ==
X-Received: by 2002:a1c:6a05:0:b0:3ee:138f:be54 with SMTP id f5-20020a1c6a05000000b003ee138fbe54mr11606119wmc.3.1679988917094;
        Tue, 28 Mar 2023 00:35:17 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c00cb00b003ef64affec7sm9717940wmm.22.2023.03.28.00.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 00:35:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 0/2] Two more xfs backports for 5.10.y (from v5.11)
Date:   Tue, 28 Mar 2023 10:35:10 +0300
Message-Id: <20230328073512.460533-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

Chandan is preparing a series of backports from v5.11 to 5.4.y.
These two backports were selected by Chandan for 5.4.y, but are
currently missing from 5.10.y.

Specifically, patch #2 fixes a problem seen in the wild on UEK
and the UEK kernels already carry this patch.

The patches have gone through the usual xfs test/review routine.

Thanks,
Amir.

Brian Foster (1):
  xfs: don't reuse busy extents on extent trim

Darrick J. Wong (1):
  xfs: shut down the filesystem if we screw up quota reservation

 fs/xfs/xfs_extent_busy.c | 14 --------------
 fs/xfs/xfs_trans_dquot.c | 13 ++++++++++---
 2 files changed, 10 insertions(+), 17 deletions(-)

-- 
2.34.1

