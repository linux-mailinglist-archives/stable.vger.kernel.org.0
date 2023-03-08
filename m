Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9F76B062A
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 12:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCHLlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 06:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjCHLlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 06:41:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD23DBCBB4;
        Wed,  8 Mar 2023 03:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 262EA61771;
        Wed,  8 Mar 2023 11:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8E0C433EF;
        Wed,  8 Mar 2023 11:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678275662;
        bh=LXuLcy/BU77paloSOpd1HXNqAE4YousTRArCjQgs+Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6WB3N5LWW7NGzO6FK6uqhqeVn5fwRPR9GnQZ6Nk+p5kpA0jZqcRt7FeCzbBGnFRC
         ZMBRIuRh+xqvyisNOmZKAjANiyecnlEyiBo1GAEMI4xgLa2+wJh1zR/XgmQPnEo7TN
         LkHNSC/YLsYR2ZQ+QuEP3XRkqVSiMI8yuoYeOtlxQS3IOoP/zNYZRFLF3WhPq0SHf0
         MG86WgDqXCM9Zcci/kYB8MJE8+0DlReNNt+Scnzvoehy5S8vHBUnz66oiLMQnQ14ji
         a0+mv8fQXZJnLLaiLADftObY/Ylqx67G5KMLQ6To31+Kj+OqPCSmQLGUwR8i2E88eg
         eoEzHjxUB7PLQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Christian Brauner <brauner@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        stable@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCH 1/2] fork: allow CLONE_NEWTIME in clone3 flags
Date:   Wed,  8 Mar 2023 12:40:54 +0100
Message-Id: <167827558168.733158.936883559456207607.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308105126.10107-1-tklauser@distanz.ch>
References: <20230308105126.10107-1-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=958; i=brauner@kernel.org; h=from:subject:message-id; bh=NrJZ6zWLFAx1AJcdkbtCXTaTJn9AU4ih9e5ikCQQcLA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRwlNixL3dij/u+fwbngjsigvMlnc4uW8Rpl+O1ZMJbAeaw k4fedpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykuofhf+CypQ4zlvifUf9RwR1dMa P2zF3bbOPWAi5jnYLmouYJ7owMu+JThQ9n7Dj3n+FsQd7trQn3q64yeyasyb1m2ZjuF+LKDAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner (Microsoft) <brauner@kernel.org>


On Wed, 08 Mar 2023 11:51:26 +0100, Tobias Klauser wrote:
> Currently, calling clone3() with CLONE_NEWTIME in clone_args->flags
> fails with -EINVAL. This is because CLONE_NEWTIME intersects with
> CSIGNAL. However, CSIGNAL was deprecated when clone3 was introduced in
> commit 7f192e3cd316 ("fork: add clone3"), allowing re-use of that part
> of clone flags.
> 
> Fix this by explicitly allowing CLONE_NEWTIME in clone3_args_valid. This
> is also in line with the respective check in check_unshare_flags which
> allow CLONE_NEWTIME for unshare().
> 
> [...]

Thanks for fixing this. Applied, thanks! If someone has already picked this
up/prefers to carry it just let me know and I'll happily drop it,

[1/2] fork: allow CLONE_NEWTIME in clone3 flags
      commit: a402f1e35313fc7ce2ca60f543c4402c2c7c3544
[2/2] selftests/clone3: test clone3 with CLONE_NEWTIME
      commit: 515bddf0ec4155cbd666d72daf5bd68c8b7cd987

Thanks!
Christian
