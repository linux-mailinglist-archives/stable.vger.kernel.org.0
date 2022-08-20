Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1C259ACBE
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 10:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343915AbiHTItq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbiHTItp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 04:49:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680339F0E2;
        Sat, 20 Aug 2022 01:49:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 04E2E1F954;
        Sat, 20 Aug 2022 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660985383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=m+bj0TPkbIt/OGPn4aAbobmANUXDrYZ9GeVNZa2EDeA=;
        b=uzN7BF6gHWUeGKLW5UV1df8+P8YgN50tl3QYTVC7cEI6AVdXzGkT7pR0Uo5FkZMA2eKbJg
        +wVYI+joRh0hCLCtHnZCr9AItmZ/RpZe45ub/xLGCjJq2OMINeJ/D1T6E4sW70omm23VeC
        mHv7V4JRwKVzqDEvVwa4sWDaRH09/gg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE77613523;
        Sat, 20 Aug 2022 08:49:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1ccbKyWgAGNGKAAAMHmgww
        (envelope-from <wqu@suse.com>); Sat, 20 Aug 2022 08:49:41 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH STABLE 4.14 0/2] btrfs: raid56: backporst to reduce corruption
Date:   Sat, 20 Aug 2022 16:49:21 +0800
Message-Id: <cover.1660985049.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the backport for v4.19.x stable branch.

The full explananation can be found here:
https://lore.kernel.org/linux-btrfs/cover.1660891713.git.wqu@suse.com/

No code change between v4.14.x and v4.19.x, at least nothing git can not
auto-resolve.

Testing wise, this is beyond my testing environment.
Although latest GCC compiles without problem, the result kernel can not
be properly boot at all, not even any kernel early boot message.

I'm not sure if this is something related to latest edk2 UEFI or
something else, I can no longer do proper testing for any older branch,
including this 4.19 one.

Thus I can not do any guarantee on these backports, unfortunately
the backports can only go to v5.x branches for now.

Unless anyone has better ideas how to build and run older kernels with
latest edk2 UEFI environment.

Qu Wenruo (2):
  btrfs: only write the sectors in the vertical stripe which has data
    stripes
  btrfs: raid56: don't trust any cached sector in
    __raid56_parity_recover()

 fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
2.37.1

