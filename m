Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CBB54EBA1
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 22:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiFPUyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 16:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiFPUyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 16:54:11 -0400
X-Greylist: delayed 25331 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Jun 2022 13:54:05 PDT
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EEF5AED6;
        Thu, 16 Jun 2022 13:54:05 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3677FC01C; Thu, 16 Jun 2022 22:54:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655412844; bh=X/9Mnt59MpOxvWO59sXdsi9u5n4Xq1/JhwqX4dEqABs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JoqVs5/UNitWWr0njvnA/+JKPeUjQvQ95A8K6WEcSWEJKRmm9H0yW7blkvGrDgWlH
         AUYSXMobBMbVMg/MxHGCHwqnG56mpLlwKhFfuR2ifjZGNqoX1KZ3h0OQvWvcXQtdVy
         vELCHD4L6Ctaq7cV7jblsJTgzWrheYU3bKbIPCZQTAnKVtpcEVlRPRllNOqGBmu9RQ
         6KS0VI66q2FKjhbgic+sMn7debdfHEgnyd6sXjzddTvMFcN6wog37JjhjeUfzix+NY
         5pf3r8QYkQ7IiYBls+6K+2AmTDrYp1Wzu0NCV02XhuW4Kb6Lr8SkMgrV+FCGTvp7tV
         bOCPC7zEnvZ1Q==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 2D342C009;
        Thu, 16 Jun 2022 22:54:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655412843; bh=X/9Mnt59MpOxvWO59sXdsi9u5n4Xq1/JhwqX4dEqABs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KQYxpI9EUKW9gNY7pUpW5oLCxetbUStRGqpC7RfFJAfas8VEzTfxcg2D1uaZrv58U
         1it6igOsJHiXHaBKCRA7Hl980tJQCvIw8rz7S9hsvwHPWmrzskbOHw6zl7fTz6WBNu
         FhWj0bJ55znDeBC3fnuXK8vgPEdW6+cnQ17o0OwY6YIdq/fsrRQBigLdHJXn8ZpClb
         m1bpoMkSeSCyZTVqriB7qb2xNe9Eca4b0CjUgH76VZvvPbZ5kd7jJ2kL1lauc6gZwP
         LcEB3YoT/6hdWhbXdkY1m/rB57grS610znEtFx7+hNFrdHbO+MZDilr1gXtTlJsTqu
         mEhCmA8ZBPC4Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0a286bde;
        Thu, 16 Jun 2022 20:53:57 +0000 (UTC)
Date:   Fri, 17 Jun 2022 05:53:42 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Message-ID: <YquYVgBMxY37P+r3@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org>
 <Yqs1Y8G/Emi/q+S2@codewreck.org>
 <Yqs6BPVc3rNZ9byJ@codewreck.org>
 <15767273.MGizftpLG7@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15767273.MGizftpLG7@silver>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christian Schoenebeck wrote on Thu, Jun 16, 2022 at 10:14:16PM +0200:
> I tested all 3 variants today, and they were all behaving correctly (no EBADF 
> errors anymore, no other side effects observed).

Thanks!

> The minimalistic version (i.e. your initial suggestion) performed 20% slower 
> in my tests, but that could be due to the fact that it was simply the 1st 
> version I tested, so caching on host side might be the reason. If necessary I 
> can check the performance aspect more thoroughly.

hmm, yeah we open the writeback fids anyway so I'm not sure what would
be really different performance-wise, but I'd tend to go with the most
restricted change anyway.

> Personally I would at least use the NETFS_READ_FOR_WRITE version, but that's 
> up to you. On doubt, clarify with David's plans.
> 
> Feel free to add my RB and TB tags to any of the 3 version(s) you end up 
> queuing:
> 
> Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> Tested-by: Christian Schoenebeck <linux_oss@crudebyte.com>

Thanks, I'll add these and resend the last version for archival on the
list / commit message wording check.

At last that issue closed...
--
Dominique
