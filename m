Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9095A5FED98
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJNLuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJNLtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:49:12 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1489C157F5D
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:48:31 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f140so4693665pfa.1
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C758n40msd/+hTaVQ6nf92NnOUmXLGhl+icehHmFsXk=;
        b=qeLF23tNUNeREUIWK7t0VxvLRZfxRSHlGW4dD/uYVYvNTOBsk4VMtSRZqqHHFSSymv
         Fy6X9VPS+mhKkBpcNN58MIPeBnNF6no7P8nORCDHjZuqZfhw+5e6/gZ6sWAIuJnQpU99
         +SaO0UOb3YeLVAsmZBm6PfgbRwgA/FLsZByqPylaOPf9sV/DD/9YcIvHnU6+0qeVQh/B
         aqbIaECvepe0NuG6cgEeLI+Pjvc1NClYAzOUww/NB339BvKlfS2do37zYp6hRx6A9sd5
         5ugCzrAhrbh3z09D/ERtiej4iN1dAc3t7mzk7ueLLSsvwTMF5Km3kGazIoYXm+ezrceK
         c/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C758n40msd/+hTaVQ6nf92NnOUmXLGhl+icehHmFsXk=;
        b=wdb7SDXGk13UyByBXdfpJtnmlatFX/ad9nJSi6epkOwAuddJAHcpiMfkfbo4IMyV5A
         Hh9HfHiaBDv/II7KYdHUqhy+BX+1oyThYTscFjrFuvy/Z8spEk6CdQXRtB/dKl/ITCnh
         YDMWe5DrtPT90JSoXH4g6NSF+cPl3OBff4D6hJ2wBgti8zeLC3IHPWiNMy2RflipHtTO
         ek/FJyobHtqeUjBeU8/fzIQrUQuDubSBlmgaKkTL8hjIM2VNGHIrAbQq10swBavUEG/1
         zxhjB6HzK5moxlwpuXBQD6V0Dp5/UwtHWeBcpdVstmSvaFmhQPQQa93LFoA4jwK8IKFs
         9plQ==
X-Gm-Message-State: ACrzQf340UWv8XqTsXKUSIofuo3JMyR/3PCVhXJ5W49fsMxCD/vmKqcE
        FcKcLGLxfCrjt2XHlOb13RsGY6wOPUE=
X-Google-Smtp-Source: AMsMyM5XGmzVdb7yKol/813YgfoWaQhmJxJqIesA2ow5zBQ+Qksf6WfaCFnQVYUGO06jOqU2jtCwag==
X-Received: by 2002:a65:5886:0:b0:439:8dd3:18d4 with SMTP id d6-20020a655886000000b004398dd318d4mr4224968pgu.430.1665748111145;
        Fri, 14 Oct 2022 04:48:31 -0700 (PDT)
Received: from carrot.. (i58-94-204-181.s42.a014.ap.plala.or.jp. [58.94.204.181])
        by smtp.gmail.com with ESMTPSA id b30-20020a631b5e000000b0046270ad651bsm1260105pgm.94.2022.10.14.04.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 04:48:30 -0700 (PDT)
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 0/2] nilfs2 lockdep warning fixes
Date:   Fri, 14 Oct 2022 20:48:24 +0900
Message-Id: <20221014114826.21895-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

please apply the following two cc-stable patches to 4.14-stable.

Ryusuke Konishi (2):
  nilfs2: fix lockdep warnings in page operations for btree nodes
  nilfs2: fix lockdep warnings during disk space reclamation

During testing nilfs2 filesystem with stable trees, I encountered a
lockdep warning followed by a kernel panic (by panic_on_warn) only in
4.14-stable.

I found that the cause was the lack of these patches which are applied
to other newer stable trees.  I guess they were dropped since the
first patch was not applicable as is due to a pagevec change.

After I manually applied them to 4.14, the panic and lockdep warning
have gone.  So, I believe these should be backported to 4.14-stable as
well.


Thanks,
Ryusuke Konishi

 fs/nilfs2/btnode.c  |  23 ++++++-
 fs/nilfs2/btnode.h  |   1 +
 fs/nilfs2/btree.c   |  27 +++++---
 fs/nilfs2/dat.c     |   4 +-
 fs/nilfs2/gcinode.c |   7 +-
 fs/nilfs2/inode.c   | 159 ++++++++++++++++++++++++++++++++++++++++----
 fs/nilfs2/mdt.c     |  43 ++++++++----
 fs/nilfs2/mdt.h     |   6 +-
 fs/nilfs2/nilfs.h   |  16 ++---
 fs/nilfs2/page.c    |   7 +-
 fs/nilfs2/segment.c |  11 +--
 fs/nilfs2/super.c   |   5 +-
 12 files changed, 242 insertions(+), 67 deletions(-)

-- 
2.31.1

