Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4AD61A5F1
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 00:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKDXkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 19:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKDXj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 19:39:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627A914D2F;
        Fri,  4 Nov 2022 16:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B676233C;
        Fri,  4 Nov 2022 23:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A715C433C1;
        Fri,  4 Nov 2022 23:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667605196;
        bh=tmoMWpT5+so/JIuOMeg2IvKv4URxdvadXpWW+QhEKxA=;
        h=From:To:Cc:Subject:Date:From;
        b=V1nnrfppQ8j0/0RIqGyX2Ug/ZMF0pLmn2b3hhKJfTsn5adhbCHLmjnQaJ+FIGKhQR
         /ZsA8sfpgXtFLD7CGhGrE3CSKHS9fD169djnOqYpCTnJNP8LWgZWWu2y83mEwp8WvM
         qwsVy/Z6K4mWRnwdShoXD5B1NNI06ek9q3EzgeChKxaD+m/shxMsMyvhnEMnggrLzS
         MZcjsY6Dg+IO15VUUoKRz5T1iO5PeO6vTnWMjV/fMp+vBq4tHz2Ca2q6iMxIgpMU+B
         yDgFQarQyLIukaSeGdjiPdrn2TX4BuFHzyjbAl0kPo+t8RXM36H9Ak8qtGKKwyYiRe
         HXs7idjy7pYXg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 5.10 0/3] fscrypt fixes for stable
Date:   Fri,  4 Nov 2022 16:37:57 -0700
Message-Id: <20221104233800.421135-1-ebiggers@kernel.org>
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

Please apply these to 5.10-stable.

Eric Biggers (3):
  fscrypt: simplify master key locking
  fscrypt: stop using keyrings subsystem for fscrypt_master_key
  fscrypt: fix keyring memory leak on mount failure

 fs/crypto/fscrypt_private.h |  80 ++++--
 fs/crypto/hooks.c           |   8 +-
 fs/crypto/keyring.c         | 495 +++++++++++++++++++-----------------
 fs/crypto/keysetup.c        |  85 +++----
 fs/crypto/policy.c          |   8 +-
 fs/super.c                  |   3 +-
 include/linux/fs.h          |   2 +-
 include/linux/fscrypt.h     |   4 +-
 8 files changed, 360 insertions(+), 325 deletions(-)


base-commit: 95aa34f72132ee42ee3f632a5540c84a5ee8624f
-- 
2.38.1

