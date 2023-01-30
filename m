Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91121682007
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 00:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjA3Xwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 18:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjA3Xw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 18:52:29 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FADE2E0CE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 15:52:29 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id f8-20020a170902ce8800b00190c6518e21so7292621plg.1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 15:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9L4H9zMNHfTlSUsYi2E4Yk2roy1uWEAEGhGj+Mssx0k=;
        b=hzznFpSeS3PC1BYH6lASNy4Sv6yt4feSp0Gle9cygd391x/kkvgJzzHsl0yFs0J284
         +GrCHNOVYVE4MgTp7KwqL7Vh6DLmnnp4xJKJvCa14OVTGvU9Ij4ftnveweJO1kg7472s
         1YTyFjfrw9cCYh1Y/xGh7ODoRCycNp0mdOudemjfGigMdDIVpBRuTkG+BDcwEZS27Cz5
         oq9EBYM4KSPaIymvyM6mTDHtfBXtbtdOTq8EFuj45ovZuVXxe1B8WE/a5qEMixBgKHre
         btBmoRVfET8LrGbej+WkDNP86EnHHfJZeRoCjt9c9+rwX216QEgctvm18Pi7kArr2RF+
         W4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9L4H9zMNHfTlSUsYi2E4Yk2roy1uWEAEGhGj+Mssx0k=;
        b=WdnYF3DhtsoagLkzUo5+cnyKMh39o+tvEAMsVjcP3940WhXn82AblD2znnFDD44umE
         555ssXqEtPaSqIsLaCqJrqGP7LN99NUbn4vfDd999HlE2NOsxXb+bDVZjcEvo67v+OfN
         iRQSipXRibbb+7DJoIEUJ7cZSOTJB+ehQL3U5+ap10bZU0BNqwByb4e4UtP62lcSdDW1
         trg/rmgWH8bkpkp1wKRUBR5JAaWcLw7sgTxXa9aZsniPqDijO1kBY/5kr7q0iXfgx2Fa
         UYbvN4HmJun3dqt4XuzLXAtAIn14WKn8JRxMxXIwa4ZEsR6B7ZzDZLc8EroFTnH6sOVa
         Pztg==
X-Gm-Message-State: AO0yUKVR72YwI29/zfpa+7dU80D37If5s1IrsegxUdWkwNsFd+JbqmKm
        1LOlDAhpX39oEgdHFqBQMmE3ncCVEJLtOgWf685ydeTBOKPBbpWY7o7DgKs54ITw55QcD+UrkBH
        JH2A9Syp5DSYYvEiH3TPsAcwqtqRYmcEzQpyQqEmY5WCY9eVNd6gtpg==
X-Google-Smtp-Source: AK7set88FpVO9sGih4JySV+k6CySOMnE5OQXkI9INfe6JFtK3QHNv7U13h2gnAzcKWt6mLmJwlzfyMQ=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a17:90a:740d:b0:22c:5f7e:da5e with SMTP id
 a13-20020a17090a740d00b0022c5f7eda5emr1931772pjg.4.1675122748401; Mon, 30 Jan
 2023 15:52:28 -0800 (PST)
Date:   Mon, 30 Jan 2023 23:52:11 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230130235212.698665-1-ovt@google.com>
Subject: [PATCH 5.15 v2 0/1] ext4: backport online resize fix
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
2.39.1.456.gfc5497dd1b-goog

