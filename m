Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1316A8551
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjCBPg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 10:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCBPg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 10:36:27 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C623669F
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 07:36:26 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id r27so22624015lfe.10
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 07:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677771384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2skxjP7BUf3M+vL/Xs0pd7p3mFaPMienCoBwSMkX1P4=;
        b=yAXM3clwa02STwV8+occXXG6D8d4YXdurxOxMl7mcOkXm1H8u68Xg2XQHWpr1pCM5b
         Xej7iimsE3QYatrYMb+6bCnwZpmbF3uFEeqYkvwOHYK7BtO/pRhceH9clcTP/Bgxejby
         2+AhI8tmtHpPs/dcHNBuY/1kigeMlXf416bP6gF/wWOM7rfZSBasKf9ZQllKN+3jc6pT
         bg/FZmazyEAQ4WJxPagbDtTp955EFoDlfCNLtxksfOvvcJ0C21W0UCIVt4tY5PLDP7PV
         JW1raU/0zJ7nHPHJ87kixs5Plm0+FOS8dyKdKF3GNZNKjLyP/CF6nKzHytlaxkORK0KF
         c2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677771384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2skxjP7BUf3M+vL/Xs0pd7p3mFaPMienCoBwSMkX1P4=;
        b=xVcGX6FCnQ8GI4yCueCnVm4Ju8JEfu0wySK24KVliCu9Z5zQPpP9Oi3R1qoIR+1oTQ
         hbQU2PS55s5Pbt4jI0GQ+UvYgD3NZj540ted0fXWB1e7Iwa9EHxpcZn4Xw+ZeYXeUoqp
         J9/ntyupEpVIdy/xAZLavPCaVFjjVva2id4YE6veky0jxpmoTQeJMWgDLt5fly6kAPDX
         N76j7M8WW6bO0wAZEnOlkKVLdfVyHrR7AzNDDZnEdQVUUk5MtdwAc70UW7p1ELjCi32t
         rEYsMP482Da19XNNxJ7mnl7TFgPrqUsRBM8mNIyaP1kLDS4FN2J+IlxJZW+Q6bjwNupf
         tt1Q==
X-Gm-Message-State: AO0yUKUfQPQ7mMP9a/0kCWt3SOWsVDCdrK7TOUdbf/RZfSIQDmSb+WA0
        hDsvJKWIh+AYNiljaGXgXSofUg8Nxn+TsQwd
X-Google-Smtp-Source: AK7set+Jqeb3nj72ML3ccr7EIT/TCR54d4WT0pNWcYQQNRKHebYYqfo/YWX29+K4TOX5g+xDAKKw7g==
X-Received: by 2002:ac2:548d:0:b0:4cb:3a60:65c3 with SMTP id t13-20020ac2548d000000b004cb3a6065c3mr2769014lfk.1.1677771384302;
        Thu, 02 Mar 2023 07:36:24 -0800 (PST)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id p17-20020a05651238d100b004db2978e330sm2170509lft.258.2023.03.02.07.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 07:36:23 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH][for stable 5.{15, 10} 0/4] ext4: Fix kernel BUG in ext4_free_blocks
Date:   Thu,  2 Mar 2023 15:36:06 +0000
Message-Id: <20230302153610.1204653-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This patch set is intended for stable/linux-5.{15, 10}.y. The patches
applied cleanly without deviations from the original upstream patches.
The last patch is fixing the bug reported at [1]. The other three are
prerequisites for the last commit. I tested the patches and I confirm
that the reproducer no longer complains on linux-5.{15, 10}.y. Older
LTS kernels have more dependencies, let's fix these until I sort out
what else should be backported for the older LTS kernels.

[1] LINK: https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c 

Cheers,
ta

Lukas Czerner (1):
  ext4: block range must be validated before use in ext4_mb_clear_bb()

Ritesh Harjani (3):
  ext4: refactor ext4_free_blocks() to pull out ext4_mb_clear_bb()
  ext4: add ext4_sb_block_valid() refactored out of
    ext4_inode_block_valid()
  ext4: add strict range checks while freeing blocks

 fs/ext4/block_validity.c |  26 +++--
 fs/ext4/ext4.h           |   3 +
 fs/ext4/mballoc.c        | 205 +++++++++++++++++++++++----------------
 3 files changed, 139 insertions(+), 95 deletions(-)

-- 
2.40.0.rc0.216.gc4246ad0f0-goog

