Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4853E85A
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239747AbiFFOdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiFFOdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:04 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AD81C12D;
        Mon,  6 Jun 2022 07:33:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m26so8695767wrb.4;
        Mon, 06 Jun 2022 07:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nVR5L8pspyH8NCr87V+bK6vtRmqrZxyBwvj97tjuvy4=;
        b=BhvdPrPlWlMtDRNqjlxgshk0rVK9LKGjvoRHJCjo6bUxBWDOtJXIMJWYVF3Zumh1rW
         DEZzd2wncAUOgkPYJC50POmzqOmhpBRe4Q3LOMuiB7PqWcaG2L3pnGCUoVehx34yJazJ
         DRVG9LM/9SOIpiYifS3notFDC7YGAMmR+LkTIJdUB4NBgkWhM8/hILXSjByg79vvqTse
         Kzl4DRkt+aNtY8E4Vt3V/Hc3yZmmTk9GjcdCkndJYBJVxrSNGPaEv8sb8RpCAdVL9ur7
         V4f8D90hN42kankghU43OXbgEUpmFIUNzMNPjfCJEg4hpvk6O6H91i+w5Gu0ufAzPX49
         pkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nVR5L8pspyH8NCr87V+bK6vtRmqrZxyBwvj97tjuvy4=;
        b=J4756VYbSZobB3P+0scDmO/tnuQlWbGrWCWsIEMeVH63ytx0RMzUWVkfRB/0yW3deG
         cnyhrAJuHCwfcwCvv2gQcR9kJm94sfulZX052tvQ/VwodeVR7kWe5lFC1wyqHutnE/Gr
         0op6ENCnBzRqZqON55Rhxj5ybHwnDc6lhrIR8YhR6pokDbC+rH3TWHcgSYN9qG0pC6hu
         tbW5KPPRPclTpLmIkE+0nQiuQftX2+q2jKUsEhlFX6EQ+9SbAN2GjjJcfBq9Oxbk5Hno
         WK3Lsjl3XNOd8Q/Ht3uxfXnZsDla7B6n1CRNSReq+Dp09asFe6bCXrmjzyPYONj+ndP+
         yTqA==
X-Gm-Message-State: AOAM533bVK9JmLLLCI+w2TB7A7uKNpW3+EsjqxktQbxM4M4/n5ZBFJXX
        ooX9HLslbWNSgqjn/MslhZc=
X-Google-Smtp-Source: ABdhPJylzdvM9GzeuYhXM5miLG/eUUvIWmUQE1Nr3ztvhQCz8zoB9BjoIRdQpuNKlsiAa36bHH+ByQ==
X-Received: by 2002:a5d:64ac:0:b0:211:7f3b:8151 with SMTP id m12-20020a5d64ac000000b002117f3b8151mr20861946wrp.166.1654525982330;
        Mon, 06 Jun 2022 07:33:02 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:01 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 0/8] xfs fixes for 5.10.y (part 2)
Date:   Mon,  6 Jun 2022 17:32:47 +0300
Message-Id: <20220606143255.685988-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This is the 2nd round of xfs fixes for 5.10.y.

The fixes in this part are from circa v5.11..v5.12.
Per Luis' advise, I am trying to post a small number
of fixes per LTS release.

These fixes have been soaking in the kdevops test env for the past
week with no regressions observed from baseline 5.10.y.
One backported fix was identified as a stable regression, so it
was removed even before being posted as a candidate.

These fixes have been posted to review on xfs list [1].

Following review of stable candidates, one fix was removed
("xfs: fix up non-directory creation in SGID directories")
because some effects of this change are still being fixed upstream
and there was no consensus whether applying this fix alone is
desired.  It is still in my queue and will be posted to stable
sometime later when remaining upstream issues are resolved.

Following review of another candidate, Dave has pointed me to a
related fix that just got merged ("xfs: assert in xfs_btree_del_cursor
should take into account error"), so I included it in my test tree and
in this round of stable patches.

I would like to thank all the xfs developers that helped in the review
of the stable candidates.

I would like to thank Samsung for contributing the hardware for the
kdevops test environment and especially to Luis for his ongoing support
in the test environment, which does most of the work for me :)

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/20220601104547.260949-1-amir73il@gmail.com/

Brian Foster (3):
  xfs: sync lazy sb accounting on quiesce of read-only mounts
  xfs: restore shutdown check in mapped write fault path
  xfs: consider shutdown in bmapbt cursor delete assert

Darrick J. Wong (3):
  xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
  xfs: fix incorrect root dquot corruption error when switching
    group/project quota types
  xfs: force log and push AIL to clear pinned inodes when aborting mount

Dave Chinner (1):
  xfs: assert in xfs_btree_del_cursor should take into account error

Jeffrey Mitchell (1):
  xfs: set inode size after creating symlink

 fs/xfs/libxfs/xfs_btree.c | 35 +++++++--------
 fs/xfs/xfs_dquot.c        | 39 +++++++++++++++-
 fs/xfs/xfs_iomap.c        |  3 ++
 fs/xfs/xfs_log.c          | 28 ++++++++----
 fs/xfs/xfs_log.h          |  1 +
 fs/xfs/xfs_mount.c        | 93 +++++++++++++++++++--------------------
 fs/xfs/xfs_qm.c           | 92 +++++++++++++++-----------------------
 fs/xfs/xfs_symlink.c      |  1 +
 8 files changed, 158 insertions(+), 134 deletions(-)

-- 
2.25.1

