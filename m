Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4FB6E769F
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjDSJqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjDSJqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:46:33 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85181D8;
        Wed, 19 Apr 2023 02:46:32 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a814fe0ddeso8290745ad.2;
        Wed, 19 Apr 2023 02:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897591; x=1684489591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OuVCkulnYwljhm5+j4k0UbJeX1zXqWjkxukNgFx+ljw=;
        b=VTVuupaHllpryumNY+deJmCD9AQRwRgzCvVtn6zaKZ6S/PTK4KqDrQNQA/1xKYvpV0
         oyTIQp85oR6vSwCuUZtojMPXA7Xpl63JBvV9DfK4f+CRrNpHPSoxJiUmXc+TejPA98FN
         Cgt/3rEb9b7+OmdwZwMHmadX5jKyKCOHcQtFsQAeP2zENkMjV7CeXGBseXHNK2Gnefy2
         PcShdXzacbvPXOGhr7Yjhk+9Cjo2K1KvfAwncvmco9rWeKDBYALk+MFUewCOeJ6rSjA3
         5wWmDTZOXdv6IIiRH6CDFj5DDjncsvzTSQo1pEt3JRoBu+JPaSiUkoH047+lN+NrKdR5
         YRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897591; x=1684489591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OuVCkulnYwljhm5+j4k0UbJeX1zXqWjkxukNgFx+ljw=;
        b=QnvmxA3xCoNtrkH+kDpytqeTjIJytIPGs9reO8iGkkFw7+vEOkgdfS3AaA8DoXPumq
         hgam2Eu2VDwGt1qQva29lQB+VfkfZ25ts1SzgBsy350ryEQybT/Kxec6P89fRw+0A7Cf
         /5QjkGM6QvehuHD5ygwR2z5VUDfVW/0Yc5DqY1oQDrixNpw78VPEzCdYtzpWc6TUSqEw
         1SkXsxHlOEqMBcmGPczPAF6ug041tkeGa8IRjjGlWJXYG9n3wWdi1F+F30XhL5U6UVEt
         ZS/smad0x/gKeVPla7xvWS+SlccGT3pBHRBECUirdCs5XeisECIsRzqZE47jiqVwv+2Y
         DVkw==
X-Gm-Message-State: AAQBX9f8BW4Wh35IQrQ4f5Nf3Hszbfq2GtV7sp7Z5FtKnbTVUsQFM2UH
        84rV5usU7bQOl2S1PIGejFUdsVKcoZAa7DoG
X-Google-Smtp-Source: AKy350b/tsE4Zp7rrGhCpn4mBSbH7udLbQIN9vQ1NjI1a2p4h9UMJ7+We4nCqms4k8qjKt8o18P0Nw==
X-Received: by 2002:a17:902:b110:b0:1a0:48c6:3b43 with SMTP id q16-20020a170902b11000b001a048c63b43mr4729803plr.37.1681897591470;
        Wed, 19 Apr 2023 02:46:31 -0700 (PDT)
Received: from localhost.localdomain ([120.26.165.80])
        by smtp.gmail.com with ESMTPSA id j12-20020a17090276cc00b001a674fb0dd8sm11029421plt.247.2023.04.19.02.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:46:30 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 0/6] Backport several fuse patches to 5.10.y
Date:   Wed, 19 Apr 2023 17:46:16 +0800
Message-Id: <20230419094622.51065-1-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Antgroup is using 5.10.y in product environment, we found several patches are
missing in 5.10.y tree. These patches are needed for us. So we backported them
to 5.10.y. Also backport to 5.15.y and 6.1.y to prevent regression.

Connor Kuehl (1):
  virtiofs: split requests that exceed virtqueue size

Jiachen Zhang (1):
  fuse: always revalidate rename target dentry

Miklos Szeredi (4):
  virtiofs: clean up error handling in virtio_fs_get_tree()
  fuse: check s_root when destroying sb
  fuse: fix attr version comparison in fuse_read_update_size()
  fuse: fix deadlock between atomic O_TRUNC and page invalidation

 fs/fuse/dir.c       |  7 ++++++-
 fs/fuse/file.c      | 31 +++++++++++++++++-------------
 fs/fuse/fuse_i.h    |  3 +++
 fs/fuse/inode.c     |  5 +++--
 fs/fuse/virtio_fs.c | 46 +++++++++++++++++++++++++++++----------------
 5 files changed, 60 insertions(+), 32 deletions(-)

-- 
2.40.0

