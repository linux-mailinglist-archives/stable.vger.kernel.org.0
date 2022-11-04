Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8EA61A4EE
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 23:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKDWzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 18:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKDWzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 18:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A776464;
        Fri,  4 Nov 2022 15:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B5AD62262;
        Fri,  4 Nov 2022 22:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C279C433C1;
        Fri,  4 Nov 2022 22:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667602550;
        bh=gI/1/YvwK2fZ3oaZuGkDzBJJRoPGLxYviRWYBDCg+RE=;
        h=From:To:Cc:Subject:Date:From;
        b=QBAOqtdaI8TNbeVd/cv2xpy9SMCXByjm+ycQNcqwkol9G53u4A4ZiJ/Dpzn4olCz0
         CAxSxlb1dK3K73zDP5fhl6McsMHcyL1ifCRyvkoFhhvbNj89Z7BA9yR4ycBJNsYcqK
         scrag3Dx83rir/9NrkcNup/ufZhtVIVi8qArxa8h3hpxE8OuqmLFYoeSedKqVCMepJ
         RCIexjc0fFDTF7MYCXYXou9UocBINnY1miiw8OIDq7ORPZOyx2KDmgF1XUzV7VLK1r
         pgZi8fMuT6K9LjtWQ2yPDpy5CqcWKtbpFvW9OY/evU2tOlDaOiMxRYrbvb2HNo/BEu
         Ev1oW/lZE82YQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 6.0 0/2] fscrypt fixes for stable
Date:   Fri,  4 Nov 2022 15:54:37 -0700
Message-Id: <20221104225439.338239-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply these to 6.0-stable.

Eric Biggers (2):
  fscrypt: stop using keyrings subsystem for fscrypt_master_key
  fscrypt: fix keyring memory leak on mount failure

 fs/crypto/fscrypt_private.h |  71 ++++--
 fs/crypto/hooks.c           |  10 +-
 fs/crypto/keyring.c         | 491 +++++++++++++++++++-----------------
 fs/crypto/keysetup.c        |  81 +++---
 fs/crypto/policy.c          |   8 +-
 fs/super.c                  |   3 +-
 include/linux/fs.h          |   2 +-
 include/linux/fscrypt.h     |   4 +-
 8 files changed, 359 insertions(+), 311 deletions(-)


base-commit: 3a2fa3c01fc7c2183eb3278bd912e5bcec20eb2a
-- 
2.38.1

