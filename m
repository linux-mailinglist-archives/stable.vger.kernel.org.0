Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB116A5205
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 04:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjB1DrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 22:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB1DrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 22:47:21 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6F6A7;
        Mon, 27 Feb 2023 19:47:20 -0800 (PST)
Date:   Tue, 28 Feb 2023 03:42:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
        s=mail; t=1677555735;
        bh=4QIrEN7lL2RgUPg8MkYCSa9pDpjxQVjS5El8kkLpfFc=;
        h=Date:From:To:Cc:Subject:From;
        b=B0QR2ry2rSdIOENJ/9fEocSm/Ok/tpa6k0CFeDyOpJOrpLQTIUU3ov5J6IBrHDVCS
         mE5hqJM+zwDAYbAiiS2QU34xtBP2PUtlRHNRqb1xkKST7V4aIKKhW9udfRhqVta0l7
         hTzrLVa/y2Z588t8qKEx4VMlgZHp6DMziLce5Xco=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     stable@vger.kernel.org
Cc:     Storm Dragon <stormdragon2976@gmail.com>,
        Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Please backport commit ae3419fbac84 ("vc_screen: don't clobber
 return value in vcs_read")
Message-ID: <15acd998-ea8a-4897-9920-dd19fc06a996@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please backport the following commit[0] to all stable releases that
contain the commit
226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")

Commit 46d733d0efc7 ("vc_screen: modify vcs_size() handling in vcs_read()") [1]
also tries to fix this commit but should not actually be necessary for a
proper fix. It may make sense to also backport for consistency.


commit ae3419fbac845b4d3f3a9fae4cc80c68d82cdf6e
Author: Thomas Weißschuh <linux@weissschuh.net>
Date:   Mon Feb 20 06:46:12 2023 +0000

    vc_screen: don't clobber return value in vcs_read
    
    Commit 226fae124b2d ("vc_screen: move load of struct vc_data pointer in
    vcs_read() to avoid UAF") moved the call to vcs_vc() into the loop.
    
    While doing this it also moved the unconditional assignment of
    
            ret = -ENXIO;
    
    This unconditional assignment was valid outside the loop but within it
    it clobbers the actual value of ret.
    
    To avoid this only assign "ret = -ENXIO" when actually needed.
    
    [ Also, the 'goto unlock_out" needs to be just a "break", so that it
      does the right thing when it exits on later iterations when partial
      success has happened - Linus ]
    
    Reported-by: Storm Dragon <stormdragon2976@gmail.com>
    Link: https://lore.kernel.org/lkml/Y%2FKS6vdql2pIsCiI@hotmail.com/
    Fixes: 226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")
    Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
    Link: https://lore.kernel.org/lkml/64981d94-d00c-4b31-9063-43ad0a384bde@t-8ch.de/
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Thanks,
Thomas

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ae3419fbac845b4d3f3a9fae4cc80c68d82cdf6e
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=46d733d0efc79bc8430d63b57ab88011806d5180
