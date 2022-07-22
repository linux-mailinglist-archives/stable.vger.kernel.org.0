Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E669957E2B7
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiGVN6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 09:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiGVN6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 09:58:41 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87909904DC;
        Fri, 22 Jul 2022 06:58:40 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26MDwTbR016736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 09:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1658498310; bh=nrI8dhJqfy/c5qVm6+i8T9D+VQQkNHrMFFhXC0I/R+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WpCF8n1K530MRkLZ5TplOe1xCMNAx62uXGR80euDaO2pf/rh2hGpbNN/3SZjAeSph
         mMzg/f6uSIAxI3ya2eHF5egVfTyNJAg/pesfWDByLio9HIaIuBGjzbC90J2S1dV+VK
         VnYOupdl8657uQmxWPKwlgXQHq0ztfA5YaQgP+WY7Nrlg+NJ6I5ogicGM4bo2Ulz9L
         CTJke8BMS4ExfAIIDnGLthvh9pwLu0PN4d0zW1sGTiPKQP4Iv8bjaMYd6+a4iIiSor
         Jmaq/mNPHDfrvevt/h4Huk9TeTo2DP9XRYoZFOz4w4W3GNRYQeTBhAEEuZzDRqoiLS
         o0zEBg9RLbNhQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6EF6815C3F02; Fri, 22 Jul 2022 09:58:27 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: check if directory block is within i_size
Date:   Fri, 22 Jul 2022 09:58:16 -0400
Message-Id: <165849767595.303416.1808968339954270899.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220704142721.157985-1-lczerner@redhat.com>
References: <20220704142721.157985-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Jul 2022 16:27:20 +0200, Lukas Czerner wrote:
> Currently ext4 directory handling code implicitly assumes that the
> directory blocks are always within the i_size. In fact ext4_append()
> will attempt to allocate next directory block based solely on i_size and
> the i_size is then appropriately increased after a successful
> allocation.
> 
> However, for this to work it requires i_size to be correct. If, for any
> reason, the directory inode i_size is corrupted in a way that the
> directory tree refers to a valid directory block past i_size, we could
> end up corrupting parts of the directory tree structure by overwriting
> already used directory blocks when modifying the directory.
> 
> [...]

Applied, thanks!

[1/2] ext4: check if directory block is within i_size
      commit: 65d23bd6e76ae07cee50c24d1fbeea4044aa41e7
[2/2] ext4: make sure ext4_append() always allocates new block
      commit: 6d3ab9450ea5ec08882ab2f255827f1a39e300de

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
