Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5153512E19
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 10:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344058AbiD1IWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 04:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344064AbiD1IWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 04:22:06 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F941A0BC7
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 01:18:45 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 43B9D20005;
        Thu, 28 Apr 2022 08:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651133922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KUGEgifrtB5bHjZNrG093fG5oSXYDn/9lTmer7vlEw=;
        b=hz2RKzsCvUr8MauvA0B5n3UJk54fw/36D9nqE4b9wEplt7/29/XKt8iK2iUyfWc9uM2vPg
        Nh/VH18E5owjWLeAa/xjUHbgE4cZ+mt90NLKbC/9PB4MT1V5QrMKnx8xbhBV0ncqLD12Lh
        wZsTj8cNbfUu9WZfpBovdVTrJBDCAEF1rJwpA+x8rk3tGhorVghvNCZFWVp3LDYcb/vNDh
        5t90ckmSvbPo85qpUecFZLGIY6T85buE2h9soljdZKbE6YOE+89QuIFfLFWxXEQZX2s+Qw
        AYa9NkWCNepkImZx5TOaZUMKt4UCkQXiHCm6+cPPjIIyNSvBPzIekhQ2QYvAjA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>, miquel.raynal@bootlin.com
Cc:     richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 2/4] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Thu, 28 Apr 2022 10:18:41 +0200
Message-Id: <20220428081841.120083-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220323170458.5608-3-ikegami.t@gmail.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'0a8e98305f63deaf0a799d5cf5532cc83af035d1'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-03-23 at 17:04:56 UTC, Tokunori Ikegami wrote:
> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
> check correct value") buffered writes fail on S29GL064N. This is
> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
> write completion, where as, chip_good() check expects actual data
> written to the last location to be returned post DQ polling completion.
> Fix is to revert to using chip_good() for S29GL064N which only checks
> for DQ lines to settle down to determine write completion.
> 
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
