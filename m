Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7C564B5D9
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 14:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiLMNN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 08:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiLMNNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 08:13:50 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8927CB1C9;
        Tue, 13 Dec 2022 05:13:49 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h12so15538067wrv.10;
        Tue, 13 Dec 2022 05:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yDI5bdCWdZZzlOmiGvOoOgvZKiDDviSfyVm17rVjVsk=;
        b=qBCouSQmxr6+ROBguOSoO56OU9JnSBgnUrBoIfGHObH0mkn8mf7qgcEPc+y3AiTmgJ
         am9f6ChyvbpvKYoxfryPE4r4Wy7/4wXRnb5gIMt21Fv3//vE4XELNcmuPchTFcRezLPP
         eR140/2vztwOzr1fH2KxOzIF990WAwYwGJV7Vy9TTjyLPAsTl1ONhcOcoLng8SBIBeRB
         dtxYPmjF4/C6NwbVVZw3HfU+CSESsIT76v7UyGE+4/cz1Qo+7EoIIR3wX6pGK+8bvCHd
         HpbwKu9GZfJLqJh0HS4Z1CJ5CfwnwFlRPZC4ckB1b21Vw7UARo0/fZbProQhhQcdNc/r
         35RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDI5bdCWdZZzlOmiGvOoOgvZKiDDviSfyVm17rVjVsk=;
        b=J7z0Kw4MI2qddkkCRlmjmhLuV1B1MlPLQ6Yve47tQK5TWN0TmGPBHElJRFrK4NBO9U
         y9HLDeAXXBbu+23DBqB6zS5BHIRsn97J7LK+WEDewMPwyQOed4vMNXiIDOpahSznM/3O
         m8vnIfW/GL0+MpD/6PD2w346tdXoCmrk/jkQIe8EIE3evs9zR3s9xK1bdEFhVl27r9li
         w0QVP05mmrmxzfH1EyzV1++x4ikScZvPzTkU0x0HIBrdUZZZDlHmWmVsI/bJKkNJDA9c
         Viu5VmZvQN1i1+4RDTP/mZWq39EhDSM/KxPerI370Wnvo/tYt4p4cdqvo0O+gs56jH6/
         ccOQ==
X-Gm-Message-State: ANoB5pm9EHGE9tc6oqgod4IHeTnvFxJ1b65pyTwjjRsEY5LZslGGUoEt
        FYPc3A5D3suVbKoW094vjKM=
X-Google-Smtp-Source: AA0mqf7k5seT/SunAnq4uw2GXSie/3aFA1Si+3tP4HQbelhbYDS3AGsZ+qJ7Q0Zr9AORcWyDqdJBqw==
X-Received: by 2002:a05:6000:81b:b0:242:5a80:79b8 with SMTP id bt27-20020a056000081b00b002425a8079b8mr12136263wrb.20.1670937227991;
        Tue, 13 Dec 2022 05:13:47 -0800 (PST)
Received: from localhost.localdomain ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id y11-20020adff14b000000b002365b759b65sm11643563wro.86.2022.12.13.05.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 05:13:47 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 0/2] cross-fs copy_file_range() fixes for stable
Date:   Tue, 13 Dec 2022 15:13:39 +0200
Message-Id: <20221213131341.951049-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Greg,

The recent history of copy_file_range() API is somewhat convoluted.
The API changes are documented in copy_file_range(2) man page.
I've just posted a man page update patch [1] to fix some wrong kernel
version references in the man page.

The problem is that it took many kernel releases to get reports on the
regression from v5.3 and yet more releases (v5.12..v5.19) to work on
the solution and get it merged.

This situation leads to confusion among users as can be seen in [2].
You've already picked the patch [1/2] to 5.15.y and I sent you a
request to pick patch [2/2] (from v6.1) as well.

Following are backports of the two patches to 5.10.y, which I verified
with the relevant test in fstests.

Backport to 5.4.y is more challenging because Darrick did a lot of
cleanup in that area between v5.4..v5.10, so I did not do it.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20221213120834.948163-1-amir73il@gmail.com/
[2] https://bugzilla.kernel.org/show_bug.cgi?id=216800

Amir Goldstein (2):
  vfs: fix copy_file_range() regression in cross-fs copies
  vfs: fix copy_file_range() averts filesystem freeze protection

 fs/nfsd/vfs.c      |  8 ++++-
 fs/read_write.c    | 90 +++++++++++++++++++++++++++++++++---------------------
 include/linux/fs.h |  8 +++++
 3 files changed, 70 insertions(+), 36 deletions(-)

-- 
2.16.5

