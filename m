Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB39536315
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 15:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351604AbiE0NCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 09:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345414AbiE0NCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 09:02:41 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC52EA21;
        Fri, 27 May 2022 06:02:39 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u3so5801170wrg.3;
        Fri, 27 May 2022 06:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TI4rB7SCdL/nqUC83h6F6RLCmCnvA5ljMhZ/N30OCnM=;
        b=a/R0mQ+TPSH514hEl6n6xWPxVU9KBRotBhiCD3HoRiQtmDfrev5cf2UkWYxEOs86Ia
         k7i8yL61NyLcD8AUkV9YN/CLDzHatuy9xP7rVBbV9y+QJI1KBcUoPZjFtMctJcBsYQRY
         tcqEn5MOAdJX13GrILGvPVxquLHiUNqw0fNT9KlDwFdUpbUaAiXL8mpI6mbDqskDUZ/l
         eOfpn9fPGmhdgBxNSovkQtwg1tADaTkYVNX0LfujwqeOOC9DDPaoF3rT9oMpMYgCq239
         qC6eBsLfB7Fa+SYXxYNcDhvEFHJm8ZB21ebvVzQlvZAaJZ/pHqP2TDEpzKFStmnaQdTW
         0nAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TI4rB7SCdL/nqUC83h6F6RLCmCnvA5ljMhZ/N30OCnM=;
        b=frD1ZTTnSLSfOvJKRm3CiGrmCHGWJUFTbjf9u+B7SVL6VkB+MKJStPfSKSDwy82FI0
         9XIo06tThOQWs0wg7bD6wLSyFS9WQp/fymUKrxqVmatTrJyTP6maJ3lX7MP7YKrIJg2N
         Ht1DgFQUeV5spG+scLAsddWhb3PwQilMU0O+u25kSQQx9LDI1OQfpMgqHqY3DQTyAyUy
         7nTcN/EfgDZHvwxG5Jociubg9+DsTKutcaiI+et9s1XN4Wp8ArX4S4W4xYYYZGkDhX8Q
         +A13vsglu2nyiVcNqm7D1AHH+wtGc58782jVAd/XEr/k0WWKxGh3p/Vjh2U/LaCissQv
         f3wQ==
X-Gm-Message-State: AOAM533A5Y/MuVmpfbvmb0hMLNzrLUiT3GiUUQ7BXVCgwrzIDtVy5mj4
        Qd+m3GZZPP4jytE1GaG1I8Q=
X-Google-Smtp-Source: ABdhPJxcVX9CPvezhPQqv67sWmqB6Mzda64IEiJujCENVrDbTd0nNEkGR/16OXefb+cWr+rZQWb8hQ==
X-Received: by 2002:a05:6000:1f86:b0:210:20ed:e2c4 with SMTP id bw6-20020a0560001f8600b0021020ede2c4mr510080wrb.200.1653656557508;
        Fri, 27 May 2022 06:02:37 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c08a400b003942a244f48sm1932569wmp.33.2022.05.27.06.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 06:02:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, Jan Kara <jack@suse.cz>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 0/5] xfs fixes for 5.10.y (part 1)
Date:   Fri, 27 May 2022 16:02:14 +0300
Message-Id: <20220527130219.3110260-1-amir73il@gmail.com>
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

Hi Greg and Shasha!

It has been a while since you heard from xfs team.

We are trying to change things and get xfs fixes flowing to stable
again. Crossing my fingers that we will make this last this time :)

Please see this message from Darrick [4] about xfs stable plans.
My team will be focusing on 5.10.y and Ted and Leah's team will be
focusing on 5.15.y at this time.

This v2 is being sent to stable after testing and after v1 was sent
for review of the xfs list [5].

v2 includes an extra patch that Christoph has backported and tested
and was going to send to stable.

Please see my cover letter to xfs with more details about my plans
for 5.10.y below:

Hi all!

During LSFMM 2022, I have had an opportunity to speak with developers
from several different companies that showed interest in collaborating
on the effort of improving the state of xfs code in LTS kernels.

I would like to kick-off this effort for the 5.10 LTS kernel, in the
hope that others will join me in the future to produce a better common
baseline for everyone to build on.

This is the first of 6 series of stable patch candidates that
I collected from xfs releases v5.11..v5.18 [1].

My intention is to post the parts for review on the xfs list on
a ~weekly basis and forward them to stable only after xfs developers
have had the chance to review the selection.

I used a gadget that I developed "b4 rn" that produces high level
"release notes" with references to the posted patch series and also
looks for mentions of fstest names in the discussions on lore.
I then used an elimination process to select the stable tree candidate
patches. The selection process is documented in the git log of [1].

After I had candidates, Luis has helped me to set up a kdevops testing
environment on a server that Samsung has contributed to the effort.
Luis and I have spent a considerable amount of time to establish the
expunge lists that produce stable baseline results for v5.10.y [2].
Eventually, we ran the auto group test over 100 times to sanitize the
baseline, on the following configurations:
reflink_normapbt (default), reflink, reflink_1024, nocrc, nocrc_512.

The patches in this part are from circa v5.11 release.
They have been through 36 auto group runs with the configs listed above
and no regressions from baseline were observed.

At least two of the fixes have regression tests in fstests that were used
to verify the fix. I also annotated [3] the fix commits in the tests.

I would like to thank Luis for his huge part in this still ongoing effort
and I would like to thank Samsung for contributing the hardware resources
to drive this effort.

Your inputs on the selection in this part and in upcoming parts [1]
are most welcome!

Thanks,
Amir.

[1] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.10..5.17-fixes.rst
[2] https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.10.105/xfs/unassigned
[3] https://lore.kernel.org/fstests/20220520143249.2103631-1-amir73il@gmail.com/
[4] https://lore.kernel.org/linux-xfs/Yo6ePjvpC7nhgek+@magnolia/
[5] https://lore.kernel.org/linux-xfs/20220525111715.2769700-1-amir73il@gmail.com/

Changes since v1:
- Send to stable
- Add patch from Christoph

Darrick J. Wong (3):
  xfs: detect overflows in bmbt records
  xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
  xfs: fix an ABBA deadlock in xfs_rename

Dave Chinner (1):
  xfs: Fix CIL throttle hang when CIL space used going backwards

Kaixu Xia (1):
  xfs: show the proper user quota options

 fs/xfs/libxfs/xfs_bmap.c    |  5 +++++
 fs/xfs/libxfs/xfs_dir2.h    |  2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
 fs/xfs/xfs_buf_item.c       | 37 ++++++++++++++++----------------
 fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
 fs/xfs/xfs_inode_item.c     | 14 +++++++++++++
 fs/xfs/xfs_iwalk.c          |  2 +-
 fs/xfs/xfs_log_cil.c        | 22 ++++++++++++++-----
 fs/xfs/xfs_super.c          | 10 +++++----
 9 files changed, 87 insertions(+), 49 deletions(-)

-- 
2.25.1

